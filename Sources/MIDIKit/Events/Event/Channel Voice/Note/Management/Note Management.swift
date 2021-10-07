//
//  Note Management.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// Channel Voice Message: Per-Note Management
    /// (MIDI 2.0)
    ///
    /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per- Note Controllers to multiple Notes on the same Note Number.
    public struct Management: Equatable, Hashable {
        
        /// Note Number
        ///
        /// If MIDI 2.0 attribute is set to Pitch 7.9, then this value represents the note index.
        public var note: MIDI.UInt7
        
        /// Option Flags
        public var optionFlags: Set<OptionFlag> = []
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Per-Note Management
    /// (MIDI 2.0)
    ///
    /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per- Note Controllers to multiple Notes on the same Note Number.
    /// 
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - velocity: Velocity
    ///   - channel: Channel Number (0x0...0xF)
    ///   - attribute: MIDI 2.0 Channel Voice Attribute
    ///   - group: UMP Group (0x0...0xF)
    public static func noteManagement(_ note: MIDI.UInt7,
                                      flags: Set<Note.Management.OptionFlag>,
                                      channel: MIDI.UInt4,
                                      group: MIDI.UInt4 = 0x0) -> Self {
        
        .noteManagement(
            .init(note: note,
                  optionFlags: flags,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Note.Management {
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi2ChannelVoice
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        // MIDI 2.0 only
        
        #warning("> TODO: umpRawWords() needs coding")
        _ = mtAndGroup
        
        //let word1 = MIDI.UMPWord()
        
        return []
        
    }
    
}


// MARK: - OptionFlag

extension MIDI.Event.Note.Management {
    
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

extension MIDI.Event.Note.Management.OptionFlag: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .detachPerNoteControllers:
            return "detachPerNoteControllers"
            
        case .resetPerNoteControllers:
            return "resetPerNoteControllers"
            
        }
        
    }
    
}

extension Collection where Element == MIDI.Event.Note.Management.OptionFlag {
    
    public var description: String {
        
        "[" + map { $0.description }.joined(separator: ", ") + "]"
        
    }
    
}
