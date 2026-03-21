//
//  Event SMPTEOffset.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import SwiftTimecodeCore
internal import SwiftDataParsing

// MARK: - SMPTEOffset

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Specify the SMPTE time at which the track is to start.
    /// This optional event, if present, should occur at the start of a track,
    /// at `time == 0`, and prior to any MIDI events.
    /// Defaults to `00:00:00:00 @ 30fps`.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in
    /// > SMPTE-based tracks which specify a different frame subdivision for delta-times.
    public struct SMPTEOffset {
        /// Timecode hour.
        /// Valid range: ` 0 ... 23`.
        public var hours: UInt8 = 0 {
            didSet {
                if oldValue != hours { hours_Validate() }
            }
        }
        
        private mutating func hours_Validate() {
            hours = hours.clamped(to: 0 ... 23)
        }
        
        /// Timecode minutes.
        /// Valid range: `0 ... 59`.
        public var minutes: UInt8 = 0 {
            didSet {
                if oldValue != minutes { minutes_Validate() }
            }
        }
        
        private mutating func minutes_Validate() {
            minutes = minutes.clamped(to: 0 ... 59)
        }
        
        /// Timecode seconds.
        /// Valid range: `0 ... 59`.
        public var seconds: UInt8 = 0 {
            didSet {
                if oldValue != seconds { seconds_Validate() }
            }
        }
        
        private mutating func seconds_Validate() {
            seconds = seconds.clamped(to: 0 ... 59)
        }
        
        /// Timecode frames.
        /// Valid range is dependent on the `frameRate` property
        /// (`0 ... 23` for 24fps, `0 ... 29` for 30fps, etc.).
        public var frames: UInt8 = 0 {
            didSet {
                if oldValue != frames { frames_Validate() }
            }
        }
        
        private mutating func frames_Validate() {
            switch frameRate {
            case .fps24: frames = frames.clamped(to: 0 ... 23)
            case .fps25: frames = frames.clamped(to: 0 ... 25)
            case .fps30, .fps29_97d: frames = frames.clamped(to: 0 ... 29)
            }
        }
        
        /// Timecode subframes.
        /// Valid range: `0 ... 99`.
        /// The number of fractional frames, in 100ths of a frame (even in SMPTE-based tracks using
        /// a different frame subdivision, defined in the `MThd` MIDI file header chunk).
        public var subframes: UInt8 = 0 {
            didSet {
                if oldValue != subframes { subframes_Validate() }
            }
        }
        
        private mutating func subframes_Validate() {
            subframes = subframes.clamped(to: 0 ... 99)
        }
        
        /// The frame rate associated with the SMPTE offset.
        public var frameRate: MIDIFile.FrameRate = .fps30
        
        // MARK: - Init
        
        public init() { }
        
        /// Initialized with raw values.
        ///
        /// - Parameters:
        ///   - hr: Hours value.
        ///   - min: Minutes value.
        ///   - sec: Seconds value.
        ///   - fr: Frames value.
        ///   - subFr: Subframes value.
        ///   - frRate: SMPTE frame rate.
        public init(
            hr: UInt8,
            min: UInt8,
            sec: UInt8,
            fr: UInt8,
            subFr: UInt8 = 0,
            frRate: MIDIFile.FrameRate = .fps30
        ) {
            frameRate = frRate
            
            hours = hr; hours_Validate()
            minutes = min; minutes_Validate()
            seconds = sec; seconds_Validate()
            frames = fr; frames_Validate()
            subframes = subFr; subframes_Validate()
        }
    }
}

extension MIDIFileEvent.SMPTEOffset: Equatable { }

extension MIDIFileEvent.SMPTEOffset: Hashable { }

extension MIDIFileEvent.SMPTEOffset: Sendable { }

// MARK: - Init

extension MIDIFileEvent.SMPTEOffset {
    /// Specify the SMPTE time at which the track is to start.
    /// This optional event, if present, should occur at the start of a track,
    /// at `time == 0`, and prior to any MIDI events.
    /// If a frame rate is supplied that does not directly correlate to one of the four SMPTE rates
    /// used in the Standard MIDI File spec, the timecode will be scaled to the closest matching rate.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in
    /// > SMPTE-based tracks which specify a different frame subdivision for delta-times.
    public init?(scaling timecode: Timecode) {
        let smpteTCAndRate = timecode.scaledToMIDIFileSMPTEFrameRate
        guard let smpteTC = smpteTCAndRate.scaledTimecode else { return nil }
        
        frameRate = smpteTCAndRate.smpteFR
        
        hours =     UInt8(exactly: smpteTC.hours) ?? 0
        minutes =   UInt8(exactly: smpteTC.minutes) ?? 0
        seconds =   UInt8(exactly: smpteTC.seconds) ?? 0
        frames =    UInt8(exactly: smpteTC.frames) ?? 0
        subframes = UInt8(exactly: smpteTC.subFrames) ?? 0
    }
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Specify the SMPTE time at which the track is to start.
    /// This optional event, if present, should occur at the start of a track,
    /// at `time == 0`, and prior to any MIDI events.
    /// Defaults to `00:00:00:00 @ 30fps`.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in
    /// > SMPTE-based tracks which specify a different frame subdivision for delta-times.
    ///
    /// - Parameters:
    ///   - delta: MIDI file track delta time.
    ///   - hr: Hours value.
    ///   - min: Minutes value.
    ///   - sec: Seconds value.
    ///   - fr: Frames value.
    ///   - subFr: Subframes value.
    ///   - frRate: SMPTE frame rate.
    public static func smpteOffset(
        delta: DeltaTime = .none,
        hr: UInt8,
        min: UInt8,
        sec: UInt8,
        fr: UInt8,
        subFr: UInt8 = 0,
        frRate: MIDIFile.FrameRate = .fps30
    ) -> Self {
        .smpteOffset(
            delta: delta,
            event: .init(
                hr: hr,
                min: min,
                sec: sec,
                fr: fr,
                subFr: subFr,
                frRate: frRate
            )
        )
    }
    
