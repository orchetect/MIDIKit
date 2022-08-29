//
//  NotePitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Per-Note Pitch Bend
    /// (MIDI 2.0)
    public struct NotePitchBend: Equatable, Hashable {
        /// Note Number
        ///
        /// If attribute is set to Pitch 7.9, then this value represents the note index.
        public var note: MIDINote
    
        /// 32-bit Value (`0 ... 0xFFFFFFFF`) where midpoint is `0x80000000`
        @ValueValidated
        public var value: Value
    
        /// Channel Number (`0x0 ... 0xF`)
        public var channel: UInt4
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        /// Channel Voice Message: Per-Note Pitch Bend
        /// (MIDI 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - value: 32-bit Value (`0 ... 0xFFFFFFFF`) where midpoint is `0x80000000`
        ///   - channel: Channel Number (`0x0 ... 0xF`)
        ///   - group: UMP Group (`0x0 ... 0xF`)
        public init(
            note: UInt7,
            value: Value,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = MIDINote(note)
            self.value = value
            self.channel = channel
            self.group = group
        }
    
        /// Channel Voice Message: Per-Note Pitch Bend
        /// (MIDI 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - value: 32-bit Value (`0 ... 0xFFFFFFFF`) where midpoint is `0x80000000`
        ///   - channel: Channel Number (`0x0 ... 0xF`)
        ///   - group: UMP Group (`0x0 ... 0xF`)
        public init(
            note: MIDINote,
            value: Value,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = note
            self.value = value
            self.channel = channel
            self.group = group
        }
    }
}

extension MIDIEvent {
    /// Channel Voice Message: Per-Note Pitch Bend
    /// (MIDI 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - value: 32-bit Value (`0 ... 0xFFFFFFFF`) where midpoint is `0x80000000`
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func notePitchBend(
        note: UInt7,
        value: NotePitchBend.Value,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .notePitchBend(
            .init(
                note: MIDINote(note),
                value: value,
                channel: channel,
                group: group
            )
        )
    }
    
    /// Channel Voice Message: Per-Note Pitch Bend
    /// (MIDI 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - value: 32-bit Value (`0 ... 0xFFFFFFFF`) where midpoint is `0x80000000`
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func notePitchBend(
        note: MIDINote,
        value: NotePitchBend.Value,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .notePitchBend(
            .init(
                note: note,
                value: value,
                channel: channel,
                group: group
            )
        )
    }
}

extension MIDIEvent.NotePitchBend {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: MIDIUMPMessageType = .midi2ChannelVoice
    
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group.uInt8Value
    
        // MIDI 2.0 only
    
        let word1 = UMPWord(
            mtAndGroup,
            0x60 + channel.uInt8Value,
            note.number.uInt8Value,
            0x00
        ) // reserved
    
        let word2 = value.midi2Value
    
        return [word1, word2]
    }
}
