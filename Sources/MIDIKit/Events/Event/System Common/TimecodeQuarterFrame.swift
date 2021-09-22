//
//  TimecodeQuarterFrame.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Common: Timecode Quarter-Frame (Status `0xF1`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "For device synchronization, MIDI Time Code uses two basic types of messages, described as Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System Exclusive Message."
    public struct TimecodeQuarterFrame: Equatable, Hashable {
        
        public var byte: MIDI.Byte
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// System Common: Timecode Quarter-Frame (Status `0xF1`)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "For device synchronization, MIDI Time Code uses two basic types of messages, described as Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System Exclusive Message."
    public static func timecodeQuarterFrame(byte: MIDI.Byte,
                                            group: MIDI.UInt4 = 0) -> Self {
        
        .timecodeQuarterFrame(
            .init(byte: byte,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.TimecodeQuarterFrame {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF1, byte]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF1,
                                byte,
                                0x00) // pad an empty byte to fill 4 bytes
        
        return [word]
        
    }
    
}
