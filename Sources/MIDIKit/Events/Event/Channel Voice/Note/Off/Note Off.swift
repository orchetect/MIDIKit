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
        public var note: MIDI.Note
        
        /// Velocity
        @VelocityValidated
        public var velocity: MIDI.Event.Note.Velocity
        
        /// MIDI 2.0 Channel Voice Attribute
        public var attribute: Attribute = .none
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        /// Channel Voice Message: Note Off
        /// (MIDI 1.0 / 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - velocity: Velocity
        ///   - channel: Channel Number (0x0...0xF)
        ///   - attribute: MIDI 2.0 Channel Voice Attribute
        ///   - group: UMP Group (0x0...0xF)
        public init(note: MIDI.UInt7,
                    velocity: MIDI.Event.Note.Velocity,
                    attribute: MIDI.Event.Note.Attribute = .none,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = MIDI.Note(note)
            self.velocity = velocity
            self.channel = channel
            self.attribute = attribute
            self.group = group
            
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
        public init(note: MIDI.Note,
                    velocity: MIDI.Event.Note.Velocity,
                    attribute: MIDI.Event.Note.Attribute = .none,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note
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
                               attribute: Note.Attribute = .none,
                               channel: MIDI.UInt4,
                               group: MIDI.UInt4 = 0x0) -> Self {
        
        .noteOff(
            .init(note: note,
                  velocity: velocity,
                  attribute: attribute,
                  channel: channel,
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
                               attribute: Note.Attribute = .none,
                               channel: MIDI.UInt4,
                               group: MIDI.UInt4 = 0x0) -> Self {
        
        .noteOff(
            .init(note: note.number,
                  velocity: velocity,
                  attribute: attribute,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Note.Off {
    
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0x80 + channel.uInt8Value,
         note.number.uInt8Value,
         velocity.midi1Value.uInt8Value]
        
    }
    
    @inline(__always)
    private func umpMessageType(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> MIDI.Packet.UniversalPacketData.MessageType {
        
        switch midiProtocol {
        case ._1_0:
            return .midi1ChannelVoice
            
        case ._2_0:
            return .midi2ChannelVoice
        }
        
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
        
        switch midiProtocol {
        case ._1_0:
            let word = MIDI.UMPWord(mtAndGroup,
                                    0x80 + channel.uInt8Value,
                                    note.number.uInt8Value,
                                    velocity.midi1Value.uInt8Value)
            
            return [word]
            
        case ._2_0:
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     0x80 + channel.uInt8Value,
                                     note.number.uInt8Value,
                                     attribute.attributeType)
            
            let word2 = MIDI.UMPWord(velocity.midi2Value,
                                     attribute.attributeData)
            
            return [word1, word2]
            
        }
        
    }
    
}
