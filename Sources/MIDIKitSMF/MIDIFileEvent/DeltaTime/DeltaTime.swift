//
//  DeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Darwin
import MIDIKitCore

// MARK: - DeltaTime

extension MIDIFileEvent {
    /// Delta time advancement.
    public enum DeltaTime {
        case none

        case ticks(UInt32)

        // TODO: Could add milliseconds calculation
        // case seconds(TimeInterval)
        // case milliseconds(Double)

        case wholeNote
        case halfNote
        case quarterNote
        case _8thNote
        case _16thNote
        case _32ndNote
        case _64thNote
        case _128thNote
        case _256thNote
    }
}

extension MIDIFileEvent.DeltaTime {
    public init?(
        ticks: UInt32,
        using timeBase: MIDIFile.TimeBase
    ) {
        // TODO: add init here that sets self = a certain enum case based on provided ticks and provided timebase
        
        self = .ticks(ticks)
    }
}

// MARK: - Equatable

extension MIDIFileEvent.DeltaTime: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        let timeBase = MIDIFile.TimeBase.musical(ticksPerQuarterNote: 960)

        return lhs.ticksValue(using: timeBase) == rhs.ticksValue(using: timeBase)
    }
}

extension MIDIFileEvent.DeltaTime: Hashable {
    // synthesized
}

// MARK: - CustomStringConvertible

extension MIDIFileEvent.DeltaTime: CustomStringConvertible,
CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .none:             return "none"
        case let .ticks(ticks): return "ticks:\(ticks)"
        case .wholeNote:        return "wholeNote"
        case .halfNote:         return "halfNote"
        case .quarterNote:      return "quarterNote"
        case ._8thNote:         return "8thNote"
        case ._16thNote:        return "16thNote"
        case ._32ndNote:        return "32ndNote"
        case ._64thNote:        return "64thNote"
        case ._128thNote:       return "128thNote"
        case ._256thNote:       return "256thNote"
        }
    }

    public var debugDescription: String {
        "DeltaTime(" + description + ")"
    }
}

// MARK: - ticksValue

extension MIDIFileEvent.DeltaTime {
    public func ticksValue(using timeBase: MIDIFile.TimeBase) -> UInt32 {
        let midiFileTicksPerQuarter: UInt32

        switch timeBase {
        case let .musical(ticksPerQuarterNote):
            midiFileTicksPerQuarter = UInt32(ticksPerQuarterNote)

        case let .timecode(smpteFormat, ticksPerFrame):
            _ = smpteFormat
            _ = ticksPerFrame
            fatalError("Timecode timebase not implemented yet.")
        }

        switch self {
        case .none:
            return 0

        case let .ticks(val):
            return val

        case .wholeNote:
            return midiFileTicksPerQuarter * 4  // 2^5

        case .halfNote:
            return midiFileTicksPerQuarter * 2  // 2^1

        case .quarterNote:
            return midiFileTicksPerQuarter      // 2^0

        case ._8thNote:
            return midiFileTicksPerQuarter / 2  // 2^1

        case ._16thNote:
            return midiFileTicksPerQuarter / 4  // 2^2

        case ._32ndNote:
            return midiFileTicksPerQuarter / 8  // 2^3

        case ._64thNote:
            return midiFileTicksPerQuarter / 16 // 2^4

        case ._128thNote:
            return midiFileTicksPerQuarter / 32 // 2^5

        case ._256thNote:
            return midiFileTicksPerQuarter / 64 // 2^6
        }
    }
}
