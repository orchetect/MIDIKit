//
//  ReceivesMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

public protocol ReceivesMIDIEvents {
    
    /// Process MIDI events.
    func midiIn(event: MIDI.Event)
    
    /// Process MIDI events.
    func midiIn(events: [MIDI.Event])
    
}

extension ReceivesMIDIEvents {
    
    public func midiIn(events: [MIDI.Event]) {
        
        for event in events {
            midiIn(event: event)
        }
        
    }
    
}
