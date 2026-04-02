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

extension MIDIFileTrackEvent.SMPTETempo {
    // TODO: add specialized init(s)
}

// MARK: - MIDIFileTrackEventPayload Overrides

extension MIDIFileTrackEvent.SMPTETempo: MIDIFileTrackEventPayload {
    public func asMIDIFileTrackEvent() -> MIDIFileTrackEvent {
        .tempo(.smpte(self))
    }
    
    // TODO: add specialized descriptions
    
//    public var smfDescription: String {
//
//    }
//    
//    public var smfDebugDescription: String {
//
//    }
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    // TODO: add specialized constructor(s)
}

extension MIDIFile.TrackChunk.Event where Timebase == SMPTEMIDIFileTimebase {
    // TODO: add specialized constructor(s)
}

// MARK: - Properties

extension MIDIFileTrackEvent.MusicalTempo {
    // TODO: add specialized properties
}

// MARK: - Utilities

extension MIDIFileTrackEvent.MusicalTempo {
    // TODO: add conversion utilities
}
