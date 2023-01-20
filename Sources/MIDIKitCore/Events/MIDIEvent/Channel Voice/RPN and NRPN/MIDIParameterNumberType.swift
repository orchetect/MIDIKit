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

extension MIDIParameterNumberType {
    func umpStatusNibble(for change: MIDI2ParameterNumberValueType) -> UInt4 {
        switch self {
        case .registered:
            switch change {
            case .absolute:
                return 0x2
            case .relative:
                return 0x4
            }
            
        case .assignable:
            switch change {
            case .absolute:
                return 0x3
            case .relative:
                return 0x5
            }
        }
    }
}
