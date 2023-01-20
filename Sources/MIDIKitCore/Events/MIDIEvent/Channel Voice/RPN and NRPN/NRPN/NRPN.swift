//
//  NRPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    // note: this comment block should be duplicated to:
    // - below in this file to static init(s)
    // - MIDIEvent.AssignableController
    // - MIDIEvent enum case
    
    /// Channel Voice Message: NRPN (Non-Registered Parameter Number),
    /// also referred to as Assignable Controller in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of a Assignable Parameter (NRPN), the following
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
    /// See Recommended Practise [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    public struct NRPN: Equatable, Hashable {
        /// Non-Registered Parameter Number (Assignable Controller).
        public var param: AssignableController
    
        /// MIDI 2.0 Parameter Number value type.
        /// Determines whether the value is absolute or a relative change.
        /// (MIDI 1.0 will always be absolute and this property is ignored.)
        public var change: MIDI2ParameterNumberChange
        
        /// Channel Number (`0x0 ... 0xF`)
        public var channel: UInt4
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(
            _ param: AssignableController,
            change: MIDI2ParameterNumberChange = .absolute,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.param = param
            self.change = change
            self.channel = channel
            self.group = group
        }
    }
    
    // note: this comment block should be duplicated to the places noted at the top of this file
    
    /// Channel Voice Message: NRPN (Non-Registered Parameter Number),
    /// also referred to as Assignable Controller in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of a Assignable Parameter (NRPN), the following
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
    /// See Recommended Practise [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    ///
    /// - Parameters:
    ///   - param: Non-Registered Parameter Number (Assignable Controller).
    ///   - change: Determines whether the value is absolute or a relative change. MIDI 1.0 is always absolute.
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func nrpn(
        _ param: AssignableController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .nrpn(
            .init(
                param,
                change: change,
                channel: channel,
                group: group
            )
        )
    }
    
    // MARK: - Extra Static Constructors
    
    /// Assembles a MIDI 1.0 NRPN compound message, consisting of multiple CC events.
    ///
    /// This is provided for legacy support. It is recommended to use ``MIDIEvent/nrpn(_:change:channel:group:)``.
    public static func midi1NRPN(
        _ nrpn: AssignableController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        nrpn.midi1Events(
            channel: channel,
            group: group
        )
    }
}

extension MIDIEvent.NRPN {
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        param.midi1RawBytes(channel: channel, group: group)
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    /// May return 1 or more packets which is why this method returns an array of word arrays.
    /// Each inner array contains words for one packet.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> [[UMPWord]] {
        param.umpRawWords(
            protocol: midiProtocol,
            change: change,
            channel: channel,
            group: group
        )
    }
}