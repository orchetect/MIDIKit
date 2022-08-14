//
//  ReceivesMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

public protocol ReceivesMIDIEvents {
    /// Process MIDI events.
    func midiIn(event: MIDIEvent)
    
    /// Process MIDI events.
    func midiIn(events: [MIDIEvent])
}

extension ReceivesMIDIEvents {
    public func midiIn(events: [MIDIEvent]) {
        for event in events {
            midiIn(event: event)
        }
    }
}
