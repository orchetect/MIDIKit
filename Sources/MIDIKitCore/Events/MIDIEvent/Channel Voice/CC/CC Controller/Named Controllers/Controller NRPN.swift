//
//  Controller NRPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    /// Cases describing MIDI CC NRPNs (Non-Registered Parameter Numbers).
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// See Recommended Practise [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    public enum NRPN: Equatable, Hashable {
        /// Form an RPN message from a raw parameter number byte pair.
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
    
        /// Null Function Number for RPN/NRPN
        ///
        /// The purpose of this event is to communicate the intent to disable data entry, data
        /// increment, and data decrement controllers until a new RPN or NRPN is selected.
        case null
    }
}

extension MIDIEvent.CC.Controller.NRPN {
    /// Returns the parameter number byte pair.
    public var parameter: UInt7Pair {
        switch self {
        case .raw(
            parameter: let parameter,
            dataEntryMSB: _,
            dataEntryLSB: _
        ):
            return parameter
    
        case .null:
            return .init(
                msb: 0x7F,
                lsb: 0x7F
            )
        }
    }
    
    /// Returns the data entry bytes, if present.
    public var dataEntryBytes: (
        msb: UInt7?,
        lsb: UInt7?
    ) {
        switch self {
        case .raw(
            parameter: _,
            dataEntryMSB: let dataEntryMSB,
            dataEntryLSB: let dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case .null:
            return (
                msb: nil,
                lsb: nil
            )
        }
    }
}

extension MIDIEvent.CC.Controller.NRPN {
    /// Returns the NRPN message consisting of 2-4 MIDI Events.
    public func events(
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        var nrpnEvents: [MIDIEvent] = [
            .cc(
                .nrpnMSB,
                value: .midi1(parameter.msb),
                channel: channel,
                group: group
            ),
            .cc(
                .nrpnLSB,
                value: .midi1(parameter.lsb),
                channel: channel,
                group: group
            )
        ]
    
        let dataEntryBytes = dataEntryBytes
    
        if let dataEntryMSB = dataEntryBytes.msb {
            nrpnEvents.append(.cc(
                .dataEntry,
                value: .midi1(dataEntryMSB),
                channel: channel,
                group: group
            ))
        }
    
        if let dataEntryLSB = dataEntryBytes.lsb {
            nrpnEvents.append(.cc(
                .lsb(for: .dataEntry),
                value: .midi1(dataEntryLSB),
                channel: channel,
                group: group
            ))
        }
    
        return nrpnEvents
    }
}

extension MIDIEvent {
    /// Creates an NRPN message, consisting of multiple MIDI Events.
    public static func ccNRPN(
        _ nrpn: CC.Controller.NRPN,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        nrpn.events(
            channel: channel,
            group: group
        )
    }
}
