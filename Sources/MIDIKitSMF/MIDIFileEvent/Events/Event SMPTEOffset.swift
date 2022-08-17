//
//  Event SMPTEOffset.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore
import TimecodeKit

// MARK: - SMPTEOffset

extension MIDIFileEvent {
    /// Specify the SMPTE time at which the track is to start.
    /// This optional event, if present, should occur at the start of a track,
    /// at time == 0, and prior to any MIDI events.
    /// Defaults to 00:00:00:00 @ 24fps.
    ///
    /// - remark: Standard MIDI File Spec 1.0:
    ///
    /// MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in SMPTE- based tracks which specify a different frame subdivision for delta-times.
    public struct SMPTEOffset: Equatable, Hashable {
        /// Timecode hour.
        /// Valid range: 0-23.
        public var hours: UInt8 = 0 {
            didSet {
                if oldValue != hours { hours_Validate() }
            }
        }
        
        private mutating func hours_Validate() {
            hours = hours.clamped(to: 0 ... 23)
        }
        
        /// Timecode minutes.
        /// Valid range: 0-59.
        public var minutes: UInt8 = 0 {
            didSet {
                if oldValue != minutes { minutes_Validate() }
            }
        }
        
        private mutating func minutes_Validate() {
            minutes = minutes.clamped(to: 0 ... 59)
        }
        
        /// Timecode seconds.
        /// Valid range: 0-59.
        public var seconds: UInt8 = 0 {
            didSet {
                if oldValue != seconds { seconds_Validate() }
            }
        }
        
        private mutating func seconds_Validate() {
            seconds = seconds.clamped(to: 0 ... 59)
        }
        
        /// Timecode frames.
        /// Valid range is dependent on the `frameRate` property (0-23 for 24fps, 0-29 for 30fps, etc.).
        public var frames: UInt8 = 0 {
            didSet {
                if oldValue != frames { frames_Validate() }
            }
        }
        
        private mutating func frames_Validate() {
            switch frameRate {
            case ._24fps: frames = frames.clamped(to: 0 ... 23)
            case ._25fps: frames = frames.clamped(to: 0 ... 25)
            case ._30fps, ._2997dfps: frames = frames.clamped(to: 0 ... 29)
            }
        }
        
        /// Timecode subframes.
        /// Valid range: 0-99.
        /// The number of fractional frames, in 100ths of a frame (even in SMPTE-based tracks using a different frame subdivision, defined in the MThd MIDI file header chunk).
        public var subframes: UInt8 = 0 {
            didSet {
                if oldValue != subframes { subframes_Validate() }
            }
        }
        
        private mutating func subframes_Validate() {
            subframes = subframes.clamped(to: 0 ... 99)
        }
        
        public var frameRate: MIDIFile.SMPTEOffsetFrameRate = ._30fps
        
        /// Returns a `Timecode` struct using values contains in `self`.
        public var components: Timecode.Components {
            TCC(
                h: hours.int,
                m: minutes.int,
                s: seconds.int,
                f: frames.int,
                sf: subframes.int
            )
        }
        
        /// Returns a `Timecode` struct using values contains in `self`.
        public var timecode: Timecode {
            components.toTimecode(
                rawValuesAt: frameRate.timecodeRate,
                base: ._100SubFrames
            )
        }
        
        // MARK: - Init
        
        init() { }
        
        init(
            hr: UInt8,
            min: UInt8,
            sec: UInt8,
            fr: UInt8,
            subFr: UInt8 = 0,
            frRate: MIDIFile.SMPTEOffsetFrameRate = ._30fps
        ) {
            frameRate = frRate // enum, no validation needed
            
            hours = hr; hours_Validate()
            minutes = min; minutes_Validate()
            seconds = sec; seconds_Validate()
            frames = fr; frames_Validate()
            subframes = subFr; subframes_Validate()
        }
        
