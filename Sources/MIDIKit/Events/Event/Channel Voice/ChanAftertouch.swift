//
//  ChanAftertouch.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Channel Aftertouch
    ///
    /// DAWs have slightly different terminology for this:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public struct ChanAftertouch: Equatable, Hashable {
        
        /// Pressure
        public var pressure: MIDI.UInt7
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// Channel Voice Message: Channel Aftertouch
    ///
    /// DAWs have slightly different terminology for this:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    ///
    /// - Parameters:
    ///   - pressure: Pressure
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func chanAftertouch(pressure: MIDI.UInt7,
                                      channel: MIDI.UInt4,
                                      group: MIDI.UInt4 = 0x0) -> Self {
        
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
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xD0 + channel.uInt8Value,
                                pressure.uInt8Value,
                                0x00) // pad an empty byte to fill 4 bytes
        
        return [word]
        
    }
    
}

