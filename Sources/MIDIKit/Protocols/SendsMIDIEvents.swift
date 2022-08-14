//
//  SendsMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol SendsMIDIEvents {
    /// Handler used when calling `midiOut()` methods.
    typealias MIDIOutHandler = ((_ events: [MIDIEvent]) -> Void)
    
    /// Handler used when calling `midiOut()` methods.
    var midiOutHandler: MIDIOutHandler? { get set }
}

extension SendsMIDIEvents {
    /// Transmit a MIDI event.
    public func midiOut(_ event: MIDIEvent) {
        midiOutHandler?([event])
    }
    
    /// Transmit MIDI events.
    public func midiOut(_ events: [MIDIEvent]) {
        midiOutHandler?(events)
    }
}