        init(scaling timecode: Timecode) {
            let smpteTCAndRate = timecode.scaledToMIDIFileSMPTEFrameRate
            
            let smpteTC = smpteTCAndRate.scaledTimecode
                ?? Timecode(at: timecode.frameRate) // 00:00:00:00 default
            
            frameRate = smpteTCAndRate.smpteFR
            
            hours = smpteTC.hours.uInt8Exactly ?? 0
            minutes = smpteTC.minutes.uInt8Exactly ?? 0
            seconds = smpteTC.seconds.uInt8Exactly ?? 0
            frames = smpteTC.frames.uInt8Exactly ?? 0
            subframes = smpteTC.subFrames.uInt8Exactly ?? 0
        }
        
        // TODO: add an init from Timecode struct that can convert/scale timecode and subframes to 100 subframe divisor
    }
}

extension MIDIFileEvent.SMPTEOffset: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .smpteOffset
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 3-byte preamble
        guard rawBytes.starts(with: MIDIFile.kEventHeaders[.smpteOffset]!) else {
            throw MIDIFile.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readHoursByte = rawBytes[3]
        let readFrameRateBits = (readHoursByte & 0b1100000) >> 5
        let readHours = readHoursByte & 0b0011111
        
        let readMinutes = rawBytes[4]
        let readSeconds = rawBytes[5]
        let readFrames = rawBytes[6]
        let readSubframes = rawBytes[7]
        
        guard let readFrameRate = MIDIFile.SMPTEOffsetFrameRate(rawValue: readFrameRateBits) else {
            // this should never happen, but trap error any way
            throw MIDIFile.DecodeError.malformed(
                "Could not form frame rate from Hours byte."
            )
        }
        
        guard readHours.isContained(in: 0 ... 23) else {
            throw MIDIFile.DecodeError.malformed(
                "Hours is out of bounds: \(readHours)"
            )
        }
        
        guard readMinutes.isContained(in: 0 ... 59) else {
            throw MIDIFile.DecodeError.malformed(
                "Minutes is out of bounds: \(readMinutes)"
            )
        }
        
        guard readSeconds.isContained(in: 0 ... 59) else {
            throw MIDIFile.DecodeError.malformed(
                "Seconds value is out of bounds: \(readSeconds)"
            )
        }
        
        guard readFrames.isContained(in: 0 ... 30) else {
            throw MIDIFile.DecodeError.malformed(
                "Frames value is out of bounds: \(readFrames)"
            )
        }
        
        guard readSubframes.isContained(in: 0 ... 99) else {
            throw MIDIFile.DecodeError.malformed(
                "Subframes value is out of bounds: \(readSubframes)"
            )
        }
        
        frameRate = readFrameRate
        
        hours = readHours
        minutes = readMinutes
        seconds = readSeconds
        frames = readFrames
        subframes = readSubframes
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // FF 54 05 hr mn se fr ff
        //
        // 05 is length
        //
        // hr is a byte specifying the hour, which is also encoded with the SMPTE format (frame rate), just as it is in MIDI Time Code
        //   8 bits: 0rrhhhhh, where:
        //     rr = frame rate : 00 = 24 fps, 01 = 25 fps, 10 = 30 fps (drop frame), 11 = 30 fps (non-drop frame)
        //     hhhhh = hour (0-23)
        //
        // ff is a byte specifying the number of fractional frames, in 100ths of a frame (even in SMPTE-based tracks using a different frame subdivision, defined in the MThd chunk).
        
        var data: [Byte] = []
        
        data += MIDIFile.kEventHeaders[.smpteOffset]! // start bytes
        data += [(frameRate.rawValue << 5) + hours] // hour & frame rate
        data += [minutes] // minutes
        data += [seconds] // seconds
        data += [frames] // frames
        data += [subframes] // subframes
        
        return data
    }
    
    static let midi1SMFFixedRawBytesLength = 8
    
    public static func initFrom(
        midi1SMFRawBytesStream rawBuffer: Data
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes
        
        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Unexpected byte length."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: requiredData)
        
        return (
            newEvent: newInstance,
            bufferLength: midi1SMFFixedRawBytesLength
        )
    }
    
    public var smfDescription: String {
        let time =
            hours.string(paddedTo: 1) + ":" +
            minutes.string(paddedTo: 2) + ":" +
            seconds.string(paddedTo: 2) + ":" +
            frames.string(paddedTo: 2) + "." +
            subframes.string +
            "@\(frameRate)"
        
        return "smpte: " + time
    }
    
    public var smfDebugDescription: String {
        "SMPTEOffset(" + smfDescription + ")"
    }
}

