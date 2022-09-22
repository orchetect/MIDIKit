//
//  HUIDecoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitControlSurfaces

final class HUIDecoderTests: XCTestCase {
    /// Verifies that a HUI core event encodes and decodes back to itself.
    func runHUICoreEventTest(
        to role: HUIRole,
        _ huiCoreEvent: HUICoreEvent,
        matches: [HUICoreEvent]? = nil
    ) {
        var decodedEvents: [HUICoreEvent] = []
        let decoder = HUIDecoder(role: role) { huiCoreEvent in
            decodedEvents.append(huiCoreEvent)
        }
        let midiEvents = huiCoreEvent.encode(to: role)
        decoder.midiIn(events: midiEvents)
        
        let eventsToMatch = matches ?? [huiCoreEvent]
        
        XCTAssertEqual(decodedEvents, eventsToMatch)
    }
    
    func testPing() {
        HUIRole.allCases.forEach { role in
            runHUICoreEventTest(to: role, .ping)
        }
    }
    
    func testLevelMeters() {
        runHUICoreEventTest(
            to: .surface,
            .levelMeter(channelStrip: 2, side: .right, level: 8)
        )
    }
    
    func testFaderLevel() {
        HUIRole.allCases.forEach { role in
            runHUICoreEventTest(
                to: role,
                .faderLevel(channelStrip: 2, level: .midpoint)
            )
        }
    }
    
    func testVPotDelta() {
        runHUICoreEventTest(
            to: .host,
            .vPot(vPot: .editAssignA, value: 4) // delta rotary knob change
        )
        
        runHUICoreEventTest(
            to: .surface,
            .vPot(vPot: .editAssignA, value: 0x11) // LED ring preset index
        )
    }
    
    func testLargeDisplay() {
        runHUICoreEventTest(
            to: .surface,
            .largeDisplay(slices: [
                1: [.A, .B, .C, .D, .E, .F, .G, .H, .I, .J]
            ])
        )
        
        // since large display slices each get encoded to separate SysEx MIDI messages,
        // they will be decoded as separate HUICoreEvent events
        runHUICoreEventTest(
            to: .surface,
            .largeDisplay(slices: [
                1: [.A, .B, .C, .D, .E, .F, .G, .H, .I, .J],
                4: [.Z, .Y, .X, .W, .V, .U, .T, .S, .R, .Q]
            ]),
            matches: [
                .largeDisplay(slices: [1: [.A, .B, .C, .D, .E, .F, .G, .H, .I, .J]]),
                .largeDisplay(slices: [4: [.Z, .Y, .X, .W, .V, .U, .T, .S, .R, .Q]])
            ]
        )
    }
    
    func testTimeDisplay() {
        runHUICoreEventTest(
            to: .surface,
            .timeDisplay(charsRightToLeft: [.num8, .num1, .num0, .num1])
        )
    }
    
    func testSelectAssignDisplay() {
        runHUICoreEventTest(
            to: .surface,
            .selectAssignDisplay(text: .init(chars: [.num1, .num2, .num3, .num4]))
        )
    }
    
    func testChannelDisplay() {
        runHUICoreEventTest(
            to: .surface,
            .channelDisplay(channelStrip: 2, text: .init(chars: [.num1, .num2, .num3, .num4]))
        )
    }
    
    func testSwitch() {
        HUIRole.allCases.forEach { role in
            runHUICoreEventTest(
                to: role,
                .switch(huiSwitch: .channelStrip(2, .solo), state: true)
            )
        }
    }
}

#endif
