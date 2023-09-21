//
//  HUIHostEventDecoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitControlSurfaces
import XCTest

final class HUIHostEventDecoderTests: XCTestCase {
    /// Verifies that a HUI event encodes and decodes back to itself.
    func runHUIEventTest(
        _ sourceEvent: HUIHostEvent,
        matches outputEvents: [HUIHostEvent]? = nil
    ) {
        var decodedEvents: [HUIHostEvent] = []
        let decoder = HUIHostEventDecoder { huiEvent in
            decodedEvents.append(huiEvent)
        }
        let midiEvents = sourceEvent.encode()
        decoder.midiIn(events: midiEvents)
        
        let eventsToMatch = outputEvents ?? [sourceEvent]
        
        XCTAssertEqual(decodedEvents, eventsToMatch)
    }
    
    /// Verifies that a raw HUI MIDI message decodes back to the given HUI event(s).
    func runHUIEventTest(
        source sourceMIDI: MIDIEvent,
        matches outputEvents: [HUIHostEvent]
    ) {
        var decodedEvents: [HUIHostEvent] = []
        let decoder = HUIHostEventDecoder { huiEvent in
            decodedEvents.append(huiEvent)
        }
        decoder.midiIn(event: sourceMIDI)
        XCTAssertEqual(decodedEvents, outputEvents)
    }
    
    func testPing() {
        runHUIEventTest(.ping)
    }
    
    func testSwitch() {
        runHUIEventTest(
            .switch(huiSwitch: .channelStrip(2, .solo), state: true)
        )
    }
    
    func testFaderLevel() {
        runHUIEventTest(
            .faderLevel(channelStrip: 2, level: .midpoint)
        )
    }
    
    func testLevelMeter() {
        runHUIEventTest(
            .levelMeter(channelStrip: 2, side: .right, level: 8)
        )
    }
    
    func testVPot() {
        runHUIEventTest(
            .vPot(
                vPot: .editAssignA,
                display: .init(leds: .single(.L5), lowerLED: false)
            )
        )
    }
    
    func testLargeDisplay() {
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
    
    func testTimeDisplay() {
        runHUIEventTest(
            .timeDisplay(charsRightToLeft: [.num8, .num1, .num0, .num1])
        )
    }
    
    func testSelectAssignDisplay() {
        runHUIEventTest(
            .selectAssignDisplay(text: .init(chars: [.num1, .num2, .num3, .num4]))
        )
    }
    
    func testChannelDisplay() {
        runHUIEventTest(
            .channelDisplay(channelStrip: 2, text: .init(chars: [.num1, .num2, .num3, .num4]))
        )
    }
    
    // MARK: - Edge Cases
    
    func testSmallText_MultipleInSingleSysEx() throws {
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

#endif
