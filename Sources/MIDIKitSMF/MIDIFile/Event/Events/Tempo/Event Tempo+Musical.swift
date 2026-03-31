//
//  Event Tempo+Musical.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Tempo event for MIDI file tracks using musical timebase.
    /// For a format 1 MIDI file, tempo events should only occur within the first `MTrk` chunk.
    /// If there are no tempo events in a MIDI file, 120 bpm is assumed.
    public struct MusicalTempo: Tempo {
        public typealias Timebase = MusicalMIDIFileTimebase
        
        public var microsecondsPerQuarter: UInt32
        
        public init(microsecondsPerQuarter: UInt32) {
            self.microsecondsPerQuarter = microsecondsPerQuarter
        }
    }
}

// MARK: - Init

extension MIDIFileTrackEvent.MusicalTempo {
    /// Tempo event for MIDI file tracks using musical timebase.
    /// Minimum possible is 3.58 bpm and maximum is 60,000,000 bpm.
    public init(bpm: Double = 120.0) {
        self.init(microsecondsPerQuarter: 0)
        self.bpm = bpm // validate and set value
    }
}

// MARK: - MIDIFileTrackEventPayload Overrides

extension MIDIFileTrackEvent.MusicalTempo: MIDIFileTrackEventPayload {
    public var wrapped: MIDIFileTrackEvent {
        .tempo(.musical(self))
    }
    
    public var smfDescription: String {
        "\(bpm.rounded(decimalPlaces: 3))bpm"
    }
    
    public var smfDebugDescription: String {
        "Tempo(\(bpm)bpm)"
    }
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// Tempo event for MIDI file tracks using musical timebase.
    /// For a format 1 MIDI file, tempo events should only occur within the first `MTrk` chunk.
    /// Minimum possible is 3.58 bpm and maximum is 60,000,000 bpm.
    public static func tempo(
        bpm: Double
    ) -> Self {
        .tempo(
            AnyTempo(MusicalTempo(bpm: bpm))
        )
    }
}

extension MIDIFile.TrackChunk.Event where Timebase == MusicalMIDIFileTimebase {
    /// Tempo event for MIDI file tracks using musical timebase.
    /// For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.
    /// Minimum possible is 3.58 bpm and maximum is 60,000,000 bpm.
    public static func tempo(
        delta: DeltaTime = .none,
        bpm: Double
    ) -> Self {
        let event: MIDIFileTrackEvent = .tempo(
            bpm: bpm
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Properties

extension MIDIFileTrackEvent.MusicalTempo {
    /// Musical tempo in bmp (beats per minute).
    /// Minimum possible is 3.58 bpm and maximum is 60,000,000 bpm.
    public var bpm: Double {
        get {
            Self.microsecondsToBPM(ms: microsecondsPerQuarter)
        }
        set {
            let validated = Self.validate(bpm: newValue)
            microsecondsPerQuarter = Self.bpmToMicroseconds(bpm: validated)
        }
    }
}

// MARK: - Utilities

extension MIDIFileTrackEvent.MusicalTempo {
    private static func bpmToMicroseconds(bpm fromTempo: Double) -> UInt32 {
        let tempoCalc: Double = (60 / fromTempo) * 1_000_000
        return UInt32(tempoCalc)
    }
    
    private static func microsecondsToBPM(ms fromMicroseconds: UInt32) -> Double {
        (60 * 1_000_000) / Double(fromMicroseconds)
    }
    
    static func validate(bpm: Double) -> Double {
        bpm.clamped(to: 3.58 ... 60_000_000.0)
    }
}
