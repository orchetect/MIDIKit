//
//  PitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Pitch Bend
    public struct PitchBend: Equatable, Hashable {
        /// Value
        @ValueValidated
        public var value: Value
    
        /// Channel Number (`0x0 ... 0xF`)
        public var channel: UInt4
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(
            value: Value,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.value = value
            self.channel = channel
            self.group = group
        }
    }
    
    /// Channel Voice Message: Pitch Bend
    ///
    /// - Parameters:
    ///   - value: 14-bit Value (`0 ... 16383`) where midpoint is 8192
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func pitchBend(
        value: PitchBend.Value,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .pitchBend(
            .init(
                value: value,
                channel: channel,
                group: group
            )
        )
    }
}

extension MIDIEvent.PitchBend {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xE0 + channel.uInt8Value
    }
    
    /// Returns the raw MIDI 1.0 data bytes for the event (excluding status byte).
    public func midi1RawDataBytes() -> (data1: UInt8, data2: UInt8) {
        let bytePair = value.midi1Value.bytePair
        return (data1: bytePair.lsb, data2: bytePair.msb)
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        let dataBytes = midi1RawDataBytes()
        return [midi1RawStatusByte(), dataBytes.data1, dataBytes.data2]
    }
    
    private func umpMessageType(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> MIDIUMPMessageType {
        switch midiProtocol {
        case ._1_0:
            return .midi1ChannelVoice
    
        case ._2_0:
            return .midi2ChannelVoice
        }
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> [UMPWord] {
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
            .uInt8Value
    
        switch midiProtocol {
        case ._1_0:
            let bytePair = value.midi1Value.bytePair
    
            let word = UMPWord(
                mtAndGroup,
                midi1RawStatusByte(),
                bytePair.lsb,
                bytePair.msb
            )
    
            return [word]
    
        case ._2_0:
            let word1 = UMPWord(
                mtAndGroup,
                midi1RawStatusByte(),
                0x00, // reserved
                0x00
            ) // reserved
    
            let word2 = value.midi2Value
    
            return [word1, word2]
        }
    }
}
