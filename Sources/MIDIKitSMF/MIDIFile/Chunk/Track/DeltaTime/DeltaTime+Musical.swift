//
//  DeltaTime+Musical.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructors

extension MIDIFile.TrackChunk.DeltaTime where Timebase == MusicalMIDIFileTimebase {
    /// Construct delta time of a whole note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func noteWhole(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) * 4) }
    
    /// Construct delta time of a half note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func noteHalf(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) * 2) }
    
    /// Construct delta time of a quarter note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func noteQuarter(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq)) }
    
    /// Construct delta time of a 8th note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func note8th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 2) }
    
    /// Construct delta time of a 16th note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func note16th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 4) }
    
    /// Construct delta time of a 32nd note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func note32nd(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 8) }
    
    /// Construct delta time of a 64th note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func note64th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 16) }
    
    /// Construct delta time of a 128th note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func note128th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 32) }
    
    /// Construct delta time of a 256th note.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    public static func note256th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 64) }
    
    /// Construct delta time in beats (quarter-notes) as a floating-point value.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    ///
    /// For example:
    /// - `0.5` beats would equal an 8th-note
    /// - `1.5` beats would equal a quarter- & 8th- note tied duration
    /// - `4.0` beats would equal a whole-note (in 4/4 time signature)
    public static func beats(_ beats: Double, ppq: UInt16) -> Self {
        Self(ticks: UInt32(Double(ppq) * beats) )
    }
}

// MARK: - Methods

extension MIDIFile.TrackChunk.DeltaTime where Timebase == MusicalMIDIFileTimebase {
    /// Returns the musical beat duration of the delta time using the specified timebase.
    /// Ensure the `ppq` (ticks per quarter note) supplied is the same as used in the MIDI file.
    ///
    /// For example:
    ///
    /// - 480 ticks at 480 ppq == 1 beat == 0.25 beat duration
    /// - 960 ticks at 480 ppq == 2 beats == 0.5 beat duration
    public func quarterNoteBeats(atPPQ ppq: UInt16) -> Double {
        guard ppq > 0 else { return 0.0 }
        return Double(ticks) / Double(ppq)
    }
}
