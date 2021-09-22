//
//  Stop.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Real Time: Stop (Status `0xFC`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Stop (`0xFC`) is sent when a STOP button is hit. Playback in a receiver should stop immediately."
    public struct Stop: Equatable, Hashable {
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// System Real Time: Stop (Status `0xFC`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Stop (`0xFC`) is sent when a STOP button is hit. Playback in a receiver should stop immediately."
    public static func stop(group: MIDI.UInt4 = 0) -> Self {
        
        .stop(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.Stop {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xFC]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xFC,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}