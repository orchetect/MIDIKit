//
//  PitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Pitch Bend
    public struct PitchBend: Equatable, Hashable {
        
        /// Value
        public var value: MIDI.UInt14
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// Channel Voice Message: Pitch Bend
    ///
    /// - Parameters:
    ///   - value: 14-bit Value (0...16383) where midpoint is 8192
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func pitchBend(value: MIDI.UInt14,
                                 channel: MIDI.UInt4,
                                 group: MIDI.UInt4 = 0x0) -> Self {
        
        .pitchBend(
            .init(value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.PitchBend {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        let bytePair = value.bytePair
        
        return [0xE0 + channel.uInt8Value,
                bytePair.lsb,
                bytePair.msb]
        
    }
    
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        switch midiProtocol {
        case ._1_0:
            let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
            
            let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
            
            let bytePair = value.bytePair
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xE0 + channel.uInt8Value,
                                    bytePair.lsb,
                                    bytePair.msb)
            
            return [word]
            
        case ._2_0:
            let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi2ChannelVoice
            
            let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
            
            #warning("> code this")
            
            //let word1 = MIDI.UMPWord()
            
            return []
            
        }
        
    }
    
}
