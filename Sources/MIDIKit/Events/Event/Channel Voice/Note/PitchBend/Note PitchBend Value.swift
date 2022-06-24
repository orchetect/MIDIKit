//
//  Note PitchBend Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note.PitchBend {
    
    /// Channel Voice 32-Bit Value
    /// (MIDI 2.0)
    public typealias Value = MIDI.Event.ChanVoice32BitValue
    
    public typealias ValueValidated = MIDI.Event.ChanVoice32BitValue.Validated
    
}
