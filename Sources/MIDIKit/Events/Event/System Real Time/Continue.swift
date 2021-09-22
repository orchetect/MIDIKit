//
//  Continue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Real Time: Continue (Status `0xFB`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Continue (`0xFB`) is sent when a CONTINUE button is hit. A sequence will continue from its current location upon receipt of the next Timing Clock (`0xF8`)."
    public struct Continue: Equatable, Hashable {
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// System Real Time: Continue (Status `0xFB`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Continue (`0xFB`) is sent when a CONTINUE button is hit. A sequence will continue from its current location upon receipt of the next Timing Clock (`0xF8`)."
    public static func `continue`(group: MIDI.UInt4 = 0) -> Self {
        
        .continue(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.Continue {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xFB]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xFB,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}