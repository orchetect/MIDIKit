//
//  Note Off.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// Channel Voice Message: Note Off
    /// (MIDI 1.0 / 2.0)
    public struct Off: Equatable, Hashable {
        
        /// Note Number
        ///
        /// If MIDI 2.0 attribute is set to Pitch 7.9, then this value represents the note index.
        public var note: MIDI.UInt7
        
        /// Velocity
        @VelocityValidated
        public var velocity: MIDI.Event.Note.Velocity
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// MIDI 2.0 Channel Voice Attribute
        public var attribute: Attribute = .none
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(note: MIDI.UInt7,
                    velocity: MIDI.Event.Note.Velocity,
                    channel: MIDI.UInt4,
                    attribute: MIDI.Event.Note.Attribute = .none,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note
            self.velocity = velocity
            self.channel = channel
            self.attribute = attribute
            self.group = group
            
        }
        
        public init(note: MIDI.Note,
                    velocity: MIDI.Event.Note.Velocity,
                    channel: MIDI.UInt4,
                    attribute: MIDI.Event.Note.Attribute = .none,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note.number
            self.velocity = velocity
            self.channel = channel
            self.attribute = attribute
            self.group = group
            
        }
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Note Off
    /// (MIDI 1.0 / 2.0)
    /// 
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (0x0...0xF)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func noteOff(_ note: MIDI.UInt7,
                               velocity: Note.Velocity,
                               channel: MIDI.UInt4,
                               attribute: Note.Attribute = .none,
                               group: MIDI.UInt4 = 0x0) -> Self {
        
        .noteOff(
            .init(note: note,
                  velocity: velocity,
                  channel: channel,
                  attribute: attribute,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Note Off
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (0x0...0xF)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func noteOff(_ note: MIDI.Note,
                               velocity: Note.Velocity,
                               channel: MIDI.UInt4,
                               attribute: Note.Attribute = .none,
                               group: MIDI.UInt4 = 0x0) -> Self {
        
        .noteOff(
            .init(note: note.number,
                  velocity: velocity,
                  channel: channel,
                  attribute: attribute,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Note.Off {
    
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0x80 + channel.uInt8Value,
         note.uInt8Value,
         velocity.midi1Value.uInt8Value]
        
    }
    
    @inline(__always)
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        switch midiProtocol {
        case ._1_0:
            let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi1ChannelVoice
            
            let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0x80 + channel.uInt8Value,
                                    note.uInt8Value,
                                    velocity.midi1Value.uInt8Value)
            
            return [word]
            
        case ._2_0:
            let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi2ChannelVoice
            
            let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
            
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     0x80 + channel.uInt8Value,
                                     note.uInt8Value,
                                     attribute.attributeType)
            
            let word2 = MIDI.UMPWord(velocity.midi2Value,
                                     attribute.attributeData)
            
            return [word1, word2]
            
        }
        
    }
    
}
