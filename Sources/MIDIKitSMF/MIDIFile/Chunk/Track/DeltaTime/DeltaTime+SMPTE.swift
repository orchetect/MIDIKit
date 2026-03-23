//
//  DeltaTime+SMPTE.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

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
        frRate: MIDIFileFrameRate,
        ticksPerFrame: UInt8
    ) -> Self {
        let smpteOffset = MIDIFileTrackEvent.SMPTEOffset(
            hr: hr,
            min: min,
            sec: sec,
            fr: fr,
            subFr: subFr,
            frRate: frRate
        )
        return .offset(smpteOffset, ticksPerFrame: ticksPerFrame)
    }
}
