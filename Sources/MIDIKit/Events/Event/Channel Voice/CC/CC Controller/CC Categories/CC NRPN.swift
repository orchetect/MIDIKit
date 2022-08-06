//
//  CC NRPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC.Controller {
    /// Cases describing MIDI CC NRPNs (Non-Registered Parameter Numbers)
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// See Recommended Practise RP-018 of the MIDI 1.0 Spec Addenda.
    public enum NRPN: Equatable, Hashable {
        /// Form an RPN message from a raw parameter number byte pair.
        ///
        /// - parameters:
        ///   - parameter: Byte pair.
        ///   - dataEntryMSB: Optional data entry MSB byte to follow.
        ///   - dataEntryMSB: Optional data entry LSB byte to follow.
        case raw(
            parameter: MIDI.UInt7.Pair,
            dataEntryMSB: MIDI.UInt7?,
            dataEntryLSB: MIDI.UInt7?
        )
        
        /// Null Function Number for RPN/NRPN
        ///
        /// The purpose of this event is to communicate the intent to disable data entry, data increment, and data decrement controllers until a new RPN or NRPN is selected.
        case null
    }
}

extension MIDI.Event.CC.Controller.NRPN {
    /// Returns the parameter number byte pair.
    public var parameter: MIDI.UInt7.Pair {
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
        msb: MIDI.UInt7?,
        lsb: MIDI.UInt7?
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

extension MIDI.Event.CC.Controller.NRPN {
    /// Returns the NRPN message consisting of 2-4 MIDI Events.
    public func events(
        channel: MIDI.UInt4,
        group: MIDI.UInt4 = 0
    ) -> [MIDI.Event] {
        var nrpnEvents: [MIDI.Event] = [
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

extension MIDI.Event {
    /// Creates an NRPN message, consisting of multiple MIDI Events.
    public static func ccNRPN(
        _ nrpn: CC.Controller.NRPN,
        channel: MIDI.UInt4,
        group: MIDI.UInt4 = 0
    ) -> [MIDI.Event] {
        nrpn.events(
            channel: channel,
            group: group
        )
    }
}

// MARK: - API Transition (release 0.4.12)

extension MIDI.Event {
    /// Creates an NRPN message, consisting of multiple MIDI Events.
    @available(
        *,
        unavailable,
        renamed: "ccNRPN(_:channel:group:)",
        message: "NRPN API has been unified with RPN API. Please use the .raw() enum case in place of parameter: dataEntryMSB: dataEntryLSB: parameters."
    )
    public static func ccNRPN(
        parameter: MIDI.UInt7.Pair,
        dataEntryMSB: MIDI.UInt7?,
        dataEntryLSB: MIDI.UInt7?,
        channel: MIDI.UInt4,
        group: MIDI.UInt4 = 0
    ) -> [MIDI.Event] {
        CC.Controller.NRPN
            .raw(
                parameter: parameter,
                dataEntryMSB: dataEntryMSB,
                dataEntryLSB: dataEntryLSB
            )
            .events(
                channel: channel,
                group: group
            )
    }
}
