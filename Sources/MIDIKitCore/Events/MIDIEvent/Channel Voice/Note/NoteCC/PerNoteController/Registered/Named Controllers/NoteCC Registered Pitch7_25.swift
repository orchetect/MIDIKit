//
//  NoteCC Registered Pitch7_25.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NoteCC.PerNoteController.Registered {
    /// Registered Per-Note Controller: Pitch 7.25
    /// (MIDI 2.0)
    ///
    /// A Q7.25 fixed-point unsigned integer that specifies a pitch in semitones.
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > Registered Per-Note Controller #3 is defined as Pitch 7.25. The message’s 32-bit data
    /// > field contains:
    /// > - 7 bits: Pitch in semitones, based on default Note Number equal temperament scale
    /// > - 25 bits: Fractional Pitch above Note Number (i.e., fraction of one semitone)
    public struct Pitch7_25 {
        /// 7-Bit coarse pitch in semitones, based on default Note Number equal temperament scale.
        public var coarse: UInt7
    
        /// 25-Bit fractional pitch above Note Number (i.e., fraction of one semitone).
        public var fine: UInt25
    }
}

extension MIDIEvent.NoteCC.PerNoteController.Registered.Pitch7_25: Equatable { }

extension MIDIEvent.NoteCC.PerNoteController.Registered.Pitch7_25: Hashable { }

extension MIDIEvent.NoteCC.PerNoteController.Registered.Pitch7_25: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.NoteCC.PerNoteController.Registered.Pitch7_25: Sendable { }
