//
//  PitchBend Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDIEvent.PitchBend {
    /// Channel Voice 14-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value
    public typealias Value = MIDIEvent.ChanVoice14Bit32BitValue
    
    public typealias ValueValidated = MIDIEvent.ChanVoice14Bit32BitValue.Validated
}
