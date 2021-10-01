//
//  Stop.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Real Time: Stop
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Stop (`0xFC`) is sent when a STOP button is hit. Playback in a receiver should stop immediately."
    public struct Stop: Equatable, Hashable {
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// System Real Time: Stop
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Stop (`0xFC`) is sent when a STOP button is hit. Playback in a receiver should stop immediately."
    ///
    /// - Parameters:
    ///   - group: UMP Group (0x0...0xF)
    public static func stop(group: MIDI.UInt4 = 0x0) -> Self {
        
        .stop(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.Stop {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xFC]
        
    }
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xFC,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}
