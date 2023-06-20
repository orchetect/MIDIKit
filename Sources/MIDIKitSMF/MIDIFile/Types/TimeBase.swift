//
//  TimeBase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - timeBase

extension MIDIFile {
    /// MIDI file timebase as described in the MIDI file header.
    public enum TimeBase: Equatable, Hashable {
        /// Musical: Delta-time ticks per quarter note (PPQN / PPQ / PPQBase / TPQN).
        ///
        /// Common values: 96, 120, 480, 960. Cubase exports at 480 by default.
        /// Can also be a larger value if needed.
        /// Consider evenly divisible sub-divisions when determining this value.
        case musical(ticksPerQuarterNote: UInt16)
        
        /// SMPTE Timecode
        ///
        /// Typical `ticksPerFrame` values are 4 (corresponding to MIDI Timecode), 8, 10,
        /// 80 (corresponding to SMPTE bit resolution), or 100.
        ///
        /// (A timing resolution of 1 ms can be achieved by specifying 25 fps and 40 sub-frames,
        /// which would be encoded in hex as E7 28.)
        case timecode(smpteFormat: FrameRate, ticksPerFrame: UInt8)
    }
}

// MARK: - Static Constructors

extension MIDIFile.TimeBase {
    public static func `default`() -> Self {
        .musical(ticksPerQuarterNote: 960)
    }
}

extension MIDIFile.TimeBase {
    var rawData: Data {
        switch self {
        case let .musical(ticksPerQuarterNote):
            return (ticksPerQuarterNote & 0b01111111_11111111)
                .toData(.bigEndian)
            
        case let .timecode(smpteFormat, ticksPerFrame):
            return [
                smpteFormat.rawValue + 0b10000000,
                ticksPerFrame
            ]
                .data
        }
    }
}

extension MIDIFile.TimeBase {
    /// Initialize from raw data.
    public init?(rawData: Data) {
        guard rawData.count == 2 else {
            return nil
        }
        
        self.init(rawBytes: Array(rawData.bytes.prefix(2)))
    }
    
    /// Initialize from raw data.
    public init?(rawBytes bytes: [UInt8]) {
        guard bytes.count == 2 else {
            return nil
        }
        
        let byte1 = bytes[0]
        let byte2 = bytes[1]
        
        switch (byte1 & 0b10000000) >> 7 {
        case 0b0: // musical
            let ticks = ((UInt16(byte1) & 0b01111111) << 8) + UInt16(byte2)
            self = .musical(ticksPerQuarterNote: ticks)
            
        case 0b1: // timecode
            guard let fr = MIDIFile.FrameRate(rawValue: byte1 & 0b01111111) else {
                return nil
            }
            let ticks = byte2
            
            self = .timecode(smpteFormat: fr, ticksPerFrame: ticks)
            
        default:
            return nil
        }
    }
}

extension MIDIFile.TimeBase: CustomStringConvertible,
CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case let .musical(ticksPerQuarterNote):
            return "Musical: \(ticksPerQuarterNote) ticks per quarter"
            
        case let .timecode(smpteFormat, ticksPerFrame):
            return "Timecode: \(smpteFormat) \(ticksPerFrame) ticks per frame"
        }
    }
    
    public var debugDescription: String {
        "timeBase(" + description + ")"
    }
}
