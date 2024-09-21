//
//  MIDIParameterNumberEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol which all Parameter Number events conform.
/// This includes RPN (Registered Controller) and NRPN (Assignable Controller).
public protocol MIDIParameterNumberEvent: Sendable {
    associatedtype P: MIDIParameterNumber
    
    /// Type-erased Parameter Number.
    var parameter: P { get set }
    
    /// MIDI 2.0 Parameter Number value type.
    /// Determines whether the value is absolute or a relative change.
    /// (MIDI 1.0 will always be absolute and this property is ignored.)
    var change: MIDI2ParameterNumberChange { get set }
}

extension MIDIParameterNumberEvent {
}
