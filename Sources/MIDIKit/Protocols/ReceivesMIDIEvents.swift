//
//  ReceivesMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
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
