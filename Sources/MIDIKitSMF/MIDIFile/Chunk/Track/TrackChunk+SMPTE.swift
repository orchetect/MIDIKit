//
//  TrackChunk+SMPTE.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore

// MARK: - Methods

extension MIDIFile.TrackChunk where Timebase == SMPTEMIDIFileTimebase {
    /// Returns ``events`` mapped to their SMPTE timecode locations.
    /// Ensure the frame rate and `ticksPerFrame` value are the same values specified in the MIDI file header.
    ///
    /// This is computed each time this method is called, so avoid repeated calls to this method where possible.
    public func eventsAtTimecodeLocations(
        frameRate: MIDIFileFrameRate,
        ticksPerFrame: UInt8,
        origin originOverride: Timecode? = nil
    ) -> [(timecode: Timecode, event: Event)] {
        // determine origin timecode for the track
        // if a SMPTE offset event appears at time==0 in the track, use it
        // but could be overridden by a `originTimecode: Timecode` parameter to this method to force an origin offset
        let origin: Timecode = if let originOverride { originOverride } else {
            if let origin,
               let originConvertedIfNeeded = try? origin.converted(to: frameRate.timecodeRate)
            {
                originConvertedIfNeeded
            } else {
                Timecode(.zero, at: frameRate.timecodeRate)
            }
        }
        
        var position: Timecode = origin
        return events.map {
            let interval = $0.delta
                .timecodeInterval(frameRate: frameRate, ticksPerFrame: ticksPerFrame)
            position = position.offsetting(by: interval)
            return (timecode: position, event: $0)
        }
    }
}
