//
//  Controller RPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    /// Cases describing MIDI CC RPNs (Registered Parameter Numbers)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > To set or change the value of a Registered Parameter:
    /// >
    /// > 1. Send two Control Change messages using Control Numbers 101 (0x65) and 100 (0x64) to
    /// > select the desired Registered Parameter Number.
    /// >
    /// > 2. To set the selected Registered Parameter to a specific value, send a Control Change
    /// > messages to the Data Entry MSB controller (Control Number 6). If the selected Registered
    /// > Parameter requires the LSB to be set, send another Control Change message to the Data Entry
    /// > LSB controller (Control Number 38).
    /// >
    /// > 3. To make a relative adjustment to the selected Registered Parameter's current value, use
    /// > the Data Increment or Data Decrement controllers (Control Numbers 96 and 97).
    /// >
    /// > Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
    /// >
    /// > For custom Parameter Number use, see NRPN (non-Registered Parameter Numbers).
    ///
    /// - Note: See Recommended Practise
    /// [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers) of the MIDI 1.0 Spec Addenda.
    public enum RPN: Equatable, Hashable {
        // MIDI Spec
    
        /// Pitch Bend Sensitivity
        case pitchBendSensitivity(
            semitones: UInt7,
            cents: UInt7
        )
    
        /// Channel Fine Tuning
        /// (formerly Fine Tuning - see MMA [RP-022](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/redefinition-of-rpn01-and-rpn02-channel-fine-coarse-tuning))
        ///
        /// Resolution: 100/8192 cents
        /// Midpoint = A440, min/max -/+ 100 cents
        case channelFineTuning(UInt14)
    
        /// Channel Coarse Tuning
        /// (formerly Coarse Tuning - see MMA [RP-022](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/redefinition-of-rpn01-and-rpn02-channel-fine-coarse-tuning))
        ///
        /// Resolution: 100 cents
        /// - `0x00` == -6400 cents
        /// - `0x40` == A440
        /// - `0x7F` == +6300 cents
        case channelCoarseTuning(UInt7)
    
        /// Tuning Program Change
        ///
        /// Value is Tuning Program Number (`1 ... 128`, encoded as `0 ... 127`).
        case tuningProgramChange(number: UInt7)
    
        /// Tuning Bank Select
        ///
        /// Value is Tuning Bank Number (`1 ... 128`, encoded as `0 ... 127`).
        case tuningBankSelect(number: UInt7)
    
        /// Modulation Depth Range
        /// (see MMA General MIDI Level 2 Specification)
        ///
        /// For GM2, defined in GM2 Specification.
        /// For other systems, defined by manufacturer.
        case modulationDepthRange(
            dataEntryMSB: UInt7?,
            dataEntryLSB: UInt7?
        )
    
        /// MPE Configuration Message
        /// (see MPE Specification)
        case mpeConfigurationMessage(
            dataEntryMSB: UInt7?,
            dataEntryLSB: UInt7?
        )
    
        /// Null Function Number for RPN/NRPN
        ///
        /// The purpose of this event is to communicate the intent to disable data entry, data increment, and data decrement controllers until a new RPN or NRPN is selected.
        case null
    
        /// Form an RPN message from a raw parameter number byte pair.
        ///
        /// Note that RPNs are defined by the MIDI Association and use of undefined RPNs is discouraged. For using custom parameters, use NRPNs instead (Non-Registered Parameter Number).
        case raw(
            parameter: UInt7Pair,
            dataEntryMSB: UInt7?,
            dataEntryLSB: UInt7?
        )
    
        // 3D Sound Controllers
    
        /// 3D Sound Controller: Azimuth Angle
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalAzimuthAngle(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Elevation Angle
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalElevationAngle(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Gain
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalGain(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Distance Ratio
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalDistanceRatio(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Maximum Distance
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalMaximumDistance(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Gain at Maximum Distance
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalGainAtMaximumDistance(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Reference Distance Ratio
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalReferenceDistanceRatio(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Pan Spread Angle
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalPanSpreadAngle(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    
        /// 3D Sound Controller: Roll Angle
        /// (See MMA [RP-049](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/three-dimensional-sound-controllers))
        case threeDimensionalRollAngle(
            dataEntryMSB: UInt7,
            dataEntryLSB: UInt7
        )
    }
}

extension MIDIEvent.CC.Controller.RPN {
    /// Returns the parameter number byte pair.
    public var parameter: UInt7Pair {
        switch self {
        // MIDI Spec
    
        case .pitchBendSensitivity:
            return .init(msb: 0x00, lsb: 0x00)
    
        case .channelFineTuning:
            return .init(msb: 0x00, lsb: 0x01)
    
        case .channelCoarseTuning:
            return .init(msb: 0x00, lsb: 0x02)
    
        case .tuningProgramChange:
            return .init(msb: 0x00, lsb: 0x03)
    
        case .tuningBankSelect:
            return .init(msb: 0x00, lsb: 0x04)
    
        case .modulationDepthRange:
            return .init(msb: 0x00, lsb: 0x05)
    
        case .mpeConfigurationMessage:
            return .init(msb: 0x00, lsb: 0x06)
    
        case .null:
            return .init(msb: 0x7F, lsb: 0x7F)
    
        case .raw(
            parameter: let parameter,
            dataEntryMSB: _,
            dataEntryLSB: _
        ):
            return parameter
    
        // 3D Sound Controllers
    
        case .threeDimensionalAzimuthAngle:
            return .init(msb: 0x3D, lsb: 0x00)
    
        case .threeDimensionalElevationAngle:
            return .init(msb: 0x3D, lsb: 0x01)
    
        case .threeDimensionalGain:
            return .init(msb: 0x3D, lsb: 0x02)
    
        case .threeDimensionalDistanceRatio:
            return .init(msb: 0x3D, lsb: 0x03)
    
        case .threeDimensionalMaximumDistance:
            return .init(msb: 0x3D, lsb: 0x04)
    
        case .threeDimensionalGainAtMaximumDistance:
            return .init(msb: 0x3D, lsb: 0x05)
    
        case .threeDimensionalReferenceDistanceRatio:
            return .init(msb: 0x3D, lsb: 0x06)
    
        case .threeDimensionalPanSpreadAngle:
            return .init(msb: 0x3D, lsb: 0x07)
    
        case .threeDimensionalRollAngle:
            return .init(msb: 0x3D, lsb: 0x08)
        }
    }
    
    /// Returns the data entry bytes, if present.
    public var dataEntryBytes: (
        msb: UInt7?,
        lsb: UInt7?
    ) {
        switch self {
        // MIDI Spec
    
        case let .pitchBendSensitivity(
            semitones: semitones,
            cents: cents
        ):
            return (
                msb: semitones,
                lsb: cents
            )
    
        case let .channelFineTuning(value):
            let uInt7Pair = value.midiUInt7Pair
            return (
                msb: uInt7Pair.msb,
                lsb: uInt7Pair.lsb
            )
    
        case let .channelCoarseTuning(value):
            return (
                msb: value,
                lsb: nil
            )
    
        case let .tuningProgramChange(number: number):
            return (
                msb: number,
                lsb: nil
            )
    
        case let .tuningBankSelect(number: number):
            return (
                msb: number,
                lsb: nil
            )
    
        case let .modulationDepthRange(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .mpeConfigurationMessage(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
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
    
        case .raw(
            parameter: _,
            dataEntryMSB: let dataEntryMSB,
            dataEntryLSB: let dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        // 3D Sound Controllers
    
        case let .threeDimensionalAzimuthAngle(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalElevationAngle(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalGain(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalDistanceRatio(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalMaximumDistance(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalGainAtMaximumDistance(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalReferenceDistanceRatio(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalPanSpreadAngle(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
    
        case let .threeDimensionalRollAngle(
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            return (
                msb: dataEntryMSB,
                lsb: dataEntryLSB
            )
        }
    }
}

extension MIDIEvent.CC.Controller.RPN {
    /// Returns the RPN message consisting of 2-4 MIDI Events.
    public func events(
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        var rpnEvents: [MIDIEvent] = [
            .cc(
                .rpnMSB,
                value: .midi1(parameter.msb),
                channel: channel,
                group: group
            ),
            .cc(
                .rpnLSB,
                value: .midi1(parameter.lsb),
                channel: channel,
                group: group
            )
        ]
    
        let dataEntryBytes = dataEntryBytes
    
        if let dataEntryMSB = dataEntryBytes.msb {
            rpnEvents.append(.cc(
                .dataEntry,
                value: .midi1(dataEntryMSB),
                channel: channel,
                group: group
            ))
        }
    
        if let dataEntryLSB = dataEntryBytes.lsb {
            rpnEvents.append(.cc(
                .lsb(for: .dataEntry),
                value: .midi1(dataEntryLSB),
                channel: channel,
                group: group
            ))
        }
    
        return rpnEvents
    }
}

extension MIDIEvent {
    /// Creates an RPN message, consisting of multiple MIDI Events.
    public static func ccRPN(
        _ rpn: CC.Controller.RPN,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        rpn.events(
            channel: channel,
            group: group
        )
    }
}
