//
//  SendsMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

/// Protocol that objects can adopt so MIDIKit knows they are capable of sending MIDI events.
///
/// Adoption of this protocol is a convenience and not required.
public protocol SendsMIDIEvents: AnyObject where Self: Sendable {
    /// Handler used when calling `midiOut()` methods.
    typealias MIDIOutHandler = @Sendable (_ events: [MIDIEvent]) -> Void
    
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
