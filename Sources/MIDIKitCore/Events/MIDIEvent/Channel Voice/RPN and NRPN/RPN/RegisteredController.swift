//
//  RegisteredController.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    // note: this comment block should be duplicated to MIDIEvent.RPN
    
    /// Cases describing RPNs (Registered Parameter Numbers),
    /// also referred to as Registered Controllers in MIDI 2.0.
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
    ///   [RP-018](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/response-to-data-increment-decrement-controllers)
    ///   of the MIDI 1.0 Spec Addenda.
    public enum RegisteredController {
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
        case channelFineTuning(
            UInt14
        )
    
        /// Channel Coarse Tuning
        /// (formerly Coarse Tuning - see MMA [RP-022](https://www.midi.org/specifications/midi1-specifications/midi-1-addenda/redefinition-of-rpn01-and-rpn02-channel-fine-coarse-tuning))
        ///
        /// Resolution: 100 cents
        /// - `0x00` == -6400 cents
        /// - `0x40` == A440
        /// - `0x7F` == +6300 cents
        case channelCoarseTuning(
            UInt7
        )
    
        /// Tuning Program Change
        ///
        /// Value is Tuning Program Number (`1 ... 128`, encoded as `0 ... 127`).
        case tuningProgramChange(
            number: UInt7
        )
    
        /// Tuning Bank Select
        ///
        /// Value is Tuning Bank Number (`1 ... 128`, encoded as `0 ... 127`).
        case tuningBankSelect(
            number: UInt7
        )
    
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
    
        /// Null Function Number.
        ///
        /// The purpose of this event is to communicate the intent to disable data entry, data
        /// increment, and data decrement controllers until a new RPN is selected.
        case null
    
        /// Form an RPN message from a raw parameter number byte pair.
        ///
        /// Note that RPNs are defined by the MIDI Association and use of undefined RPNs is
        /// discouraged. For using custom parameters, use NRPNs instead (Non-Registered Parameter
        /// Number).
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

extension MIDIEvent.RegisteredController: Equatable { }

extension MIDIEvent.RegisteredController: Hashable { }

extension MIDIEvent.RegisteredController: Sendable { }

extension MIDIEvent.RegisteredController: MIDIParameterNumber {
    public static let type: MIDIParameterNumberType = .registered
    
    @inlinable
    public var parameterBytes: UInt7Pair {
        switch self {
        // MIDI Spec
    
        case .pitchBendSensitivity:
            .init(msb: 0x00, lsb: 0x00)
    
        case .channelFineTuning:
            .init(msb: 0x00, lsb: 0x01)
    
        case .channelCoarseTuning:
            .init(msb: 0x00, lsb: 0x02)
    
        case .tuningProgramChange:
            .init(msb: 0x00, lsb: 0x03)
    
        case .tuningBankSelect:
            .init(msb: 0x00, lsb: 0x04)
    
        case .modulationDepthRange:
            .init(msb: 0x00, lsb: 0x05)
    
        case .mpeConfigurationMessage:
            .init(msb: 0x00, lsb: 0x06)
    
        case .null:
            .init(msb: 0x7F, lsb: 0x7F)
    
        case .raw(
            parameter: let parameter,
            dataEntryMSB: _,
            dataEntryLSB: _
        ):
            parameter
    
        // 3D Sound Controllers
    
        case .threeDimensionalAzimuthAngle:
            .init(msb: 0x3D, lsb: 0x00)
    
        case .threeDimensionalElevationAngle:
            .init(msb: 0x3D, lsb: 0x01)
    
        case .threeDimensionalGain:
            .init(msb: 0x3D, lsb: 0x02)
    
        case .threeDimensionalDistanceRatio:
            .init(msb: 0x3D, lsb: 0x03)
    
        case .threeDimensionalMaximumDistance:
            .init(msb: 0x3D, lsb: 0x04)
    
        case .threeDimensionalGainAtMaximumDistance:
            .init(msb: 0x3D, lsb: 0x05)
    
        case .threeDimensionalReferenceDistanceRatio:
            .init(msb: 0x3D, lsb: 0x06)
    
        case .threeDimensionalPanSpreadAngle:
            .init(msb: 0x3D, lsb: 0x07)
    
        case .threeDimensionalRollAngle:
            .init(msb: 0x3D, lsb: 0x08)
        }
    }
    
    @inlinable
    public var dataEntryBytes: (msb: UInt7?, lsb: UInt7?) {
        switch self {
        // MIDI Spec
    
        case let .pitchBendSensitivity(semitones, cents):
            return (msb: semitones, lsb: cents)
    
        case let .channelFineTuning(value):
            let uInt7Pair = value.midiUInt7Pair
            return (msb: uInt7Pair.msb, lsb: uInt7Pair.lsb)
    
        case let .channelCoarseTuning(value):
            return (msb: value, lsb: nil)
    
        case let .tuningProgramChange(number):
            return (msb: number, lsb: nil)
    
        case let .tuningBankSelect(number):
            return (msb: number, lsb: nil)
    
        case let .modulationDepthRange(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .mpeConfigurationMessage(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case .null:
            return (msb: nil, lsb: nil)
    
        case .raw(
            parameter: _,
            dataEntryMSB: let dataEntryMSB,
            dataEntryLSB: let dataEntryLSB
        ):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        // 3D Sound Controllers
    
        case let .threeDimensionalAzimuthAngle(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .threeDimensionalElevationAngle(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .threeDimensionalGain(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .threeDimensionalDistanceRatio(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
            
        case let .threeDimensionalMaximumDistance(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .threeDimensionalGainAtMaximumDistance(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .threeDimensionalReferenceDistanceRatio(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .threeDimensionalPanSpreadAngle(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
    
        case let .threeDimensionalRollAngle(dataEntryMSB, dataEntryLSB):
            return (msb: dataEntryMSB, lsb: dataEntryLSB)
        }
    }
    
    public static let controllers: (
        msb: MIDIEvent.CC.Controller,
        lsb: MIDIEvent.CC.Controller
    ) = (msb: .rpnMSB, lsb: .rpnLSB)
}
