//
//  MIDIParameterNumberType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

/// MIDI Parameter Number classification.
/// Determines whether a message is an RPN (registered) or an NRPN (assignable).
public enum MIDIParameterNumberType: Equatable, Hashable, CaseIterable {
    case registered
    case assignable
}

extension MIDIParameterNumberType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .registered:
            return "registered"
        case .assignable:
            return "assignable"
        }
    }
}

extension MIDIParameterNumberType: Sendable { }

extension MIDIParameterNumberType {
    func umpStatusNibble(for change: MIDI2ParameterNumberChange) -> UInt4 {
        MIDIParameterNumberUtils.umpStatusNibble(type: self, change: change)
    }
    
    init?(umpStatusNibble: UInt4) {
        guard let types = MIDIParameterNumberUtils.typeAndChange(
            fromUMPStatusNibble: umpStatusNibble
        ) else { return nil }
        self = types.type
    }
}

extension MIDIParameterNumberType {
    /// CC controller numbers used for non-UMP MIDI 1.0 transmission.
    public var controllers: (
        msb: MIDIEvent.CC.Controller,
        lsb: MIDIEvent.CC.Controller
    ) {
        switch self {
        case .registered:
            return MIDIEvent.RegisteredController.controllers
        case .assignable:
            return MIDIEvent.AssignableController.controllers
        }
    }
}
