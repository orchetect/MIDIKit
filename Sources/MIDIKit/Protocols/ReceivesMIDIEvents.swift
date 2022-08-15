//
//  ReceivesMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Protocol that objects can adopt so MIDIKit knows they are capable of receiving MIDI events.
public protocol ReceivesMIDIEvents: AnyObject {
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
