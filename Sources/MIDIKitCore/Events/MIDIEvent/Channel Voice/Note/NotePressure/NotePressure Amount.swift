//
//  NotePressure Amount.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIEvent.NotePressure {
    /// Channel Voice 7-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value.
    public typealias Amount = MIDIEvent.ChanVoice7Bit32BitValue
    
    /// Channel Voice 7-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value.
    public typealias AmountValidated = Amount.Validated
}
