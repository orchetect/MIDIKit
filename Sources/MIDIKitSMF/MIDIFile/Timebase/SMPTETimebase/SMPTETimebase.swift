//
//  SMPTETimebase.swift
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
    public var frameRate: MIDIFileFrameRate
    public var ticksPerFrame: UInt8
    
    public init(frameRate: MIDIFileFrameRate, ticksPerFrame: UInt8) {
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
        "Timebase(" + description + ")"
    }
}

// MARK: - Static Constructors

extension MIDIFileTimebase where Self == SMPTEMIDIFileTimebase {
    public static func `default`() -> SMPTEMIDIFileTimebase {
        SMPTEMIDIFileTimebase(frameRate: .fps30, ticksPerFrame: 40)
    }
    
    /// SMPTE timecode MIDI file timebase: Ticks per frame at a SMPTE frame rate.
    ///
    /// Typical `ticksPerFrame` values are:
    /// - `4` (corresponding to MIDI Timecode)
    /// - `8`
    /// - `10`
    /// - `80` (corresponding to SMPTE bit resolution)
    /// - `100` (corresponding to percent of a frame)
    ///
    /// For example, a timing resolution of 1 ms can be achieved by specifying 25 fps and 40 sub-frames (ticks per frame).
    ///
    /// > Tip:
    /// >
    /// > SMPTE timebase is *very rarely* used as a MIDI file timebase. The most common timebase is ``MusicalTimebase``.
    public static func smpte(
        frameRate: MIDIFileFrameRate,
        ticksPerFrame: UInt8
    ) -> Self {
        SMPTEMIDIFileTimebase(frameRate: frameRate, ticksPerFrame: ticksPerFrame)
    }
}

extension AnyMIDIFileTimebase {
    /// SMPTE timecode MIDI file timebase: Ticks per frame at a SMPTE frame rate.
    ///
    /// Typical `ticksPerFrame` values are:
    /// - `4` (corresponding to MIDI Timecode)
    /// - `8`
    /// - `10`
    /// - `80` (corresponding to SMPTE bit resolution)
    /// - `100` (corresponding to percent of a frame)
    ///
    /// For example, a timing resolution of 1 ms can be achieved by specifying 25 fps and 40 sub-frames (ticks per frame).
    ///
    /// > Tip:
    /// >
    /// > SMPTE timebase is *very rarely* used as a MIDI file timebase. The most common timebase is ``MusicalTimebase``.
    public static func smpte(
        frameRate: MIDIFileFrameRate,
        ticksPerFrame: UInt8
    ) -> Self {
        .smpte(SMPTEMIDIFileTimebase(frameRate: frameRate, ticksPerFrame: ticksPerFrame))
    }
}

extension SMPTEMIDIFileTimebase: MIDIFileTimebase {
    // MARK: - Decoding
    
    public init?(data: some DataProtocol) {
        guard data.count == 2 else {
            return nil
        }
        
        let byte1 = data[atOffset: 0]
        let byte2 = data[atOffset: 1]
        
        guard let fr = MIDIFileFrameRate(midi1SMFRawHeaderByte: byte1 & 0b01111111) else {
            return nil
        }
        let ticks = byte2
        
        self = .init(frameRate: fr, ticksPerFrame: ticks)
    }
    
    // MARK: - Encoding
    
    public func rawData() -> Data {
        rawData(as: Data.self)
    }
    
    public func rawData<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        let data = [
            frameRate.midi1SMFRawFileHeaderByte + 0b10000000,
            ticksPerFrame
        ]
        
        return D(data)
    }
    
    // MARK: - AnyMIDIFileTimebase
    
    public var asAnyMIDIFileTimebase: AnyMIDIFileTimebase {
        .smpte(self)
    }
}
