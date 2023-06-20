//
//  Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    /// (MIDI 1.0 / 2.0)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public struct Pressure: Equatable, Hashable {
        /// Pressure Amount
        @AmountValidated
        public var amount: Amount
    
        /// Channel Number (`0x0 ... 0xF`)
        public var channel: UInt4
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(
            amount: Amount,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.amount = amount
            self.channel = channel
            self.group = group
        }
    }
    
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    /// (MIDI 1.0 / 2.0)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    ///
    /// - Parameters:
    ///   - amount: Pressure Amount
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func pressure(
        amount: Pressure.Amount,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .pressure(
            .init(
                amount: amount,
                channel: channel,
                group: group
            )
        )
    }
}

extension MIDIEvent.Pressure {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xD0 + channel.uInt8Value
    }
    
    /// Returns the raw MIDI 1.0 data bytes for the event (excluding status byte).
    public func midi1RawDataBytes() -> UInt8 {
        amount.midi1Value.uInt8Value
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        [midi1RawStatusByte(), midi1RawDataBytes()]
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
            let word = UMPWord(
                mtAndGroup,
                midi1RawStatusByte(),
                midi1RawDataBytes(),
                0x00
            ) // pad an empty byte to fill 4 bytes
    
            return [word]
    
        case ._2_0:
            let word1 = UMPWord(
                mtAndGroup,
                midi1RawStatusByte(),
                0x00, // reserved
                0x00
            ) // reserved
    
            let word2 = amount.midi2Value
    
            return [word1, word2]
        }
    }
}