// MARK: - Helpers

extension Timecode {
    /// Determines the best corresponding MIDI File SMPTE Offset frame rate to represent `self` and converts the timecode to that frame rate, and converts the subframes to be scaled to a 100 subframe divisor if needed.
    ///
    /// - remark: Standard MIDI File Spec 1.0:
    ///
    /// MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in SMPTE- based tracks which specify a different frame subdivision for delta-times.
    public var scaledToMIDIFileSMPTEFrameRate: (
        scaledTimecode: Timecode?,
        smpteFR: MIDIFile.SMPTEOffsetFrameRate
    ) {
        let midiFileSMPTEFrameRate = frameRate.midiFileSMPTEOffsetRate
        
        var scaledTC = try? converted(to: midiFileSMPTEFrameRate.timecodeRate)
        
        // scale subframes if needed
        if scaledTC?.subFramesBase != ._100SubFrames,
           let nonNilscaledTC = scaledTC
        {
            let originalSF = nonNilscaledTC.subFrames.double
            let originalSFD = nonNilscaledTC.subFramesBase.rawValue.double
            
            let scaledSubFrames =
                Int((originalSF / originalSFD) * 100)
            
            var newComponents = nonNilscaledTC.components
            newComponents.sf = scaledSubFrames
            
            scaledTC = try? newComponents.toTimecode(
                at: nonNilscaledTC.frameRate,
                base: ._100SubFrames
            )
        }
        
        // no match
        return (scaledTimecode: scaledTC, smpteFR: midiFileSMPTEFrameRate)
    }
}

extension Timecode.FrameRate {
    /// Returns the best corresponding MIDI File SMPTE Offset frame rate to represent `self`.
    public var midiFileSMPTEOffsetRate: MIDIFile.SMPTEOffsetFrameRate {
        switch self {
        case ._23_976: return ._24fps // as output from Pro Tools
        case ._24: return ._24fps // as output from Pro Tools
        case ._24_98: return ._24fps // custom
        case ._25: return ._25fps // as output from Pro Tools
        case ._29_97: return ._30fps // as output from Pro Tools
        case ._29_97_drop: return ._2997dfps // as output from Pro Tools
        case ._30: return ._30fps // as output from Pro Tools
        case ._30_drop: return ._2997dfps // as output from Pro Tools
        case ._47_952: return ._24fps // as output from Pro Tools
        case ._48: return ._24fps // as output from Pro Tools
        case ._50: return ._25fps // custom
        case ._59_94: return ._30fps // custom
        case ._59_94_drop: return ._2997dfps // custom
        case ._60: return ._30fps // custom
        case ._60_drop: return ._2997dfps // custom
        case ._100: return ._25fps // custom
        case ._119_88: return ._30fps // custom
        case ._119_88_drop: return ._2997dfps // custom
        case ._120: return ._30fps // custom
        case ._120_drop: return ._2997dfps // custom
        }
    }
}

extension MIDIFile.SMPTEOffsetFrameRate {
    /// Returns exact `Timecode` frame rate that matches the MIDI File SMPTE Offset frame rate.
    public var timecodeRate: Timecode.FrameRate {
        switch self {
        case ._24fps: return ._24
        case ._25fps: return ._25
        case ._2997dfps: return ._29_97_drop
        case ._30fps: return ._30
        }
    }
}
