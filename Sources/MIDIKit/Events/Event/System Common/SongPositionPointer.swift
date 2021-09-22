//
//  SongPositionPointer.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Common: Song Position Pointer (Status `0xF2`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start of the song and is used to begin playback of a sequence from a position other than the beginning of the song."
    public struct SongPositionPointer: Equatable, Hashable {
        
        public var midiBeat: MIDI.UInt14
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// System Common: Song Position Pointer (Status `0xF2`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start of the song and is used to begin playback of a sequence from a position other than the beginning of the song."
    public static func songPositionPointer(midiBeat: MIDI.UInt14,
                                           group: MIDI.UInt4 = 0) -> Self {
        
        .songPositionPointer(
            .init(midiBeat: midiBeat,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.SongPositionPointer {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        let bytePair = midiBeat.bytePair
        return [0xF2, bytePair.lsb, bytePair.msb]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let bytePair = midiBeat.bytePair
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF2,
                                bytePair.lsb,
                                bytePair.msb)
        
        return [word]
        
    }
    
}
