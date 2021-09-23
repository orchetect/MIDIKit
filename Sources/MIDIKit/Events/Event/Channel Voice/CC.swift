//
//  CC.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Controller Change (CC)
    public struct CC: Equatable, Hashable {
        
        /// Controller
        public var controller: Controller
        
        /// Value
        public var value: MIDI.UInt7
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Controller Change (CC)
    ///
    /// - Parameters:
    ///   - controller: Controller type
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func cc(_ controller: CC.Controller,
                          value: MIDI.UInt7,
                          channel: MIDI.UInt4,
                          group: MIDI.UInt4 = 0x0) -> Self {
        
        .cc(
            .init(controller: controller,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Controller Change (CC)
    ///
    /// - Parameters:
    ///   - controller: Controller number
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func cc(_ controller: MIDI.UInt7,
                          value: MIDI.UInt7,
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
         value.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xB0 + channel.uInt8Value,
                                controller.number.uInt8Value,
                                value.uInt8Value)
        
        return [word]
        
    }
    
}
