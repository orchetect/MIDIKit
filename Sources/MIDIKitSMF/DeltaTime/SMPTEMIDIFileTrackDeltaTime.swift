//
//  SMPTEMIDIFileTrackDeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore

/// Delta time values appropriate for SMPTE timecode timebase MIDI file tracks (SMF1).
public enum SMPTEMIDIFileTrackDeltaTime {
    /// Construct delta time duration from frame count.
    case frames(_ frames: Double)
    
    /// Construct delta time duration from SMPTE timecode.
    case offset(_ smpteOffset: MIDIFileTrackEvent.SMPTEOffset)
    
    case ticks(_ ticks: UInt32)
}

extension SMPTEMIDIFileTrackDeltaTime: Equatable {
    // Note that using the `isEqual(to:using)` method is available in the `MIDIFileTrackDeltaTime`
    // protocol default implementation and is a better mechanism for testing equality between instances.
}

extension SMPTEMIDIFileTrackDeltaTime: Hashable { }

extension SMPTEMIDIFileTrackDeltaTime: Sendable { }

extension SMPTEMIDIFileTrackDeltaTime: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .frames(frames):
            "\(frames) Frames"
        case let .offset(smpteOffset):
            smpteOffset.description
        case let .ticks(ticks):
            "\(ticks) Ticks"
        }
    }
}

extension SMPTEMIDIFileTrackDeltaTime: MIDIFileTrackDeltaTime {
    public typealias Timebase = SMPTEMIDIFileTimebase
    
    public func ticks(using timebase: Timebase) -> UInt32 {
        switch self {
        case let .frames(frames):
            let ticks = frames * Double(timebase.ticksPerFrame)
            return UInt32(ticks)
            
        case let .offset(smpteOffset):
            let frames = smpteOffset.timecode.frameCount.doubleValue
            let ticks = frames * Double(timebase.ticksPerFrame)
            return UInt32(ticks)
            
        case let .ticks(ticks):
            return ticks
        }
    }
}

// MARK: - Static Constructors

extension SMPTEMIDIFileTrackDeltaTime {
    /// Construct delta time duration from SMPTE timecode.
    /// The frame rate should match the value specified in the MIDI file header.
    public static func offset(
        hr: UInt8,
        min: UInt8,
        sec: UInt8,
        fr: UInt8,
        subFr: UInt8 = 0,
        rate: MIDI1FileFrameRate
    ) -> Self {
        let smpteOffset = MIDIFileTrackEvent.SMPTEOffset(
            hr: hr,
            min: min,
            sec: sec,
            fr: fr,
            subFr: subFr,
            rate: rate
        )
        return .offset(smpteOffset)
    }
    
    /// Construct delta time duration from frame count.
    @_disfavoredOverload
    public static func frames(_ frames: some FixedWidthInteger) -> Self {
        .frames(Double(frames))
    }
}

// MARK: - Methods

extension SMPTEMIDIFileTrackDeltaTime {
    /// Returns the frame count of the delta time using the specified timebase.
    public func frames(using timebase: Timebase) -> Double {
        let tpf = timebase.ticksPerFrame
        guard tpf > 0 else { return 0.0 } // prevent division by zero
        return Double(ticks(using: timebase)) / Double(tpf)
    }
    
    /// Returns the SMPTE timecode duration of the delta time using the specified timebase.
    public func timecodeInterval(using timebase: Timebase) -> TimecodeInterval {
        let frames = frames(using: timebase)
        let frameRate = timebase.frameRate.timecodeRate
        do {
            let tc = try Timecode(.frames(.combined(frames: frames)), at: frameRate)
            return TimecodeInterval(tc)
        } catch {
            assertionFailure("Failed to form timecode from MIDI file delta time.")
            let tc = Timecode(.zero, at:  frameRate)
            return TimecodeInterval(tc)
        }
    }
}
