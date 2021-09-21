//
//  ProgramChange.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Program Change (Status `0xC`)
    public struct ProgramChange: Equatable, Hashable {
        
        public var program: MIDI.UInt7
        
        public var channel: MIDI.UInt4
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// Channel Voice Message: Program Change (Status `0xC`)
    public static func programChange(program: MIDI.UInt7,
                                     channel: MIDI.UInt4,
                                     group: MIDI.UInt4 = 0) -> Self {
        
        .programChange(
            .init(program: program,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.ProgramChange {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xC0 + channel.uInt8Value,
         program.uInt8Value]
        
    }
    
}
