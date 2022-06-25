//
//  Note PitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// Channel Voice Message: Per-Note Pitch Bend
    /// (MIDI 2.0)
    public struct PitchBend: Equatable, Hashable {
        
        /// Note Number
        ///
        /// If attribute is set to Pitch 7.9, then this value represents the note index.
        public var note: MIDI.Note
        
        /// 32-bit Value (0...0xFFFFFFFF) where midpoint is 0x80000000
        @ValueValidated
        public var value: Value
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        /// Channel Voice Message: Per-Note Pitch Bend
        /// (MIDI 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - value: 32-bit Value (0...0xFFFFFFFF) where midpoint is 0x80000000
        ///   - channel: Channel Number (0x0...0xF)
        ///   - group: UMP Group (0x0...0xF)
        public init(note: MIDI.UInt7,
                    value: Value,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = MIDI.Note(note)
            self.value = value
            self.channel = channel
            self.group = group
            
        }
        
        /// Channel Voice Message: Per-Note Pitch Bend
        /// (MIDI 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - value: 32-bit Value (0...0xFFFFFFFF) where midpoint is 0x80000000
        ///   - channel: Channel Number (0x0...0xF)
        ///   - group: UMP Group (0x0...0xF)
        public init(note: MIDI.Note,
                    value: Value,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note
            self.value = value
            self.channel = channel
            self.group = group
            
        }
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Per-Note Pitch Bend
    /// (MIDI 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - value: 32-bit Value (0...0xFFFFFFFF) where midpoint is 0x80000000
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func notePitchBend(note: MIDI.UInt7,
                                     value: Note.PitchBend.Value,
                                     channel: MIDI.UInt4,
                                     group: MIDI.UInt4 = 0x0) -> Self {
        
        .notePitchBend(
            .init(note: MIDI.Note(note),
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Per-Note Pitch Bend
    /// (MIDI 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - value: 32-bit Value (0...0xFFFFFFFF) where midpoint is 0x80000000
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func notePitchBend(note: MIDI.Note,
                                     value: Note.PitchBend.Value,
                                     channel: MIDI.UInt4,
                                     group: MIDI.UInt4 = 0x0) -> Self {
        
        .notePitchBend(
            .init(note: note,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Note.PitchBend {
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.IO.Packet.UniversalPacketData.MessageType = .midi2ChannelVoice
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        // MIDI 2.0 only
        
        let word1 = MIDI.UMPWord(mtAndGroup,
                                 0x60 + channel.uInt8Value,
                                 note.number.uInt8Value,
                                 0x00) // reserved
        
        let word2 = value.midi2Value
        
        return [word1, word2]
        
    }
    
}
