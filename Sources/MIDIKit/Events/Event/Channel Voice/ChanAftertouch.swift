//
//  ChanAftertouch.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Channel Aftertouch (Status `0xD`)
    ///
    /// DAWs have slightly different terminology for this:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public struct ChanAftertouch: Equatable, Hashable {
        
        public var pressure: MIDI.UInt7
        
        public var channel: MIDI.UInt4
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// Channel Voice Message: Channel Aftertouch (Status `0xD`)
    ///
    /// DAWs have slightly different terminology for this:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public static func chanAftertouch(pressure: MIDI.UInt7,
                                      channel: MIDI.UInt4,
                                      group: MIDI.UInt4 = 0) -> Self {
        
        .chanAftertouch(
            .init(pressure: pressure,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.ChanAftertouch {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xD0 + channel.uInt8Value,
         pressure.uInt8Value]
        
    }
    
}

