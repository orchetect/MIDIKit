//
//  PolyAftertouch.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice Message: Polyphonic Aftertouch
    ///
    /// DAWs have slightly different terminology for this:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public struct PolyAftertouch: Equatable, Hashable {
        
        /// Note Number for which pressure is applied
        public var note: MIDI.UInt7
        
        /// Pressure
        public var pressure: MIDI.UInt7
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// Channel Voice Message: Polyphonic Aftertouch
    ///
    /// DAWs have slightly different terminology for this:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    ///
    /// - Parameters:
    ///   - note: Note Number for which pressure is applied
    ///   - pressure: Pressure
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    public static func polyAftertouch(note: MIDI.UInt7,
                                      pressure: MIDI.UInt7,
                                      channel: MIDI.UInt4,
                                      group: MIDI.UInt4 = 0x0) -> Self {
        
        .polyAftertouch(
            .init(note: note,
                  pressure: pressure,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.PolyAftertouch {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xA0 + channel.uInt8Value,
         note.uInt8Value,
         pressure.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xA0 + channel.uInt8Value,
                                note.uInt8Value,
                                pressure.uInt8Value)
        
        return [word]
        
    }
    
}
