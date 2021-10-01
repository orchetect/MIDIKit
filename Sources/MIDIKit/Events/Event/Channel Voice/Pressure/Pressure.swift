//
//  Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Channel Pressure
    /// (MIDI 1.0 / 2.0)
    ///
    /// DAWs are known to use variations on the terminology:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public struct Pressure: Equatable, Hashable {
        
        /// Pressure Amount
        public var amount: Amount
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// Channel Voice Message: Channel Pressure
    /// (MIDI 1.0 / 2.0)
    ///
    /// DAWs are known to use variations on the terminology:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    ///
    /// - Parameters:
    ///   - amount: Pressure Amount
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func pressure(amount: Pressure.Amount,
                                channel: MIDI.UInt4,
                                group: MIDI.UInt4 = 0x0) -> Self {
        
        .pressure(
            .init(amount: amount,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Pressure {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xD0 + channel.uInt8Value,
         amount.midi1Value.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xD0 + channel.uInt8Value,
                                amount.midi1Value.uInt8Value,
                                0x00) // pad an empty byte to fill 4 bytes
        
        return [word]
        
    }
    
}

