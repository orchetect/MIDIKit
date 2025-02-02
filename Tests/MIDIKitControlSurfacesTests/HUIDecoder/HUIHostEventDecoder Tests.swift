//
//  HUIHostEventDecoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import Testing

@Suite struct HUIHostEventDecoderTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func ping() {
        runHUIEventTest(.ping)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func huiSwitch() {
        runHUIEventTest(
            .switch(huiSwitch: .channelStrip(2, .solo), state: true)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func faderLevel() {
        runHUIEventTest(
            .faderLevel(channelStrip: 2, level: .midpoint)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func levelMeter() {
        runHUIEventTest(
            .levelMeter(channelStrip: 2, side: .right, level: 8)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func vPot() {
        runHUIEventTest(
            .vPot(
                vPot: .editAssignA,
                display: .init(leds: .single(.L5), lowerLED: false)
            )
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func largeDisplay() {
        runHUIEventTest(
            .largeDisplay(slices: [
                1: [.A, .B, .C, .D, .E, .F, .G, .H, .I, .J]
            ])
        )

        // since large display slices each get encoded to separate SysEx MIDI messages,
        // they will be decoded as separate HUICoreEvent events
        runHUIEventTest(
            .largeDisplay(slices: [
                1: [.A, .B, .C, .D, .E, .F, .G, .H, .I, .J],
                4: [.Z, .Y, .X, .W, .V, .U, .T, .S, .R, .Q]
            ]),
            matches: [
                .largeDisplay(slices: [1: [.A, .B, .C, .D, .E, .F, .G, .H, .I, .J]]),
                .largeDisplay(slices: [4: [.Z, .Y, .X, .W, .V, .U, .T, .S, .R, .Q]])
            ]
        )
        
        // char counts != 10 are invalid and would result in malformed HUI SysEx data
        runHUIEventTest(
            .largeDisplay(slices: [
                2: [.A]
            ]),
            matches: []
        )
        
        runHUIEventTest(
            .largeDisplay(slices: [
                1: [.A, .B]
            ]),
            matches: []
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func timeDisplay() {
        runHUIEventTest(
            .timeDisplay(charsRightToLeft: [.num8, .num1, .num0, .num1])
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func selectAssignDisplay() {
        runHUIEventTest(
            .selectAssignDisplay(text: .init(chars: [.num1, .num2, .num3, .num4]))
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func channelDisplay() {
        runHUIEventTest(
            .channelDisplay(channelStrip: 2, text: .init(chars: [.num1, .num2, .num3, .num4]))
        )
    }
    
    // MARK: - Edge Cases
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func smallText_MultipleInSingleSysEx() throws {
        try runHUIEventTest(
            source: .sysEx7(
                manufacturer: HUIConstants.kMIDI.kSysEx.kManufacturer,
                data: [
                    0x05, 0x00, // SysEx sub ID 1 & 2
                    0x10, // small text ID
                    0x00, // display index
                    0x31, 0x32, 0x33, 0x34, // "1234"
                    0x01, // display index
                    0x35, 0x36, 0x37, 0x38 // "5678"
                ]
            ),
            matches: [
                .channelDisplay(channelStrip: 0, text: .init(chars: [.num1, .num2, .num3, .num4])),
                .channelDisplay(channelStrip: 1, text: .init(chars: [.num5, .num6, .num7, .num8]))
            ]
        )
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUIHostEventDecoderTests {
    private final class Receiver: @unchecked Sendable {
        var decodedEvents: [HUIHostEvent] = []
    }
    
    /// Verifies that a HUI event encodes and decodes back to itself.
    func runHUIEventTest(
        _ sourceEvent: HUIHostEvent,
        matches outputEvents: [HUIHostEvent]? = nil
    ) {
        let receiver = Receiver()
        
        let decoder = HUIHostEventDecoder { huiEvent in
            receiver.decodedEvents.append(huiEvent)
        }
        let midiEvents = sourceEvent.encode()
        decoder.midiIn(events: midiEvents)
        
        let eventsToMatch = outputEvents ?? [sourceEvent]
        
        #expect(receiver.decodedEvents == eventsToMatch)
    }
    
    /// Verifies that a raw HUI MIDI message decodes back to the given HUI event(s).
    func runHUIEventTest(
        source sourceMIDI: MIDIEvent,
        matches outputEvents: [HUIHostEvent]
    ) {
        let receiver = Receiver()
        
        let decoder = HUIHostEventDecoder { huiEvent in
            receiver.decodedEvents.append(huiEvent)
        }
        decoder.midiIn(event: sourceMIDI)
        #expect(receiver.decodedEvents == outputEvents)
    }
}
