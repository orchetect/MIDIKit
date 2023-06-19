//
//  RPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    // note: this comment block should be duplicated to:
    // - below in this file to static init(s)
    // - MIDIEvent.RegisteredController
    // - MIDIEvent enum case
    
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of a Registered Parameter (RPN), the following occurs:
    /// >
    /// > 1. Two Control Change messages are sent using CC 101 (0x65) and 100 (0x64) to select the
    /// > desired Registered Parameter Number.
    /// >
    /// > 2. When setting the Registered Parameter to a specific value, CC messages are sent to the
    /// > Data Entry MSB controller (CC 6). If the selected Registered Parameter requires the LSB to
    /// > be set, another CC message is sent to the Data Entry LSB controller (CC 38).
    /// >
    /// > 3. To make a relative adjustment to the selected Registered Parameter's current value, use
    /// > the Data Increment or Data Decrement controllers (CCs 96 & 97).
    /// >
    /// > Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
    /// >
    /// > For custom Parameter Number use, see NRPN (Non-Registered Parameter Numbers).
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > In the MIDI 2.0 Protocol, Registered Controllers (RPN) and Assignable Controllers (NRPN)
    /// > use a single, unified message, making them much easier to use.
    /// >
    /// > As a result, CC 6, 38, 98, 99, 100, and 101 are not to be used in standalone CC messages,
    /// > as the new MIDI 2.0 RPN/NRPN UMP messages replace them.
    /// >
    /// > Registered Controllers (RPNs) have specific functions defined by MMA/AMEI specifications.
    /// > Registered Controllers map and translate directly to MIDI 1.0 Registered Parameter Numbers
    /// > (RPN, see Appendix D.2.3) and use the same definitions as MMA/AMEI approved RPN messages.
    /// > Registered Controllers are organized in 128 Banks (corresponds to RPN MSB), with 128
    /// > controllers per Bank (corresponds to RPN LSB).
    ///
    /// - Note: See Recommended Practise
    /// [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    public struct RPN: Equatable, Hashable {
        /// Registered Parameter Number (Registered Controller).
        public var parameter: RegisteredController
    
        /// MIDI 2.0 Parameter Number value type.
        /// Determines whether the value is absolute or a relative change.
        /// (MIDI 1.0 will always be absolute and this property is ignored.)
        public var change: MIDI2ParameterNumberChange
        
        /// Channel Number (`0x0 ... 0xF`)
        public var channel: UInt4
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(
            _ parameter: RegisteredController,
            change: MIDI2ParameterNumberChange = .absolute,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.parameter = parameter
            self.change = change
            self.channel = channel
            self.group = group
        }
    }
    
    // note: this comment block should be duplicated to the places noted at the top of this file
    
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of a Registered Parameter (RPN), the following occurs:
    /// >
    /// > 1. Two Control Change messages are sent using CC 101 (0x65) and 100 (0x64) to select the
    /// > desired Registered Parameter Number.
    /// >
    /// > 2. When setting the Registered Parameter to a specific value, CC messages are sent to the
    /// > Data Entry MSB controller (CC 6). If the selected Registered Parameter requires the LSB to
    /// > be set, another CC message is sent to the Data Entry LSB controller (CC 38).
    /// >
    /// > 3. To make a relative adjustment to the selected Registered Parameter's current value, use
    /// > the Data Increment or Data Decrement controllers (CCs 96 & 97).
    /// >
    /// > Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
    /// >
    /// > For custom Parameter Number use, see NRPN (Non-Registered Parameter Numbers).
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > In the MIDI 2.0 Protocol, Registered Controllers (RPN) and Assignable Controllers (NRPN)
    /// > use a single, unified message, making them much easier to use.
    /// >
    /// > As a result, CC 6, 38, 98, 99, 100, and 101 are not to be used in standalone CC messages,
    /// > as the new MIDI 2.0 RPN/NRPN UMP messages replace them.
    /// >
    /// > Registered Controllers (RPNs) have specific functions defined by MMA/AMEI specifications.
    /// > Registered Controllers map and translate directly to MIDI 1.0 Registered Parameter Numbers
    /// > (RPN, see Appendix D.2.3) and use the same definitions as MMA/AMEI approved RPN messages.
    /// > Registered Controllers are organized in 128 Banks (corresponds to RPN MSB), with 128
    /// > controllers per Bank (corresponds to RPN LSB).
    ///
    /// - Note: See Recommended Practise
    /// [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    ///
    /// - Parameters:
    ///   - parameter: Registered Parameter Number (Registered Controller).
    ///   - change: Determines whether the value is absolute or a relative change. MIDI 1.0 is always absolute.
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func rpn(
        _ parameter: RegisteredController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .rpn(
            .init(
                parameter,
                change: change,
                channel: channel,
                group: group
            )
        )
    }
    
    // note: this comment block should be duplicated to the places noted at the top of this file
    
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of a Registered Parameter (RPN), the following occurs:
    /// >
    /// > 1. Two Control Change messages are sent using CC 101 (0x65) and 100 (0x64) to select the
    /// > desired Registered Parameter Number.
    /// >
    /// > 2. When setting the Registered Parameter to a specific value, CC messages are sent to the
    /// > Data Entry MSB controller (CC 6). If the selected Registered Parameter requires the LSB to
    /// > be set, another CC message is sent to the Data Entry LSB controller (CC 38).
    /// >
    /// > 3. To make a relative adjustment to the selected Registered Parameter's current value, use
    /// > the Data Increment or Data Decrement controllers (CCs 96 & 97).
    /// >
    /// > Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
    /// >
    /// > For custom Parameter Number use, see NRPN (Non-Registered Parameter Numbers).
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > In the MIDI 2.0 Protocol, Registered Controllers (RPN) and Assignable Controllers (NRPN)
    /// > use a single, unified message, making them much easier to use.
    /// >
    /// > As a result, CC 6, 38, 98, 99, 100, and 101 are not to be used in standalone CC messages,
    /// > as the new MIDI 2.0 RPN/NRPN UMP messages replace them.
    /// >
    /// > Registered Controllers (RPNs) have specific functions defined by MMA/AMEI specifications.
    /// > Registered Controllers map and translate directly to MIDI 1.0 Registered Parameter Numbers
    /// > (RPN, see Appendix D.2.3) and use the same definitions as MMA/AMEI approved RPN messages.
    /// > Registered Controllers are organized in 128 Banks (corresponds to RPN MSB), with 128
    /// > controllers per Bank (corresponds to RPN LSB).
    ///
    /// - Note: See Recommended Practise
    /// [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    ///
    /// - Parameters:
    ///   - parameter: Registered Parameter Number (Registered Controller).
    ///   - data: Two 7-bit MIDI 1.0 data bytes, optional.
    ///   - change: Determines whether the value is absolute or a relative change. MIDI 1.0 is always absolute.
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func rpn(
        parameter: UInt7Pair,
        data: (msb: UInt7?, lsb: UInt7?),
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .rpn(
            RegisteredController(parameter: parameter, data: data),
            change: change,
            channel: channel,
            group: group
        )
    }
    
    // note: this comment block should be duplicated to the places noted at the top of this file
    
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of a Registered Parameter (RPN), the following occurs:
    /// >
    /// > 1. Two Control Change messages are sent using CC 101 (0x65) and 100 (0x64) to select the
    /// > desired Registered Parameter Number.
    /// >
    /// > 2. When setting the Registered Parameter to a specific value, CC messages are sent to the
    /// > Data Entry MSB controller (CC 6). If the selected Registered Parameter requires the LSB to
    /// > be set, another CC message is sent to the Data Entry LSB controller (CC 38).
    /// >
    /// > 3. To make a relative adjustment to the selected Registered Parameter's current value, use
    /// > the Data Increment or Data Decrement controllers (CCs 96 & 97).
    /// >
    /// > Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
    /// >
    /// > For custom Parameter Number use, see NRPN (Non-Registered Parameter Numbers).
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > In the MIDI 2.0 Protocol, Registered Controllers (RPN) and Assignable Controllers (NRPN)
    /// > use a single, unified message, making them much easier to use.
    /// >
    /// > As a result, CC 6, 38, 98, 99, 100, and 101 are not to be used in standalone CC messages,
    /// > as the new MIDI 2.0 RPN/NRPN UMP messages replace them.
    /// >
    /// > Registered Controllers (RPNs) have specific functions defined by MMA/AMEI specifications.
    /// > Registered Controllers map and translate directly to MIDI 1.0 Registered Parameter Numbers
    /// > (RPN, see Appendix D.2.3) and use the same definitions as MMA/AMEI approved RPN messages.
    /// > Registered Controllers are organized in 128 Banks (corresponds to RPN MSB), with 128
    /// > controllers per Bank (corresponds to RPN LSB).
    ///
    /// - Note: See Recommended Practise
    /// [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    ///
    /// - Parameters:
    ///   - parameter: Registered Parameter Number (Registered Controller).
    ///   - data: MIDI 1.0 14-bit data value.
    ///   - change: Determines whether the value is absolute or a relative change. MIDI 1.0 is always absolute.
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func rpn(
        parameter: UInt7Pair,
        data: UInt14,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        let dataPair = data.midiUInt7Pair
        let dataTuple = (msb: dataPair.msb, lsb: dataPair.lsb)
        return .rpn(
            RegisteredController(parameter: parameter, data: dataTuple),
            change: change,
            channel: channel,
            group: group
        )
    }
    
    // note: this comment block should be duplicated to the places noted at the top of this file
    
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > In order to set or change the value of a Registered Parameter (RPN), the following occurs:
    /// >
    /// > 1. Two Control Change messages are sent using CC 101 (0x65) and 100 (0x64) to select the
    /// > desired Registered Parameter Number.
    /// >
    /// > 2. When setting the Registered Parameter to a specific value, CC messages are sent to the
    /// > Data Entry MSB controller (CC 6). If the selected Registered Parameter requires the LSB to
    /// > be set, another CC message is sent to the Data Entry LSB controller (CC 38).
    /// >
    /// > 3. To make a relative adjustment to the selected Registered Parameter's current value, use
    /// > the Data Increment or Data Decrement controllers (CCs 96 & 97).
    /// >
    /// > Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
    /// >
    /// > For custom Parameter Number use, see NRPN (Non-Registered Parameter Numbers).
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > In the MIDI 2.0 Protocol, Registered Controllers (RPN) and Assignable Controllers (NRPN)
    /// > use a single, unified message, making them much easier to use.
    /// >
    /// > As a result, CC 6, 38, 98, 99, 100, and 101 are not to be used in standalone CC messages,
    /// > as the new MIDI 2.0 RPN/NRPN UMP messages replace them.
    /// >
    /// > Registered Controllers (RPNs) have specific functions defined by MMA/AMEI specifications.
    /// > Registered Controllers map and translate directly to MIDI 1.0 Registered Parameter Numbers
    /// > (RPN, see Appendix D.2.3) and use the same definitions as MMA/AMEI approved RPN messages.
    /// > Registered Controllers are organized in 128 Banks (corresponds to RPN MSB), with 128
    /// > controllers per Bank (corresponds to RPN LSB).
    ///
    /// - Note: See Recommended Practise
    /// [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    /// of the MIDI 1.0 Spec Addenda.
    ///
    /// - Parameters:
    ///   - parameter: Registered Parameter Number (Registered Controller).
    ///   - data: MIDI 2.0 32-bit data value. Will be scaled down to 14-bit when necessary.
    ///   - change: Determines whether the value is absolute or a relative change. MIDI 1.0 is always absolute.
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func rpn(
        parameter: UInt7Pair,
        data: UInt32,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        let downscaledData = ChanVoice14Bit32BitValue.midi2(data).midi1Value
        let dataPair = downscaledData.midiUInt7Pair
        let dataTuple = (msb: dataPair.msb, lsb: dataPair.lsb)
        return .rpn(
            RegisteredController(parameter: parameter, data: dataTuple),
            change: change,
            channel: channel,
            group: group
        )
    }
    
    /// Assembles a MIDI 1.0 RPN compound message, consisting of multiple CC events.
    ///
    /// This is provided for legacy support. It is recommended to use ``MIDIEvent/rpn(_:change:channel:group:)``.
    public static func midi1RPN(
        _ parameter: RegisteredController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        parameter.midi1Events(
            channel: channel,
            group: group
        )
    }
}

extension MIDIEvent.RPN {
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        parameter.midi1RawBytes(channel: channel, group: group)
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
        parameter.umpRawWords(
            protocol: midiProtocol,
            change: change,
            channel: channel,
            group: group
        )
    }
}
