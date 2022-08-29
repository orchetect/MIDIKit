//
//  NoteOff.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Note Off
    /// (MIDI 1.0 / 2.0)
    public struct NoteOff: Equatable, Hashable {
        /// Note Number
        ///
        /// If MIDI 2.0 attribute is set to Pitch 7.9, then this value represents the note index.
        public var note: MIDINote
    
        /// Velocity
        @MIDIEvent.NoteVelocityValidated
        public var velocity: MIDIEvent.NoteVelocity
    
        /// MIDI 2.0 Channel Voice Attribute
        public var attribute: NoteAttribute = .none
    
        /// Channel Number (`0x0 ... 0xF`)
        public var channel: UInt4
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        /// Channel Voice Message: Note Off
        /// (MIDI 1.0 / 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - velocity: Velocity
        ///   - channel: Channel Number (`0x0 ... 0xF`)
        ///   - attribute: MIDI 2.0 Channel Voice Attribute
        ///   - group: UMP Group (`0x0 ... 0xF`)
        public init(
            note: UInt7,
            velocity: MIDIEvent.NoteVelocity,
            attribute: MIDIEvent.NoteAttribute = .none,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = MIDINote(note)
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
        ///   - channel: Channel Number (`0x0 ... 0xF`)
        ///   - attribute: MIDI 2.0 Channel Voice Attribute
        ///   - group: UMP Group (`0x0 ... 0xF`)
        public init(
            note: MIDINote,
            velocity: MIDIEvent.NoteVelocity,
            attribute: MIDIEvent.NoteAttribute = .none,
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = note
            self.velocity = velocity
            self.channel = channel
            self.attribute = attribute
            self.group = group
        }
    }
}

extension MIDIEvent {
    /// Channel Voice Message: Note Off
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func noteOff(
        _ note: UInt7,
        velocity: NoteVelocity,
        attribute: NoteAttribute = .none,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .noteOff(
            .init(
                note: note,
                velocity: velocity,
                attribute: attribute,
                channel: channel,
                group: group
            )
        )
    }
    
    /// Channel Voice Message: Note Off
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func noteOff(
        _ note: MIDINote,
        velocity: NoteVelocity,
        attribute: NoteAttribute = .none,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .noteOff(
            .init(
                note: note.number,
                velocity: velocity,
                attribute: attribute,
                channel: channel,
                group: group
            )
        )
    }
}

extension MIDIEvent.NoteOff {
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        [
            0x80 + channel.uInt8Value,
            note.number.uInt8Value,
            velocity.midi1Value.uInt8Value
        ]
    }
    
    private func umpMessageType(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> MIDIUMPMessageType {
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
    public func umpRawWords(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> [UMPWord] {
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group.uInt8Value
    
        switch midiProtocol {
        case ._1_0:
            let word = UMPWord(
                mtAndGroup,
                0x80 + channel.uInt8Value,
                note.number.uInt8Value,
                velocity.midi1Value.uInt8Value
            )
    
            return [word]
    
        case ._2_0:
            let word1 = UMPWord(
                mtAndGroup,
                0x80 + channel.uInt8Value,
                note.number.uInt8Value,
                attribute.attributeType
            )
    
            let word2 = UMPWord(
                velocity.midi2Value,
                attribute.attributeData
            )
    
            return [word1, word2]
        }
    }
}
