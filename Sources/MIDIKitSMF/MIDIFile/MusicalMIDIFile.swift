//
//  MusicalMIDIFile.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// MIDI file with musical timebase.
public typealias MusicalMIDIFile = MIDIFile<MusicalMIDIFileTimebase>

extension MusicalMIDIFile {
    /// Returns the first tempo event found in the MIDI file's tracks.
    ///
    /// > Note:
    /// >
    /// > If no tempo event is found, the Standard MIDI File 1.0 spec specifies that 120 bpm is the default that should be used.
    public var initialTempo: MIDIFileTrackEvent.MusicalTempo? {
        for track in tracks {
            if let tempo = track.initialTempo {
                return tempo
            }
        }
        
        return nil
    }
}
