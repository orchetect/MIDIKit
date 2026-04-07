//
//  SMPTEMIDIFileTimebase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// SMPTE timecode MIDI file timebase: Ticks per frame at a SMPTE frame rate.
///
/// Typical `ticksPerFrame` values are:
/// - `4` (quarter-frames commonly found in MIDI Timecode (MTC))
/// - `8`
/// - `10`
/// - `80` (corresponding to SMPTE bit resolution)
/// - `100` ("percent" of a frame)
///
/// For example, a timing resolution of 1 ms can be achieved by specifying 25 fps and 40 sub-frames (ticks per frame).
///
/// > Tip:
/// >
/// > SMPTE timecode timebase is *very rarely* used as a MIDI file timebase. It is only used in
/// > extremely specific applications. In fact, most (nearly all) software manufacturers do not support the
/// > format. However, it is included in MIDIKit because it is part of the Standard MIDI File spec.
/// >
/// > Musical timebase (``MusicalMIDIFileTimebase``) is the most common timebase used in MIDI files.
public struct SMPTEMIDIFileTimebase {
    public var frameRate: MIDI1FileFrameRate
    public var ticksPerFrame: UInt8
    
    public init(frameRate: MIDI1FileFrameRate, ticksPerFrame: UInt8) {
        self.frameRate = frameRate
        self.ticksPerFrame = ticksPerFrame
    }
}

extension SMPTEMIDIFileTimebase: Equatable { }

extension SMPTEMIDIFileTimebase: Hashable { }

extension SMPTEMIDIFileTimebase: Identifiable {
    public var id: Self { self }
}

extension SMPTEMIDIFileTimebase: Sendable { }

extension SMPTEMIDIFileTimebase: CustomStringConvertible {
    public var description: String {
        "Timecode: \(ticksPerFrame) ticks per frame @ \(frameRate)"
    }
}

extension SMPTEMIDIFileTimebase: CustomDebugStringConvertible {
    public var debugDescription: String {
        "SMPTEMIDIFileTimebase(" + description + ")"
    }
}

// MARK: - Static Constructors

extension MIDIFileTimebase where Self == SMPTEMIDIFileTimebase {
    public typealias DeltaTime = SMPTEMIDIFileDeltaTime
    
    public static func `default`() -> SMPTEMIDIFileTimebase {
        SMPTEMIDIFileTimebase(frameRate: .fps30, ticksPerFrame: 40)
    }
    
    /// SMPTE timecode MIDI file timebase: Ticks per frame at a SMPTE frame rate.
    ///
    /// Typical `ticksPerFrame` values are:
    /// - `4` (quarter-frames commonly found in MIDI Timecode (MTC))
    /// - `8`
    /// - `10`
    /// - `80` (corresponding to SMPTE bit resolution)
    /// - `100` ("percent" of a frame)
    ///
    /// For example, a timing resolution of 1 ms can be achieved by specifying 25 fps and 40 sub-frames (ticks per frame).
    ///
    /// > Tip:
    /// >
    /// > SMPTE timecode timebase is *very rarely* used as a MIDI file timebase. It is only used in
    /// > extremely specific applications. In fact, most (nearly all) software manufacturers do not support the
    /// > format. However, it is included in MIDIKit because it is part of the Standard MIDI File spec.
    /// >
    /// > Musical timebase (``MusicalMIDIFileTimebase``) is the most common timebase used in MIDI files.
    public static func smpte(
        frameRate: MIDI1FileFrameRate,
        ticksPerFrame: UInt8
    ) -> Self {
        SMPTEMIDIFileTimebase(frameRate: frameRate, ticksPerFrame: ticksPerFrame)
    }
}

extension AnyMIDIFileTimebase {
    /// SMPTE timecode MIDI file timebase: Ticks per frame at a SMPTE frame rate.
    ///
    /// Typical `ticksPerFrame` values are:
    /// - `4` (quarter-frames commonly found in MIDI Timecode (MTC))
    /// - `8`
    /// - `10`
    /// - `80` (corresponding to SMPTE bit resolution)
    /// - `100` ("percent" of a frame)
    ///
    /// For example, a timing resolution of 1 ms can be achieved by specifying 25 fps and 40 sub-frames (ticks per frame).
    ///
    /// > Tip:
    /// >
    /// > SMPTE timecode timebase is *very rarely* used as a MIDI file timebase. It is only used in
    /// > extremely specific applications. In fact, most (nearly all) software manufacturers do not support the
    /// > format. However, it is included in MIDIKit because it is part of the Standard MIDI File spec.
    /// >
    /// > Musical timebase (``MusicalMIDIFileTimebase``) is the most common timebase used in MIDI files.
    public static func smpte(
        frameRate: MIDI1FileFrameRate,
        ticksPerFrame: UInt8
    ) -> Self {
        .smpte(SMPTEMIDIFileTimebase(frameRate: frameRate, ticksPerFrame: ticksPerFrame))
    }
}

extension SMPTEMIDIFileTimebase: MIDIFileTimebase {
    // MARK: - Decoding
    
    public init?(midi1FileRawBytes: some DataProtocol) {
        guard midi1FileRawBytes.count == 2 else {
            return nil
        }
        
        let byte1 = midi1FileRawBytes[atOffset: 0]
        let byte2 = midi1FileRawBytes[atOffset: 1]
        
        guard let fr = MIDI1FileFrameRate(midi1FileRawHeaderByte: byte1 & 0b01111111) else {
            return nil
        }
        let ticks = byte2
        
        self = .init(frameRate: fr, ticksPerFrame: ticks)
    }
    
    // MARK: - Encoding
    
    public func midi1FileRawBytes() -> Data {
        midi1FileRawBytes(as: Data.self)
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        let data = [
            frameRate.midi1FileRawFileHeaderByte + 0b10000000,
            ticksPerFrame
        ]
        
        return D(data)
    }
    
    // MARK: - AnyMIDIFileTimebase
    
    public func asAnyMIDIFileTimebase() -> AnyMIDIFileTimebase {
        .smpte(self)
    }
}
