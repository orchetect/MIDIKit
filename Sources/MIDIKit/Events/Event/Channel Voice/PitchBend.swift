//
//  PitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Program Change (Status `0xC`)
    public struct PitchBend: Equatable, Hashable {
        
        public var value: MIDI.UInt14
        
        public var channel: MIDI.UInt4
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// Channel Voice Message: Program Change (Status `0xC`)
    public static func pitchBend(value: MIDI.UInt14,
                                 channel: MIDI.UInt4,
                                 group: MIDI.UInt4 = 0) -> Self {
        
        .pitchBend(
            .init(value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.PitchBend {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        let bytePair = value.bytePair
        
        return [0xE0 + channel.uInt8Value,
                bytePair.lsb,
                bytePair.msb]
        
    }
    
}
