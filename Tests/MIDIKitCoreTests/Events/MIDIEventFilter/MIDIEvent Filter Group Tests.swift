//
//  MIDIEvent Filter Group Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_Group_Tests {
    @Test
    func filterGroup() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
        
        #expect(
            events.filter(group: 0) ==
                [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
        
        #expect(
            events.filter(group: 1) ==
                [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
        
        #expect(events.filter(group: 2) == [])
    }
    
    @Test
    func filterGroups() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
        
        #expect(events.filter(groups: []) == [])
        
        #expect(
            events.filter(groups: [0]) ==
                [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
        
        #expect(
            events.filter(groups: [1]) ==
                [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
        
        #expect(
            events.filter(groups: [0, 1]) ==
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
        
        #expect(
            events.filter(groups: [0, 2]) ==
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
        
        #expect(events.filter(groups: [2]) == [])
    }
    
    @Test
    func dropGroup() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
        
        #expect(
            events.drop(group: 0) ==
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
        
        #expect(
            events.drop(group: 1) ==
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
        
        #expect(
            events.drop(group: 2) ==
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
    }
    
    @Test
    func dropGroups() {
        let events: [MIDIEvent] = [
            .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
            .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
        ]
        
        #expect(
            events.drop(groups: []) ==
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
        
        #expect(
            events.drop(groups: [0]) ==
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
        
        #expect(
            events.drop(groups: [1]) ==
            [.noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0)]
        )
        
        #expect(events.drop(groups: [0, 1]) == [])
        
        #expect(
            events.drop(groups: [0, 2]) ==
            [.noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)]
        )
        
        #expect(
            events.drop(groups: [2]) ==
            [
                .noteOn(60, velocity: .unitInterval(0.5), channel: 1, group: 0),
                .noteOff(60, velocity: .unitInterval(0.0), channel: 1, group: 1)
            ]
        )
    }
}
