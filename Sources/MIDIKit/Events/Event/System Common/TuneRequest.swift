//
//  TuneRequest.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Common: Tune Request (Status `0xF6`)
    ///
    /// - remark: MIDI Spec:
    ///
    /// "Used with analog synthesizers to request that all oscillators be tuned."
    public struct TuneRequest: Equatable, Hashable {
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// System Common: Tune Request (Status `0xF6`)
    ///
    /// - remark: MIDI Spec:
    ///
    /// "Used with analog synthesizers to request that all oscillators be tuned."
    public static func tuneRequest(group: MIDI.UInt4 = 0) -> Self {
        
        .tuneRequest(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.TuneRequest {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF6]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xF6,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}
