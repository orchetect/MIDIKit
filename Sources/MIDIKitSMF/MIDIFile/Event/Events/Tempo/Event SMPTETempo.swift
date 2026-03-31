//
//  Event SMPTETempo.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileTrackEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Tempo event for MIDI file tracks using SMPTE timecode timebase.
    /// For a format 1 MIDI file, tempo events should only occur within the first `MTrk` chunk.
    public struct SMPTETempo: Tempo {
        public typealias Timebase = SMPTEMIDIFileTimebase
        
        public var microsecondsPerQuarter: UInt32
        
        public init(microsecondsPerQuarter: UInt32) {
            self.microsecondsPerQuarter = microsecondsPerQuarter
        }
    }
}

// MARK: - Init

extension MIDIFileTrackEvent.SMPTETempo { // TODO: add specialized init(s)
//    /// Tempo event for MIDI file tracks using SMPTE timecode timebase.
//    /// For a format 1 MIDI file, tempo events should only occur within the first `MTrk` chunk.
//    public init(bpm: Double = 120.0) {
//        self.bpm = bpm
//    }
}

// MARK: - MIDIFileTrackEventPayload Overrides

extension MIDIFileTrackEvent.SMPTETempo: MIDIFileTrackEventPayload { // TODO: add specialized descriptions
    public var wrapped: MIDIFileTrackEvent {
        .tempo(.smpte(self))
    }
    
//    public var smfDescription: String {
//        "\(bpm.rounded(decimalPlaces: 3))bpm"
//    }
//    
//    public var smfDebugDescription: String {
//        "Tempo(\(bpm)bpm)"
//    }
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent { // TODO: add specialized constructor(s)
//    /// Tempo event for MIDI file tracks using SMPTE timecode timebase.
//    /// For a format 1 MIDI file, tempo events should only occur within the first `MTrk` chunk.
//    public static func tempo(
//        bpm: Double
//    ) -> Self {
//        .tempo(
//            AnyTempo(SMPTETempo(bpm: bpm))
//        )
//    }
}

extension MIDIFile.TrackChunk.Event where Timebase == SMPTEMIDIFileTimebase { // TODO: add specialized constructor(s)
//    /// Tempo event for MIDI file tracks using SMPTE timecode timebase.
//    /// For a format 1 MIDI file, tempo events should only occur within the first `MTrk` chunk.
//    public static func tempo(
//        delta: DeltaTime = .none,
//        bpm: Double
//    ) -> Self {
//        let event: MIDIFileTrackEvent = .tempo(
//            bpm: bpm
//        )
//        return Self(delta: delta, event: event)
//    }
}

// MARK: - Properties

extension MIDIFileTrackEvent.MusicalTempo { // TODO: add specialized property(ies)
//    /// Musical tempo.
//    /// Defaults to 120 bpm. Minimum possible is 3.58 bpm and maximum is 60,000,000 bpm.
//    public var bpm: Double {
//        get {
//            Self.microsecondsToBPM(ms: microsecondsPerQuarter)
//        }
//        set {
//            let validated = validate(bpm: newValue)
//            microsecondsPerQuarter = Self.bpmToMicroseconds(bpm: validated)
//        }
//    }
}

// MARK: - Utilities

extension MIDIFileTrackEvent.MusicalTempo {
    // TODO: add conversion utilities
}
