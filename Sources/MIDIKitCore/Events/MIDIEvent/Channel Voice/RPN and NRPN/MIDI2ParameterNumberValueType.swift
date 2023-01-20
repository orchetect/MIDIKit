//
//  MIDI2ParameterNumberValueType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

/// MIDI 2.0 Parameter Number value type.
/// Determines whether an RPN/NRPN message's value is absolute or a relative change.
///
/// > MIDI 2.0 Spec:
/// >
/// > In addition to the previously-existing absolute-value RPN/NRPN messages in MIDI 1.0, MIDI 2.0
/// > introduces relative-value RPN/NRPN messages.
/// >
/// > Relative messages act upon the same address space as the MIDI 2.0 Protocol’s Registered
/// > Controllers (RPNs) and MIDI 2.0 Assignable Controllers (NRPNs), and use the same controller
/// > Banks. However, these Relative controllers cannot be translated to the MIDI 1.0 Protocol.
public enum MIDI2ParameterNumberValueType: Equatable, Hashable, CaseIterable {
    case absolute
    case relative
}

extension MIDI2ParameterNumberValueType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .absolute:
            return "absolute"
        case .relative:
            return "relative"
        }
    }
}
