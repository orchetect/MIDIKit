//
//  DeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
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

        case noteWhole
        case noteHalf
        case noteQuarter
        case note8th
        case note16th
        case note32nd
        case note64th
        case note128th
        case note256th
    }
}

extension MIDIFileEvent.DeltaTime: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        let timeBase = MIDIFile.TimeBase.musical(ticksPerQuarterNote: 960)

        return lhs.ticksValue(using: timeBase) == rhs.ticksValue(using: timeBase)
    }
}

extension MIDIFileEvent.DeltaTime: Hashable {
    // synthesized
}

extension MIDIFileEvent.DeltaTime: Sendable { }

// MARK: - CustomStringConvertible

extension MIDIFileEvent.DeltaTime: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:             return "none"
        case let .ticks(ticks): return "ticks:\(ticks)"
        case .noteWhole:        return "whole note"
        case .noteHalf:         return "half note"
        case .noteQuarter:      return "quarter note"
        case .note8th:          return "8th note"
        case .note16th:         return "16th note"
        case .note32nd:         return "32nd note"
        case .note64th:         return "64th note"
        case .note128th:        return "128th note"
        case .note256th:        return "256th note"
        }
    }
}

extension MIDIFileEvent.DeltaTime: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DeltaTime(" + description + ")"
    }
}

// MARK: - Init

extension MIDIFileEvent.DeltaTime {
    public init?(
        ticks: UInt32,
        using timeBase: MIDIFile.TimeBase
    ) {
        // TODO: add init here that sets self = a certain enum case based on provided ticks and provided timebase
        
        self = .ticks(ticks)
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

        case .noteWhole:
            return midiFileTicksPerQuarter * 4  // 2^5

        case .noteHalf:
            return midiFileTicksPerQuarter * 2  // 2^1

        case .noteQuarter:
            return midiFileTicksPerQuarter      // 2^0

        case .note8th:
            return midiFileTicksPerQuarter / 2  // 2^1

        case .note16th:
            return midiFileTicksPerQuarter / 4  // 2^2

        case .note32nd:
            return midiFileTicksPerQuarter / 8  // 2^3

        case .note64th:
            return midiFileTicksPerQuarter / 16 // 2^4

        case .note128th:
            return midiFileTicksPerQuarter / 32 // 2^5

        case .note256th:
            return midiFileTicksPerQuarter / 64 // 2^6
        }
    }
}
