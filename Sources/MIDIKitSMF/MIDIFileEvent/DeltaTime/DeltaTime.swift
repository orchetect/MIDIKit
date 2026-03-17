//
//  DeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - DeltaTime

extension MIDIFileEvent {
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

extension MIDIFileEvent.DeltaTime: Equatable { }

extension MIDIFileEvent.DeltaTime: Hashable { }

extension MIDIFileEvent.DeltaTime: Sendable { }

extension MIDIFileEvent.DeltaTime {
    /// Construct zero delta time.
    public static let none = Self(ticks: 0)
    
    /// Construct delta time by specifying a raw ticks value.
    /// The actual duration is calculated using the MIDI file's timebase and division (musical or timecode) as defined in the MIDI file header.
    public static func ticks(_ ticks: UInt32) -> Self { Self(ticks: ticks) }
    
    /// Construct delta time duration of a whole note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func noteWhole(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) * 4) }
    
    /// Construct delta time duration of a half note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func noteHalf(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) * 2) }
    
    /// Construct delta time duration of a quarter note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func noteQuarter(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq)) }
    
    /// Construct delta time duration of a 8th note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func note8th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 2) }
    
    /// Construct delta time duration of a 16th note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func note16th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 4) }
    
    /// Construct delta time duration of a 32nd note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func note32nd(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 8) }
    
    /// Construct delta time duration of a 64th note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func note64th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 16) }
    
    /// Construct delta time duration of a 128th note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func note128th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 32) }
    
    /// Construct delta time duration of a 256th note.
    /// (Applicable only for a MIDI file using musical timebase.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.)
    public static func note256th(ppq: UInt16) -> Self { Self(ticks: UInt32(ppq) / 64) }
    
    // TODO: Could add other convnience calculations
    // public static func seconds(TimeInterval)
    // public static func milliseconds(Double)
}

// MARK: - ExpressibleByIntegerLiteral

extension MIDIFileEvent.DeltaTime: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = UInt32
    
    public init(integerLiteral value: UInt32) {
        self.init(ticks: value)
    }
}

// MARK: - CustomStringConvertible

extension MIDIFileEvent.DeltaTime: CustomStringConvertible {
    public var description: String {
        "\(ticks) Ticks"
    }
}

extension MIDIFileEvent.DeltaTime: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DeltaTime(" + description + ")"
    }
}

// MARK: - Methods

extension MIDIFileEvent.DeltaTime {
    /// Returns the real time (wall clock) duration in seconds of the delta time using the specified timebase.
    /// Ensure the `ppq` (ticks per quarter note) supplied is the same as used in the MIDI file.
    public func timeInterval(ppq: UInt16) -> TimeInterval {
        guard ppq > 0 else { return 0.0 }
        return Double(ticks) / Double(ppq)
    }
}
