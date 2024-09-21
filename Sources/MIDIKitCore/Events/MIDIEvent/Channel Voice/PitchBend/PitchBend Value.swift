//
//  PitchBend Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.PitchBend {
    /// Channel Voice 14-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value.
    public typealias Value = MIDIEvent.ChanVoice14Bit32BitValue
    
    /// Channel Voice 14-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value.
    public typealias ValueValidated = Value.Validated
}
