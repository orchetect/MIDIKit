//
//  AnyMIDIFileDeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Type-erased box containing a specialized instance of delta time in a MIDI file track (SMF1) or clip (SMF2).
public enum AnyMIDIFileDeltaTime {
    case musical(_ delta: MusicalMIDIFileDeltaTime)
    case smpte(_ delta: SMPTEMIDIFileDeltaTime)
}

extension AnyMIDIFileDeltaTime: Equatable {
    // Note that using the `isEqual(to:using)` method is available in the `MIDIFileDeltaTime`
    // protocol default implementation and is a better mechanism for testing equality between instances.
}

extension AnyMIDIFileDeltaTime: Hashable { }

extension AnyMIDIFileDeltaTime: Sendable { }

extension AnyMIDIFileDeltaTime: CustomStringConvertible {
    public var description: String {
        wrapped.description
    }
}

extension AnyMIDIFileDeltaTime: CustomDebugStringConvertible {
    public var debugDescription: String {
        wrapped.debugDescription
    }
}

// MARK: - Properties

extension AnyMIDIFileDeltaTime {
    /// Unwraps the enum case and returns the delta time contained within, typed as `any` ``MIDIFileDeltaTime``.
    public var wrapped: any MIDIFileDeltaTime {
        switch self {
        case let .musical(delta): delta
        case let .smpte(delta): delta
        }
    }
}

// MARK: - MIDIFileDeltaTime

extension AnyMIDIFileDeltaTime: MIDIFileDeltaTime {
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
    
    public static func ticks(_ ticks: UInt32) -> AnyMIDIFileDeltaTime {
        // just default to musical timebase as it's by far the most common
        // TODO: this is a bit wonky but our hands are kind of tied with all the type erasure
        .musical(.ticks(ticks))
    }
}
