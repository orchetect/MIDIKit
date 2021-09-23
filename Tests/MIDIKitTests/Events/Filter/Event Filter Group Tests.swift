//
//  Event Filter Group Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_Group_Tests: XCTestCase {
    
    func testFilterGroup() {
        
        let events: [MIDI.Event] = [
            .noteOn(60, velocity: 0.5, channel: 1, group: 0),
            .noteOff(60, velocity: 0.0, channel: 1, group: 1)
        ]
        
        XCTAssertEqual(events.filter(group: 0),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0)])
        
        XCTAssertEqual(events.filter(group: 1),
                       [.noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
        XCTAssertEqual(events.filter(group: 2), [])
        
    }
    
    func testFilterGroups() {
        
        let events: [MIDI.Event] = [
            .noteOn(60, velocity: 0.5, channel: 1, group: 0),
            .noteOff(60, velocity: 0.0, channel: 1, group: 1)
        ]
        
        XCTAssertEqual(events.filter(groups: []), [])
        
        XCTAssertEqual(events.filter(groups: [0]),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0)])
        
        XCTAssertEqual(events.filter(groups: [1]),
                       [.noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
        XCTAssertEqual(events.filter(groups: [0, 1]),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0),
                        .noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
        XCTAssertEqual(events.filter(groups: [0, 2]),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0)])
        
        XCTAssertEqual(events.filter(groups: [2]), [])
        
    }
    
    func testDropGroup() {
        
        let events: [MIDI.Event] = [
            .noteOn(60, velocity: 0.5, channel: 1, group: 0),
            .noteOff(60, velocity: 0.0, channel: 1, group: 1)
        ]
        
        XCTAssertEqual(events.drop(group: 0),
                       [.noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
        XCTAssertEqual(events.drop(group: 1),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0)])
        
        XCTAssertEqual(events.drop(group: 2),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0),
                        .noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
    }
    
    func testDropGroups() {
        
        let events: [MIDI.Event] = [
            .noteOn(60, velocity: 0.5, channel: 1, group: 0),
            .noteOff(60, velocity: 0.0, channel: 1, group: 1)
        ]
        
        XCTAssertEqual(events.drop(groups: []),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0),
                        .noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
        XCTAssertEqual(events.drop(groups: [0]),
                       [.noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
        XCTAssertEqual(events.drop(groups: [1]),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0)])
        
        XCTAssertEqual(events.drop(groups: [0, 1]), [])
        
        XCTAssertEqual(events.drop(groups: [0, 2]),
                       [.noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
        XCTAssertEqual(events.drop(groups: [2]),
                       [.noteOn(60, velocity: 0.5, channel: 1, group: 0),
                        .noteOff(60, velocity: 0.0, channel: 1, group: 1)])
        
    }
    
}

#endif
