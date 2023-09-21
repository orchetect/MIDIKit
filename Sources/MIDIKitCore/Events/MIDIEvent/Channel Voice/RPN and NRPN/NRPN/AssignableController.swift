//
//  AssignableController.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Cases describing NRPNs (Non-Registered Parameter Numbers),
    /// also referred to as Assignable Controllers in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of an Assignable Parameter (NRPN), the following
    /// > occurs:
    /// >
    /// > 1. Two Control Change messages are sent using CC 99 (0x63) and 98 (0x62) to select the
    /// > desired Assignable Parameter Number.
    /// >
    /// > 2. When setting the Assignable Parameter to a specific value, CC messages are sent to the
    /// > Data Entry MSB controller (CC 6). If the selected Registered Parameter requires the LSB to
    /// > be set, another CC message is sent to the Data Entry LSB controller (CC 38).
    /// >
    /// > 3. To make a relative adjustment to the selected Assignable Parameter's current value, use
    /// > the Data Increment or Data Decrement controllers (CCs 96 & 97).
    /// >
    /// > For registered Parameter Number use, see RPN (Registered Parameter Numbers).
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > In the MIDI 2.0 Protocol, Registered Controllers (RPN) and Assignable Controllers (NRPN)
    /// > use a single, unified message, making them much easier to use.
    /// >
    /// > As a result, CC 6, 38, 98, 99, 100, and 101 are not to be used in standalone CC messages,
    /// > as the new MIDI 2.0 RPN/NRPN UMP messages replace them.
    /// >
    /// > Assignable Controllers (NRPNs) have no specific function and are available for any device
    /// > or application-specific function. Assignable Controllers map and translate directly to
    /// > MIDI 1.0 Non-Registered Parameter Numbers (NRPN). Assignable Controllers are also
    /// > organized in 128 Banks (corresponds to NRPN MSB), with 128 controllers per Bank
    /// > (corresponds to NRPN LSB).
    ///
    /// See Recommended Practise
    /// [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    public enum AssignableController: Equatable, Hashable {
        /// Form an NRPN message from a raw parameter number byte pair.
        ///
        /// - Parameters:
        ///   - parameter: UInt8 pair.
        ///   - dataEntryMSB: Optional data entry MSB byte to follow.
        ///   - dataEntryMSB: Optional data entry LSB byte to follow.
        case raw(
            parameter: UInt7Pair,
            dataEntryMSB: UInt7?,
            dataEntryLSB: UInt7?
        )
    
        /// Null Function Number.
        ///
        /// The purpose of this event is to communicate the intent to disable data entry, data
        /// increment, and data decrement controllers until a new NRPN is selected.
        case null
    }
}

extension MIDIEvent.AssignableController: MIDIParameterNumber {
    public static let type: MIDIParameterNumberType = .assignable
    
    public var parameterBytes: UInt7Pair {
        switch self {
        case let .raw(parameter, _, _):
            return parameter
            
        case .null:
            return .init(msb: 0x7F, lsb: 0x7F)
        }
    }
    
    public var dataEntryBytes: (msb: UInt7?, lsb: UInt7?) {
        switch self {
        case let .raw(_, dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
            
        case .null:
            return (msb: nil, lsb: nil)
        }
    }
    
    /// CC controller numbers used for non-UMP MIDI 1.0 transmission.
    public static let controllers: (
        msb: MIDIEvent.CC.Controller,
        lsb: MIDIEvent.CC.Controller
    ) = (msb: .nrpnMSB, lsb: .nrpnLSB)
}
