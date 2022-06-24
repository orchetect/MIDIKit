//
//  Note CC.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note {
    
    /// Channel Voice Message: Per-Note Control Change (CC)
    /// (MIDI 2.0)
    public struct CC: Equatable, Hashable {
        
        /// Note Number
        ///
        /// If attribute is set to Pitch 7.9, then this value represents the note index.
        public var note: MIDI.UInt7
        
        /// Controller
        public var controller: Controller
        
        /// Value
        @ValueValidated
        public var value: Value
        
        /// Channel Number (0x0...0xF)
        public var channel: MIDI.UInt4
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        /// Channel Voice Message: Per-Note Control Change (CC)
        /// (MIDI 2.0)
        ///
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - controller: Controller type
        ///   - value: Value
        ///   - channel: Channel Number (0x0...0xF)
        ///   - group: UMP Group (0x0...0xF)
        public init(note: MIDI.UInt7,
                    controller: Controller,
                    value: Value,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note
            self.controller = controller
            self.value = value
            self.channel = channel
            self.group = group
            
        }
        
        /// Channel Voice Message: Per-Note Control Change (CC)
        /// (MIDI 2.0)
        ///
        ///
        /// - Parameters:
        ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
        ///   - controller: Controller type
        ///   - value: Value
        ///   - channel: Channel Number (0x0...0xF)
        ///   - group: UMP Group (0x0...0xF)
        public init(note: MIDI.Note,
                    controller: Controller,
                    value: Value,
                    channel: MIDI.UInt4,
                    group: MIDI.UInt4 = 0x0) {
            
            self.note = note.number
            self.controller = controller
            self.value = value
            self.channel = channel
            self.group = group
            
        }
        
    }
    
}

extension MIDI.Event {
    
    /// Channel Voice Message: Per-Note Control Change (CC)
    /// (MIDI 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - controller: Controller type
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func noteCC(note: MIDI.UInt7,
                              controller: Note.CC.Controller,
                              value: Note.CC.Value,
                              channel: MIDI.UInt4,
                              group: MIDI.UInt4 = 0x0) -> Self {
        
        .noteCC(
            .init(note: note,
                  controller: controller,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
    /// Channel Voice Message: Per-Note Control Change (CC)
    /// (MIDI 2.0)
    ///
    /// - Parameters:
    ///   - note: Note Number (or Note Index if using MIDI 2.0 Pitch 7.9)
    ///   - controller: Controller type
    ///   - value: Value
    ///   - channel: Channel Number (0x0...0xF)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func noteCC(note: MIDI.Note,
                              controller: Note.CC.Controller,
                              value: Note.CC.Value,
                              channel: MIDI.UInt4,
                              group: MIDI.UInt4 = 0x0) -> Self {
        
        .noteCC(
            .init(note: note.number,
                  controller: controller,
                  value: value,
                  channel: channel,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.Note.CC {
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .midi2ChannelVoice
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        // MIDI 2.0 only
        
        let statusByte: MIDI.Byte
        let index: MIDI.Byte
        
        switch controller {
        case .assignable(let ccNum):
            statusByte = 0x10
            index = ccNum
            
        case .registered(let ccNum):
            statusByte = 0x00
            index = ccNum.number
            
        }
        
        let word1 = MIDI.UMPWord(mtAndGroup,
                                 statusByte + channel.uInt8Value,
                                 note.uInt8Value,
                                 index)
        
        let word2 = value.midi2Value
        
        return [word1, word2]
        
    }
    
}
