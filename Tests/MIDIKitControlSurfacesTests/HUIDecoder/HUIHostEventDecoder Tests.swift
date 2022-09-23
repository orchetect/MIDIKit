//
//  HUIHostEventDecoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitControlSurfaces

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
                display: .init(leds: .singleL5, lowerLED: false)
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
}

#endif
