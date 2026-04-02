//
//  MIDIFileTrackDeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Delta time within a MIDI file track (SMF1) or clip (SMF2).
public protocol MIDIFileTrackDeltaTime<Timebase>: Equatable, Hashable, Sendable,
    CustomStringConvertible,
    CustomDebugStringConvertible,
    ExpressibleByIntegerLiteral where IntegerLiteralType == UInt32,
    Timebase.DeltaTime == Self
{
    associatedtype Timebase: MIDIFileTimebase
    
    // MARK: Standard Static Constructors
    
    /// Construct zero delta time.
    static var none: Self { get }
    
    /// Construct delta time by specifying a raw ticks value.
    /// The actual duration is calculated using the MIDI file's timebase and division (musical or timecode) as defined in the MIDI file header.
    static func ticks(_ ticks: UInt32) -> Self
    
    // MARK: Methods
    
    /// Returns the raw delta time in ticks.
    /// The actual duration is later calculated using the timebase specified in the MIDI file's header.
    func ticks(using timebase: Timebase) -> UInt32
    
    /// Compares two delta time instances and returns `true` if the ticks value is identical.
    func isEqual(to other: Self, using timebase: Timebase) -> Bool
}

// MARK: - ExpressibleByIntegerLiteral Default Implementation

extension MIDIFileTrackDeltaTime/* : ExpressibleByIntegerLiteral */ {
    public init(integerLiteral value: UInt32) {
        self = .ticks(value)
    }
}

// MARK: - CustomDebugStringConvertible Default Implementation

extension MIDIFileTrackDeltaTime/* : CustomDebugStringConvertible */ {
    public var debugDescription: String {
        "DeltaTime(" + description + ")"
    }
}

// MARK: - Static Constructors Default Implementation

extension MIDIFileTrackDeltaTime {
    /// Construct zero delta time.
    public static var none: Self { .ticks(0) }
}

// MARK: - Methods Default Implementation

extension MIDIFileTrackDeltaTime {
    public func isEqual(to other: Self, using timebase: Timebase) -> Bool {
        ticks(using: timebase) == other.ticks(using: timebase)
    }
}
