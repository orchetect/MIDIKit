//
//  NotePitchBend Value.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NotePitchBend {
    /// Channel Voice 32-Bit Value
    /// (MIDI 2.0)
    public typealias Value = MIDIEvent.ChanVoice32BitValue
    
    /// Channel Voice 32-Bit Value
    /// (MIDI 2.0)
    public typealias ValueValidated = Value.Validated
}
