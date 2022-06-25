//
//  PitchBend Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.PitchBend {
    
    /// Channel Voice 14-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value
    public typealias Value = MIDI.Event.ChanVoice14Bit32BitValue
    
    public typealias ValueValidated = MIDI.Event.ChanVoice14Bit32BitValue.Validated
    
}
