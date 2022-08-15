//
//  MIDIEvent Filter Group Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEvent_Filter_Group_Tests: XCTestCase {
    func testFilterGroup() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
    
        XCTAssertEqual(
            events.filter(group: 0),
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
    
        XCTAssertEqual(
            events.filter(group: 1),
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
    
        XCTAssertEqual(events.filter(group: 2), [])
    }
    
    func testFilterGroups() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
    
        XCTAssertEqual(events.filter(groups: []), [])
    
        XCTAssertEqual(
            events.filter(groups: [0]),
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
    
        XCTAssertEqual(
            events.filter(groups: [1]),
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
    
        XCTAssertEqual(
            events.filter(groups: [0, 1]),
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
    
        XCTAssertEqual(
            events.filter(groups: [0, 2]),
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
    
        XCTAssertEqual(events.filter(groups: [2]), [])
    }
    
    func testDropGroup() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
    
        XCTAssertEqual(
            events.drop(group: 0),
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
    
        XCTAssertEqual(
            events.drop(group: 1),
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
    
        XCTAssertEqual(
            events.drop(group: 2),
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
    }
    
    func testDropGroups() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
    
        XCTAssertEqual(
            events.drop(groups: []),
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
    
        XCTAssertEqual(
            events.drop(groups: [0]),
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
    
        XCTAssertEqual(
            events.drop(groups: [1]),
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
    
        XCTAssertEqual(events.drop(groups: [0, 1]), [])
    
        XCTAssertEqual(
            events.drop(groups: [0, 2]),
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
    
        XCTAssertEqual(
            events.drop(groups: [2]),
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
    }
}

#endif
