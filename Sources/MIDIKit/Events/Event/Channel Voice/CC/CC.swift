//
//  CC.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Control Change (CC)
    /// (MIDI 1.0 / 2.0)
    public struct CC: Equatable, Hashable {
        
        /// Controller
        public var controller: Controller
        
        /// Value
        public var value: Value
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Control Change (CC)
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - controller: Controller type
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func cc(_ controller: CC.Controller,
                          value: CC.Value,
                          channel: MIDI.UInt4,
                          group: MIDI.UInt4 = 0x0) -> Self {
        
        .cc(
            .init(controller: controller,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Control Change (CC)
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - controller: Controller number
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func cc(_ controller: MIDI.UInt7,
                          value: CC.Value,
                          channel: MIDI.UInt4,
                          group: MIDI.UInt4 = 0x0) -> Self {
        
        .cc(
            .init(controller: .init(number: controller),
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.CC {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xB0 + channel.uInt8Value,
         controller.number.uInt8Value,
         value.midi1Value.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        switch midiProtocol {
        case ._1_0:
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xB0 + channel.uInt8Value,
                                    controller.number.uInt8Value,
                                    value.midi1Value.uInt8Value)
            
            return [word]
            
        case ._2_0:
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     0xB0 + channel.uInt8Value,
                                     controller.number.uInt8Value,
                                     0x00) // reserved
            
            let word2 = value.midi2Value
            
            return [word1, word2]
            
        }
        
    }
    
}
