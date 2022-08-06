//
//  SendsMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

public protocol SendsMIDIEvents {
    /// Handler used when calling `midiOut()` methods.
    typealias MIDIOutHandler = ((_ events: [MIDI.Event]) -> Void)
    
    /// Handler used when calling `midiOut()` methods.
    var midiOutHandler: MIDIOutHandler? { get set }
}

extension SendsMIDIEvents {
    /// Transmit a MIDI event.
    public func midiOut(_ event: MIDI.Event) {
        midiOutHandler?([event])
    }
    
    /// Transmit MIDI events.
    public func midiOut(_ events: [MIDI.Event]) {
        midiOutHandler?(events)
    }
}
