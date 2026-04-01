//
//  TrackChunk+Musical.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Methods

extension MIDIFile.TrackChunk where Timebase == MusicalMIDIFileTimebase {
    /// Returns ``events`` mapped to their quarter-note beat position from the start of the track.
    /// Ensure the timebase `ppq` (ticks per quarter note) value is the same value specified in the MIDI file header.
    ///
    /// This is computed each time this method is called, so avoid repeated calls to this method where possible.
    public func eventsAtBeatPositions(using timebase: Timebase) -> [(beat: Double, event: MIDIFileTrackEvent)] {
        var position = 0.0
        return events.map {
            position += $0.delta.quarterNoteBeats(using: timebase)
            return (beat: position, event: $0.event)
        }
    }
}
