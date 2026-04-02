//
//  AnyMIDIFileTrackDeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Type-erased box containing a specialized instance of delta time in a MIDI file track (SMF1) or clip (SMF2).
public enum AnyMIDIFileTrackDeltaTime {
    case musical(_ delta: MusicalMIDIFileTrackDeltaTime)
    case smpte(_ delta: SMPTEMIDIFileTrackDeltaTime)
}

extension AnyMIDIFileTrackDeltaTime: Equatable {
    // Note that using the `isEqual(to:using)` method is available in the `MIDIFileTrackDeltaTime`
    // protocol default implementation and is a better mechanism for testing equality between instances.
}

extension AnyMIDIFileTrackDeltaTime: Hashable { }

extension AnyMIDIFileTrackDeltaTime: Sendable { }

extension AnyMIDIFileTrackDeltaTime: CustomStringConvertible {
    public var description: String {
        wrapped.description
    }
}

extension AnyMIDIFileTrackDeltaTime: CustomDebugStringConvertible {
    public var debugDescription: String {
        wrapped.debugDescription
    }
}

// MARK: - Properties

extension AnyMIDIFileTrackDeltaTime {
    /// Unwraps the enum case and returns the delta time contained within, typed as `any` ``MIDIFileTrackDeltaTime``.
    public var wrapped: any MIDIFileTrackDeltaTime {
        switch self {
        case let .musical(delta): delta
        case let .smpte(delta): delta
        }
    }
}

// MARK: - MIDIFileTrackDeltaTime

extension AnyMIDIFileTrackDeltaTime: MIDIFileTrackDeltaTime {
    public typealias Timebase = AnyMIDIFileTimebase
    
    public func ticks(using timebase: Timebase) -> UInt32 {
        // TODO: this is a bit wonky but our hands are kind of tied with all the type erasure
        switch (self, timebase) {
        case let (.musical(delta), .musical(timebase)):
            delta.ticks(using: timebase)
        case let (.smpte(delta), .smpte(timebase)):
            delta.ticks(using: timebase)
        default:
            0
        }
    }
    
    public static func ticks(_ ticks: UInt32) -> AnyMIDIFileTrackDeltaTime {
        // just default to musical timebase as it's by far the most common
        // TODO: this is a bit wonky but our hands are kind of tied with all the type erasure
        .musical(.ticks(ticks))
    }
}