    /// Specify the SMPTE time at which the track is to start.
    /// This optional event, if present, should occur at the start of a track,
    /// at `time == 0`, and prior to any MIDI events.
    /// If a frame rate is supplied that does not directly correlate to one of the four SMPTE rates
    /// used in the Standard MIDI File spec, the timecode will be scaled to the closest matching rate.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in
    /// > SMPTE-based tracks which specify a different frame subdivision for delta-times.
    public static func smpteOffset(
        delta: DeltaTime = .none,
        scaling timecode: Timecode
    ) -> Self? {
        guard let event = SMPTEOffset(scaling: timecode) else { return nil }
        return .smpteOffset(delta: delta, event: event)
    }
}

// MARK: - Properties

extension MIDIFileEvent.SMPTEOffset {
    /// Returns the raw SMPTE offset timecode components.
    public var components: Timecode.Components {
        .init(
            h: Int(hours),
            m: Int(minutes),
            s: Int(seconds),
            f: Int(frames),
            sf: Int(subframes)
        )
    }
    
    /// Returns a new `Timecode` instance from the SMPTE offset.
    public var timecode: Timecode {
        Timecode(
            .components(components),
            at: frameRate.timecodeRate,
            base: .max100SubFrames,
            by: .allowingInvalid
        )
    }
}

// MARK: - Static

extension MIDIFileEvent.SMPTEOffset {
    /// The prefix bytes that define the start of the event.
    public static let prefixBytes: [UInt8] = [0xFF, 0x54, 0x05]
}

// MARK: - Encoding

extension MIDIFileEvent.SMPTEOffset: MIDIFileEvent.Payload {
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        .smpteOffset(delta: delta, event: self)
    }
    
    public static let smfEventType: MIDIFileEvent.EventType = .smpteOffset
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw .malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let (
            readFrameRateBits, readHours, readMinutes, readSeconds, readFrames, readSubframes
        ) = try rawBytes.withDataParser { parser throws(MIDIFile.DecodeError) -> (
            UInt8, UInt8, UInt8, UInt8, UInt8, UInt8
        ) in
            // 3-byte preamble
            guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                  headerBytes.elementsEqual(Self.prefixBytes)
            else {
                throw .malformed("Event does not start with expected bytes.")
            }
            
            do {
                let readHoursByte = try parser.readByte()
                let readFrameRateBits = (readHoursByte & 0b1100000) >> 5
                let readHours = readHoursByte & 0b0011111
                
                let readMinutes = try parser.readByte()
                let readSeconds = try parser.readByte()
                let readFrames = try parser.readByte()
                let readSubframes = try parser.readByte()
                
                return (
                    readFrameRateBits: readFrameRateBits,
                    readHours: readHours,
                    readMinutes: readMinutes,
                    readSeconds: readSeconds,
                    readFrames: readFrames,
                    readSubframes: readSubframes
                )
            } catch {
                throw .malformed(error.localizedDescription)
            }
        }
        
        guard let readFrameRate = MIDIFile.FrameRate(midi1SMFRawTrackOffsetByte: readFrameRateBits)
        else {
            // this should never happen, but trap error any way
            throw .malformed(
                "Could not form frame rate from Hours byte."
            )
        }
        
        guard (0 ... 23).contains(readHours) else {
            throw .malformed(
                "Hours is out of bounds: \(readHours)"
            )
        }
        
        guard (0 ... 59).contains(readMinutes) else {
            throw .malformed(
                "Minutes is out of bounds: \(readMinutes)"
            )
        }
        
        guard (0 ... 59).contains(readSeconds) else {
            throw .malformed(
                "Seconds value is out of bounds: \(readSeconds)"
            )
        }
        
        guard (0 ... 30).contains(readFrames) else {
            throw .malformed(
                "Frames value is out of bounds: \(readFrames)"
            )
        }
        
        guard (0 ... 99).contains(readSubframes) else {
            throw .malformed(
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
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 54 05 hr mn se fr ff
        //
        // 05 is length
        //
        // hr is a byte specifying the hour, which is also encoded with the SMPTE format (frame
        // rate), just as it is in MIDI Time Code
        //   8 bits: 0rrhhhhh, where:
        //     - rr = frame rate:
        //       00 = 24 fps
        //       01 = 25 fps
        //       10 = 30 fps (drop frame)
        //       11 = 30 fps (non-drop frame)
        //     - hhhhh = hour (0-23)
        //
        // ff is a byte specifying the number of fractional frames, in 100ths of a frame (even in
        // SMPTE-based tracks using a different frame subdivision, defined in the MThd chunk).
        
        var data = D()
        
        data += Self.prefixBytes // start bytes
        data += [(frameRate.midi1SMFRawTrackOffsetEventByte << 5) + hours] // hour & frame rate
        data += [minutes] // minutes
        data += [seconds] // seconds
        data += [frames] // frames
        data += [subframes] // subframes
        
        return data
    }
    
    static let midi1SMFFixedRawBytesLength = 8
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
        let requiredData = stream.prefix(midi1SMFFixedRawBytesLength)
        
        let newInstance = try Self(midi1SMFRawBytes: requiredData, runningStatus: runningStatus)
        
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
            " @ \(frameRate)"
        
        return "smpte: " + time
    }
    
    public var smfDebugDescription: String {
        "SMPTEOffset(" + smfDescription + ")"
    }
}

