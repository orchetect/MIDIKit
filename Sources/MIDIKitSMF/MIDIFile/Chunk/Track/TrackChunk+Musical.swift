//
//  TrackChunk+Musical.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Methods

extension MIDIFile.TrackChunk where Timebase == MusicalMIDIFileTimebase {
    /// Returns ``events`` mapped to their quarter-note beat position from the start of the track.
    /// This is computed, so avoid repeated calls to this method.
    /// Ensure the `ppq` (ticks per quarter note) supplied is the same as used in the MIDI file.
    public func eventsAtQuarterNotePositions(atPPQ ppq: UInt16) -> [(beat: Double, event: Event)] {
        var position = 0.0
        return events.map {
            position += $0.delta.quarterNoteBeats(atPPQ: ppq)
            return (beat: position, event: $0)
        }
    }
}
