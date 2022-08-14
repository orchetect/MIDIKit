//
//  Note Management.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice Message: Per-Note Management
    /// (MIDI 2.0)
    ///
    /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per-Note Controllers to multiple Notes on the same Note Number.
    public struct NoteManagement: Equatable, Hashable {
        /// Note Number
        ///
        /// If MIDI 2.0 attribute is set to Pitch 7.9, then this value represents the note index.
        public var note: MIDINote
        
        /// Option Flags
        public var optionFlags: Set<OptionFlag> = []
        
        /// Channel Number (0x0...0xF)
        public var channel: UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: UInt4 = 0x0
        
        /// Channel Voice Message: Per-Note Management
        /// (MIDI 2.0)
        ///
        /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per-Note Controllers to multiple Notes on the same Note Number.
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - velocity: Velocity
        ///   - channel: Channel Number (0x0...0xF)
        ///   - attribute: MIDI 2.0 Channel Voice Attribute
        ///   - group: UMP Group (0x0...0xF)
        public init(
            note: UInt7,
            optionFlags: Set<OptionFlag> = [],
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = MIDINote(note)
            self.optionFlags = optionFlags
            self.channel = channel
            self.group = group
        }
        
        /// Channel Voice Message: Per-Note Management
        /// (MIDI 2.0)
        ///
        /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per-Note Controllers to multiple Notes on the same Note Number.
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - velocity: Velocity
        ///   - channel: Channel Number (0x0...0xF)
        ///   - attribute: MIDI 2.0 Channel Voice Attribute
        ///   - group: UMP Group (0x0...0xF)
        public init(
            note: MIDINote,
            optionFlags: Set<OptionFlag> = [],
            channel: UInt4,
            group: UInt4 = 0x0
        ) {
            self.note = note
            self.optionFlags = optionFlags
            self.channel = channel
            self.group = group
        }
    }
}

extension MIDIEvent {
    /// Channel Voice Message: Per-Note Management
    /// (MIDI 2.0)
    ///
    /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per-Note Controllers to multiple Notes on the same Note Number.
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (0x0...0xF)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (0x0...0xF)
    public static func noteManagement(
        note: UInt7,
        flags: Set<NoteManagement.OptionFlag>,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .noteManagement(
            .init(
                note: note,
                optionFlags: flags,
                channel: channel,
                group: group
            )
        )
    }
    
    /// Channel Voice Message: Per-Note Management
    /// (MIDI 2.0)
    ///
    /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per-Note Controllers to multiple Notes on the same Note Number.
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (0x0...0xF)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (0x0...0xF)
    public static func noteManagement(
        note: MIDINote,
        flags: Set<NoteManagement.OptionFlag>,
        channel: UInt4,
        group: UInt4 = 0x0
    ) -> Self {
        .noteManagement(
            .init(
                note: note.number,
                optionFlags: flags,
                channel: channel,
                group: group
            )
        )
    }
}

extension MIDIEvent.NoteManagement {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: UniversalMIDIPacketData.MessageType = .midi2ChannelVoice
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        // MIDI 2.0 only
        
        let word1 = UMPWord(
            mtAndGroup,
            0xF0 + channel.uInt8Value,
            note.number.uInt8Value,
            optionFlags.byte
        )
        
        let word2: UInt32 = 0x0000_0000 // reserved
        
        return [word1, word2]
    }
}

// MARK: - OptionFlag

extension MIDIEvent.NoteManagement {
    /// Per-Note Management Option Flag
    /// (MIDI 2.0)
    public enum OptionFlag: Equatable, Hashable {
        /// [D] Detach Per-Note Controllers from previously received Note(s)
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// "When a device receives a Per-Note Management message with D = 1 (Detach), all currently playing notes and previous notes on the referenced Note Number shall no longer respond to any Per-Note controllers. Currently playing notes shall maintain the current values for all Per-Note controllers until the end of the note life cycle."
        case detachPerNoteControllers
        
        /// [S] Reset/Set Per-Note Controllers to default values
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// "When a device receives a Per-Note Management message with S = 1, all Per-Note controllers on the referenced Note Number should be reset to their default values."
        case resetPerNoteControllers
    }
}

extension Set where Element == MIDIEvent.NoteManagement.OptionFlag {
    /// Per-Note Management Option Flag
    /// (MIDI 2.0)
    ///
    /// Initialize flags from a raw option flags byte.
    public init(byte: Byte) {
        self.init()
        
        if byte & 0b0000_0001 == 1 {
            insert(.resetPerNoteControllers)
        }
        
        if (byte & 0b0000_0010) >> 1 == 1 {
            insert(.detachPerNoteControllers)
        }
    }
    
    /// Returns the flags as a raw option flags byte.
    public var byte: Byte {
        var byte: Byte = 0b0000_0000
        
        if contains(.resetPerNoteControllers) {
            byte |= 0b0000_0001
        }
        
        if contains(.detachPerNoteControllers) {
            byte |= 0b0000_0010
        }
        
        return byte
    }
}

extension MIDIEvent.NoteManagement.OptionFlag: CustomStringConvertible {
    public var description: String {
        switch self {
        case .detachPerNoteControllers:
            return "detachPerNoteControllers"
            
        case .resetPerNoteControllers:
            return "resetPerNoteControllers"
        }
    }
}

extension Collection where Element == MIDIEvent.NoteManagement.OptionFlag {
    public var description: String {
        "[" + map { $0.description }.joined(separator: ", ") + "]"
    }
}