// MARK: - Helpers

extension Timecode {
    /// Determines the best corresponding MIDI File SMPTE Offset frame rate to represent this
    /// timecode, converts the timecode to that frame rate, and converts the subframes to be scaled
    /// to a 100 subframe divisor if needed.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in
    /// > SMPTE- based tracks which specify a different frame subdivision for delta-times.
    public var scaledToMIDIFileSMPTEFrameRate: (
        scaledTimecode: Timecode?,
        smpteFR: MIDIFile.FrameRate
    ) {
        let midiFileSMPTEFrameRate = frameRate.midiFileSMPTEFrameRate
        
        var scaledTC = try? converted(to: midiFileSMPTEFrameRate.timecodeRate)
        
        // scale subframes if needed
        if scaledTC?.subFramesBase != .max100SubFrames,
           let nonNilscaledTC = scaledTC
        {
            let originalSF = Double(nonNilscaledTC.subFrames)
            let originalSFD = Double(nonNilscaledTC.subFramesBase.rawValue)
            
            let scaledSubFrames =
                Int((originalSF / originalSFD) * 100)
            
            var newComponents = nonNilscaledTC.components
            newComponents.subFrames = scaledSubFrames
            
            scaledTC = try? Timecode(
                .components(newComponents),
                at: nonNilscaledTC.frameRate,
                base: .max100SubFrames
            )
        }
        
        // no match
        return (scaledTimecode: scaledTC, smpteFR: midiFileSMPTEFrameRate)
    }
}

extension TimecodeFrameRate {
    /// Returns the best corresponding MIDI File SMPTE Offset frame rate to represent the timecode
    /// frame rate.
    public var midiFileSMPTEFrameRate: MIDIFile.FrameRate {
        switch self {
        case .fps23_976: .fps24 // as output from Pro Tools
        case .fps24: .fps24 // as output from Pro Tools
        case .fps24_98: .fps24 // custom
        case .fps25: .fps25 // as output from Pro Tools
        case .fps29_97: .fps30 // as output from Pro Tools
        case .fps29_97d: .fps29_97d // as output from Pro Tools
        case .fps30: .fps30 // as output from Pro Tools
        case .fps30d: .fps29_97d // as output from Pro Tools
        case .fps47_952: .fps24 // as output from Pro Tools
        case .fps48: .fps24 // as output from Pro Tools
        case .fps50: .fps25 // custom
        case .fps59_94: .fps30 // custom
        case .fps59_94d: .fps29_97d // custom
        case .fps60: .fps30 // custom
        case .fps60d: .fps29_97d // custom
        case .fps90: .fps30 // custom
        case .fps95_904: .fps24 // custom
        case .fps96: .fps24 // custom
        case .fps100: .fps25 // custom
        case .fps119_88: .fps30 // custom
        case .fps119_88d: .fps29_97d // custom
        case .fps120: .fps30 // custom
        case .fps120d: .fps29_97d // custom
        }
    }
}

extension MIDIFile.FrameRate {
    /// Returns exact `Timecode` frame rate that matches the MIDI File SMPTE Offset frame rate.
    public var timecodeRate: TimecodeFrameRate {
        switch self {
        case .fps24: .fps24
        case .fps25: .fps25
        case .fps29_97d: .fps29_97d
        case .fps30: .fps30
        }
    }
}
