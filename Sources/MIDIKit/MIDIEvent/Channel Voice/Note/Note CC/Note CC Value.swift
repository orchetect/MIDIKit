//
//  Note CC Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDIEvent.Note.CC {
    /// Channel Voice 32-Bit Value
    /// (MIDI 2.0)
    public typealias Value = MIDIEvent.ChanVoice32BitValue
    
    public typealias ValueValidated = MIDIEvent.ChanVoice32BitValue.Validated
}
