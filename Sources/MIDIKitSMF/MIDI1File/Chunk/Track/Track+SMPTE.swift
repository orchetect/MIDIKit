//
//  Track+SMPTE.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore

// MARK: - Methods

extension MIDI1File.Track where Timebase == SMPTEMIDIFileTimebase {
    /// Returns ``events`` mapped to their SMPTE timecode locations.
    /// Ensure the frame rate and `ticksPerFrame` value are the same values specified in the MIDI file header.
    /// 
    /// This is computed each time this method is called, so avoid repeated calls to this method where possible.
    ///
    /// - Parameters:
    ///   - timebase: The timebase used in the MIDI file header.
    ///   - originOverride: By default (passing `nil`), if a SMPTE offset event appears at the start of the
    ///     track (`delta == 0`) it will be used as the origin timecode, otherwise zero (00:00:00:00) if it is
    ///     not present. If this parameter is non-`nil`, the passed value will override any SMPTE offset event
    ///     that may be present at the start of the track.
    public func eventsAtTimecodeLocations(
        using timebase: Timebase,
        origin originOverride: Timecode? = nil
    ) -> [(timecode: Timecode, event: MIDIFileEvent)] {
        // determine origin timecode for the track
        // if a SMPTE offset event appears at time==0 in the track, use it
        // but could be overridden by a `originTimecode: Timecode` parameter to this method to force an origin offset
        let origin: Timecode = if let originOverride { originOverride } else {
            if let origin = initialSMPTEOffset,
               let originConvertedIfNeeded = try? origin.converted(to: timebase.frameRate.timecodeRate)
            {
                originConvertedIfNeeded
            } else {
                Timecode(.zero, at: timebase.frameRate.timecodeRate)
            }
        }
        
        var position: Timecode = origin
        return events.map {
            let interval = $0.delta
                .timecodeInterval(using: timebase)
            position = position.offsetting(by: interval)
            return (timecode: position, event: $0.event)
        }
    }
}
