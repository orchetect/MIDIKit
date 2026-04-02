//
//  Event AnyTempo.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - AnyTempo

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileTrackEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileTrackEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Type-erased box for a tempo event specialized to a concrete MIDI file timebase.
    /// For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.
    /// If there are no tempo events in a MIDI file, 120 bpm is assumed.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > This value is encoded as microseconds per MIDI quarter-note.
    /// >
    /// > Another way of putting "microseconds per quarter-note" is "24ths of a microsecond per MIDI clock".
    /// > Representing tempos as time per beat instead of beat per time allows absolutely exact long-term
    /// > synchronization with a time-based sync protocol such as SMPTE timecode or MIDI timecode.
    public enum AnyTempo {
        case musical(_ tempo: MusicalTempo)
        case smpte(_ tempo: SMPTETempo)
    }
}

extension MIDIFileTrackEvent.AnyTempo: Equatable { }

extension MIDIFileTrackEvent.AnyTempo: Hashable { }

extension MIDIFileTrackEvent.AnyTempo: Sendable { }

// MARK: - Init

extension MIDIFileTrackEvent.AnyTempo {
    public init(_ tempo: MIDIFileTrackEvent.MusicalTempo) {
        self = .musical(tempo)
    }
    
    public init(_ tempo: MIDIFileTrackEvent.SMPTETempo) {
        self = .smpte(tempo)
    }
}

// MARK: - Static Constructors

// static constructors are defined in each Tempo+timebase file

// MARK: - Tempo

extension MIDIFileTrackEvent.AnyTempo: MIDIFileTrackEvent.Tempo {
    public typealias Timebase = AnyMIDIFileTimebase
    
    public var microsecondsPerQuarter: UInt32 {
        get {
            switch self {
            case let .musical(tempo): tempo.microsecondsPerQuarter
            case let .smpte(tempo): tempo.microsecondsPerQuarter
            }
        }
        set {
            switch self {
            case var .musical(tempo):
                tempo.microsecondsPerQuarter = newValue
                self = .musical(tempo)
            case var .smpte(tempo):
                tempo.microsecondsPerQuarter = newValue
                self = .smpte(tempo)
            }
        }
    }
    
    public init(microsecondsPerQuarter: UInt32) {
        // just default to musical timebase as it's by far the most common
        // TODO: this is a bit wonky but our hands are kind of tied with all the type erasure
        self = .musical(.init(microsecondsPerQuarter: microsecondsPerQuarter))
    }
}

// MARK: - MIDIFileTrackEventPayload

extension MIDIFileTrackEvent.AnyTempo: MIDIFileTrackEventPayload {
    public func asMIDIFileTrackEvent() -> MIDIFileTrackEvent {
        .tempo(self)
    }
}

// MARK: - Properties

extension MIDIFileTrackEvent.AnyTempo {
    /// Unwraps the enum case and returns the chunk contained within, typed as ``MIDIFileTrackEvent.Tempo`` protocol.
    public var wrapped: any MIDIFileTrackEvent.Tempo {
        switch self {
        case let .musical(tempo): tempo
        case let .smpte(tempo): tempo
        }
    }
}
