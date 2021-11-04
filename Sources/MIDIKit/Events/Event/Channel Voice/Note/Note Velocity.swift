//
//  Note Velocity.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// - remark: MIDI 2.0 Spec:
    ///
    /// The allowable Velocity range for a MIDI 2.0 Note On message is 0x0000-0xFFFF. Unlike the MIDI 1.0 Note On message, a velocity value of zero does not function as a Note Off.
    /// When translating a MIDI 2.0 Note On message to the MIDI 1.0 Protocol, if the translated MIDI 1.0 value of the Velocity is zero, then the Translator shall replace the zero with a value of 1.
    public typealias Velocity = MIDI.Event.ChanVoice7Bit16BitValue
    
    public typealias VelocityValidated = MIDI.Event.ChanVoice7Bit16BitValue.Validated
    
}
