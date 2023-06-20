//
//  NoteOn.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Note On
    /// (MIDI 1.0 / 2.0)
    public struct NoteOn {
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
    
        /// For MIDI 1.0, translate velocity of 0 as a Note Off event.
        public var midi1ZeroVelocityAsNoteOff: Bool = true
    
        /// Channel Voice Message: Note On
        /// (MIDI 1.0 / 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - velocity: Velocity
        ///   - channel: Channel Number (`0x0 ... 0xF`)
        ///   - attribute: MIDI 2.0 Channel Voice Attribute
        ///   - group: UMP Group (`0x0 ... 0xF`)
        ///   - midi1ZeroVelocityAsNoteOff: For MIDI 1.0, translate velocity of 0 as a Note Off
        /// event.
        public init(
            note: UInt7,
            velocity: MIDIEvent.NoteVelocity,
            attribute: MIDIEvent.NoteAttribute = .none,
            channel: UInt4,
            group: UInt4 = 0x0,
            midi1ZeroVelocityAsNoteOff: Bool = false
        ) {
            self.note = MIDINote(note)
            self.velocity = velocity
            self.channel = channel
            self.attribute = attribute
            self.group = group
            self.midi1ZeroVelocityAsNoteOff = midi1ZeroVelocityAsNoteOff
        }
    
        /// Channel Voice Message: Note On
        /// (MIDI 1.0 / 2.0)
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - velocity: Velocity
        ///   - channel: Channel Number (`0x0 ... 0xF`)
        ///   - attribute: MIDI 2.0 Channel Voice Attribute
        ///   - group: UMP Group (`0x0 ... 0xF`)
        ///   - midi1ZeroVelocityAsNoteOff: For MIDI 1.0, translate velocity of 0 as a Note Off
        /// event.
        public init(
            note: MIDINote,
            velocity: MIDIEvent.NoteVelocity,
            attribute: MIDIEvent.NoteAttribute = .none,
            channel: UInt4,
            group: UInt4 = 0x0,
            midi1ZeroVelocityAsNoteOff: Bool = false
        ) {
            self.note = note
            self.velocity = velocity
            self.channel = channel
            self.attribute = attribute
            self.group = group
            self.midi1ZeroVelocityAsNoteOff = midi1ZeroVelocityAsNoteOff
        }
    }
}

extension MIDIEvent.NoteOn: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // ensure midi1ZeroVelocityAsNoteOff is not factored into Equatable
    
        lhs.note == rhs.note &&
            lhs.velocity == rhs.velocity &&
            lhs.attribute == rhs.attribute &&
            lhs.channel == rhs.channel &&
            lhs.group == rhs.group
    }
}

extension MIDIEvent.NoteOn: Hashable {
    public func hash(into hasher: inout Hasher) {
        // ensure midi1ZeroVelocityAsNoteOff is not factored into Hashable
    
        hasher.combine(note)
        hasher.combine(velocity)
        hasher.combine(attribute)
        hasher.combine(channel)
        hasher.combine(group)
    }
}

extension MIDIEvent {
    /// Channel Voice Message: Note On
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (`0x0 ... 0xF`)
    ///   - midi1ZeroVelocityAsNoteOff: For MIDI 1.0, translate velocity of 0 as a Note Off event.
    public static func noteOn(
        _ note: UInt7,
        velocity: NoteVelocity,
        attribute: NoteAttribute = .none,
        channel: UInt4,
        group: UInt4 = 0x0,
        midi1ZeroVelocityAsNoteOff: Bool = false
    ) -> Self {
        .noteOn(
            .init(
                note: note,
                velocity: velocity,
                attribute: attribute,
                channel: channel,
                group: group,
                midi1ZeroVelocityAsNoteOff: midi1ZeroVelocityAsNoteOff
            )
        )
    }
    
    /// Channel Voice Message: Note On
    /// (MIDI 1.0 / 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (`0x0 ... 0xF`)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (`0x0 ... 0xF`)
    ///   - midi1ZeroVelocityAsNoteOff: For MIDI 1.0, translate velocity of 0 as a Note Off event.
    public static func noteOn(
        _ note: MIDINote,
        velocity: NoteVelocity,
        attribute: NoteAttribute = .none,
        channel: UInt4,
        group: UInt4 = 0x0,
        midi1ZeroVelocityAsNoteOff: Bool = false
    ) -> Self {
        .noteOn(
            .init(
                note: note.number,
                velocity: velocity,
                attribute: attribute,
                channel: channel,
                group: group,
                midi1ZeroVelocityAsNoteOff: midi1ZeroVelocityAsNoteOff
            )
        )
    }
}

extension MIDIEvent.NoteOn {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        switch velocity {
        case .midi1, .unitInterval:
            if velocity.midi1Value == 0, midi1ZeroVelocityAsNoteOff {
                // send as Note Off event
                return 0x80 + channel.uInt8Value
            } else {
                // send as Note On event
                return 0x90 + channel.uInt8Value
            }
        case .midi2:
            // send as Note On event
            return 0x90 + channel.uInt8Value
        }
    }
    
    /// Returns the raw MIDI 1.0 data bytes for the event (excluding status byte).
    public func midi1RawDataBytes() -> (data1: UInt8, data2: UInt8) {
        switch velocity {
        case .midi1, .unitInterval:
            return (data1: note.number.uInt8Value, data2: velocity.midi1Value.uInt8Value)
        case .midi2:
            // MIDI 2.0 Spec:
            // When translating a MIDI 2.0 Note On message to the MIDI 1.0 Protocol, if the
            // translated MIDI 1.0 value of the Velocity is zero, then the Translator shall replace
            // the zero with a value of 1.
            
            var midi1Velocity = velocity.midi1Value.uInt8Value
            if midi1Velocity == 0 { midi1Velocity = 1 }
            return (data1: note.number.uInt8Value, data2: midi1Velocity)
        }
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        let dataBytes = midi1RawDataBytes()
        return [midi1RawStatusByte(), dataBytes.data1, dataBytes.data2]
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
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> [UMPWord] {
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
            .uInt8Value
    
        switch midiProtocol {
        case ._1_0:
            let midi1Bytes = midi1RawBytes() // always 3 bytes
    
            let word = UMPWord(
                mtAndGroup,
                midi1Bytes[0],
                midi1Bytes[1],
                midi1Bytes[2]
            )
    
            return [word]
    
        case ._2_0:
            // MIDI 2.0 Spec:
            // The allowable Velocity range for a MIDI 2.0 Note On message is 0x0000-0xFFFF. Unlike
            // the MIDI 1.0 Note On message, a velocity value of zero does not function as a Note
            // Off.
    
            let word1 = UMPWord(
                mtAndGroup,
                0x90 + channel.uInt8Value,
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
