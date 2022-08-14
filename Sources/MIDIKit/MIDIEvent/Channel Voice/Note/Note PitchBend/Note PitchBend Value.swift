//
//  Note PitchBend Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.Note.PitchBend {
    /// Channel Voice 32-Bit Value
    /// (MIDI 2.0)
    public typealias Value = MIDIEvent.ChanVoice32BitValue
    
    public typealias ValueValidated = MIDIEvent.ChanVoice32BitValue.Validated
}
