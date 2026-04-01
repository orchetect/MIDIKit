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
    
    /// Returns the first tempo event found in the track's events.
    ///
    /// > Note:
    /// >
    /// > If no tempo event is found, the Standard MIDI File 1.0 spec specifies that 120 bpm is the default that should be used.
    public var initialTempo: MIDIFileTrackEvent.MusicalTempo? {
        for event in events {
            if case let .tempo(anyTempo) = event.event,
               case let .musical(tempo) = anyTempo
            {
                return tempo
            }
        }
        
        return nil
    }
}
