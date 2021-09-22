//
//  TimingClock.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Real Time: Timing Clock (Status `0xF8`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Clock-based MIDI systems are synchronized with this message, which is sent at a rate of 24 per quarter note. If Timing Clocks (`0xF8`) are sent during idle time they should be sent at the current tempo setting of the transmitter even while it is not playing. Receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) can thus phase lock their internal clocks while waiting for a Start (`0xFA`) or Continue (`0xFB`) command."
    public struct TimingClock: Equatable, Hashable {
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// System Real Time: Timing Clock (Status `0xF8`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Clock-based MIDI systems are synchronized with this message, which is sent at a rate of 24 per quarter note. If Timing Clocks (`0xF8`) are sent during idle time they should be sent at the current tempo setting of the transmitter even while it is not playing. Receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) can thus phase lock their internal clocks while waiting for a Start (`0xFA`) or Continue (`0xFB`) command."
    public static func timingClock(group: MIDI.UInt4 = 0) -> Self {
        
        .timingClock(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.TimingClock {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF8]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF8,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}
