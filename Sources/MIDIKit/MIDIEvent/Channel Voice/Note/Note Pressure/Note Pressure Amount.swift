//
//  Note Pressure Amount.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDIEvent.Note.Pressure {
    /// Channel Voice 7-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value
    public typealias Amount = MIDIEvent.ChanVoice7Bit32BitValue
    
    public typealias AmountValidated = MIDIEvent.ChanVoice7Bit32BitValue.Validated
}
