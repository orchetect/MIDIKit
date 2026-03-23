//
//  DeltaTime+SMPTE.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore

// MARK: - Static Constructors

extension MIDIFile.TrackChunk.DeltaTime where Timebase == SMPTEMIDIFileTimebase {
    /// Construct delta time duration from SMPTE timecode.
    /// The `offset` frame rate and `ticksPerFrame` should match the values specified in the MIDI file header.
    public static func offset(_ offset: MIDIFileTrackEvent.SMPTEOffset, ticksPerFrame: UInt8) -> Self {
        let frameCount = offset.timecode.frameCount
        let ticks = frameCount.doubleValue * Double(ticksPerFrame)
        return Self(ticks: UInt32(ticks))
    }
    
    /// Construct delta time duration from SMPTE timecode.
    /// The `offset` frame rate and `ticksPerFrame` should match the values specified in the MIDI file header.
    public static func offset(
        hr: UInt8,
        min: UInt8,
        sec: UInt8,
        fr: UInt8,
        subFr: UInt8 = 0,
        rate: MIDIFileFrameRate,
        ticksPerFrame: UInt8
    ) -> Self {
        let smpteOffset = MIDIFileTrackEvent.SMPTEOffset(
            hr: hr,
            min: min,
            sec: sec,
            fr: fr,
            subFr: subFr,
            rate: rate
        )
        return .offset(smpteOffset, ticksPerFrame: ticksPerFrame)
    }
}

// MARK: - Methods

extension MIDIFile.TrackChunk.DeltaTime where Timebase == SMPTEMIDIFileTimebase {
    /// Returns the SMPTE timecode duration of the delta time using the specified timebase.
    /// Ensure the frame rate and `ticksPerFrame` value are the same values specified in the MIDI file header.
    public func timecodeInterval(
        frameRate: MIDIFileFrameRate,
        ticksPerFrame: UInt8
    ) -> TimecodeInterval {
        let frames = Double(ticks) / Double(ticksPerFrame)
        do {
            let tc = try Timecode(.frames(.combined(frames: frames)), at: frameRate.timecodeRate)
            return TimecodeInterval(tc)
        } catch {
            assertionFailure("Failed to form timecode from MIDI file delta time.")
            let tc = Timecode(.zero, at: frameRate.timecodeRate)
            return TimecodeInterval(tc)
        }
    }
}
