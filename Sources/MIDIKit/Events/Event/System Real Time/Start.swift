//
//  Start.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Real Time: Start
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Start (`0xFA`) is sent when a PLAY button on the master (sequencer or drum machine) is pressed. This message commands all receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) to start at the beginning of the song or sequence."
    public struct Start: Equatable, Hashable {
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// System Real Time: Start
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Start (`0xFA`) is sent when a PLAY button on the master (sequencer or drum machine) is pressed. This message commands all receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) to start at the beginning of the song or sequence."
    ///
    /// - Parameters:
    ///   - group: UMP Group (0x0...0xF)
    public static func start(group: MIDI.UInt4 = 0x0) -> Self {
        
        .start(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.Start {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xFA]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xFA,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}
