//
//  Note Off.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// Channel Voice Message: Note Off
    public struct Off: Equatable, Hashable {
        
        public var note: MIDI.UInt7
        
        public var velocity: MIDI.Event.Note.Velocity
        
        public var channel: MIDI.UInt4
        
        /// MIDI 2.0 Channel Voice Attribute
        public var attribute: Attribute = .none
        
        /// MIDI UMP Group
        public var group: MIDI.UInt4 = 0
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Note Off
    public static func noteOff(_ note: MIDI.UInt7,
                               velocity: Note.Velocity,
                               channel: MIDI.UInt4,
                               attribute: Note.Attribute = .none,
                               group: MIDI.UInt4 = 0) -> Self {
        
        .noteOff(
            .init(note: note,
                  velocity: velocity,
                  channel: channel,
                  attribute: attribute,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Note Off
    public static func noteOff(_ note: MIDI.UInt7,
                               velocity: Double,
                               channel: MIDI.UInt4,
                               attribute: Note.Attribute = .none,
                               group: MIDI.UInt4 = 0) -> Self {
        
        .noteOff(
            .init(note: note,
                  velocity: .unitInterval(velocity),
                  channel: channel,
                  attribute: attribute,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Note.Off {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0x80 + channel.uInt8Value,
         note.uInt8Value,
         velocity.midi1Value.uInt8Value]
        
    }
    
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
    
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        switch midiProtocol {
        case ._1_0:
            let word = MIDI.UMPWord(mtAndGroup,
                                    0x80 + channel.uInt8Value,
                                    note.uInt8Value,
                                    velocity.midi1Value.uInt8Value)
            
            return [word]
            
        case ._2_0:
            #warning("> code this")
            return []
            
        }
        
    }
    
}
