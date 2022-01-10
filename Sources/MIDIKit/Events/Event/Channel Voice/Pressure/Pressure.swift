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
        @AmountValidated
        public var amount: Amount
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(amount: Amount,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.amount = amount
            self.channel = channel
            self.group = group
            
        }
        
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
    @inline(__always)
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
    
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xD0 + channel.uInt8Value,
         amount.midi1Value.uInt8Value]
        
    }
    
    @inline(__always)
    private func umpMessageType(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> MIDI.Packet.UniversalPacketData.MessageType {
        
        switch midiProtocol {
        case ._1_0:
            return .midi1ChannelVoice
            
        case ._2_0:
            return .midi2ChannelVoice
        }
        
    }
    
    @inline(__always)
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
        
        switch midiProtocol {
        case ._1_0:
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xD0 + channel.uInt8Value,
                                    amount.midi1Value.uInt8Value,
                                    0x00) // pad an empty byte to fill 4 bytes
            
            return [word]
            
        case ._2_0:
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     0xD0 + channel.uInt8Value,
                                     0x00, // reserved
                                     0x00) // reserved
            
            let word2 = amount.midi2Value
            
            return [word1, word2]
            
        }
        
    }
    
}

