//
//  UnofficialBusSelect.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Bus Select - unofficial (Status `0xF5`)
    public struct UnofficialBusSelect: Equatable, Hashable {
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// Bus Select - unofficial (Status `0xF5`)
    public static func unofficialBusSelect(group: MIDI.UInt4 = 0) -> Self {
        
        .unofficialBusSelect(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.UnofficialBusSelect {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF5]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF5,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}
