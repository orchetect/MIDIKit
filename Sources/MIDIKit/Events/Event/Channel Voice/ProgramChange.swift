//
//  ProgramChange.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Program Change
    public struct ProgramChange: Equatable, Hashable {
        
        /// Program Number
        public var program: MIDI.UInt7
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// Channel Voice Message: Program Change
    ///
    /// - Parameters:
    ///   - program: Program Number
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func programChange(program: MIDI.UInt7,
                                     channel: MIDI.UInt4,
                                     group: MIDI.UInt4 = 0x0) -> Self {
        
        .programChange(
            .init(program: program,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.ProgramChange {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xC0 + channel.uInt8Value,
         program.uInt8Value]
        
    }
    
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        switch midiProtocol {
        case ._1_0:
            let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
            
            let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xC0 + channel.uInt8Value,
                                    program.uInt8Value,
                                    0x00) // pad an empty byte to fill 4 bytes
            
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
