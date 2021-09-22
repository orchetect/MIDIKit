//
//  SongSelect.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    
    public struct SongSelect: Equatable, Hashable {
        
        public var number: MIDI.UInt7
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    
    public static func songSelect(number: MIDI.UInt7,
                                  group: MIDI.UInt4 = 0) -> Self {
        
        .songSelect(
            .init(number: number,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.SongSelect {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF3, number.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF3,
                                number.uInt8Value,
                                0x00) // pad an empty byte to fill 4 bytes
        
        return [word]
        
    }
    
}
