//
//  DeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile.TrackChunk {
    /// Delta time advancement within a MIDI file track.
    public struct DeltaTime {
        /// Raw delta time in ticks.
        /// The actual duration is calculated using the MIDI file's timebase and division (musical or timecode).
        public var ticks: UInt32
        
        public init(ticks: UInt32 = 0) {
            self.ticks = ticks
        }
    }
}

extension MIDIFile.TrackChunk.DeltaTime: Equatable { }

extension MIDIFile.TrackChunk.DeltaTime: Hashable { }

extension MIDIFile.TrackChunk.DeltaTime: Sendable { }

// MARK: - ExpressibleByIntegerLiteral

extension MIDIFile.TrackChunk.DeltaTime: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = UInt32
    
    public init(integerLiteral value: UInt32) {
        self.init(ticks: value)
    }
}

// MARK: - CustomStringConvertible

extension MIDIFile.TrackChunk.DeltaTime: CustomStringConvertible {
    public var description: String {
        "\(ticks) Ticks"
    }
}

extension MIDIFile.TrackChunk.DeltaTime: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DeltaTime(" + description + ")"
    }
}

// MARK: - Static Constructors

extension MIDIFile.TrackChunk.DeltaTime {
    /// Construct zero delta time.
    public static var none: Self { Self(ticks: 0) }
    
    /// Construct delta time by specifying a raw ticks value.
    /// The actual duration is calculated using the MIDI file's timebase and division (musical or timecode) as defined in the MIDI file header.
    public static func ticks(_ ticks: UInt32) -> Self { Self(ticks: ticks) }
}
