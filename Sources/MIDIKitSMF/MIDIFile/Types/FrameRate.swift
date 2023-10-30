//
//  FrameRate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

// MARK: - FrameRate

extension MIDIFile {
    /// Timecode Frame Rate
    /// (For use in the MIDI file header when
    /// ``TimeBase-swift.enum/timecode(smpteFormat:ticksPerFrame:)`` timebase is selected.)
    ///
    /// MIDI file header time division 2-byte value:
    /// Bits 8 - 15 (i.e. the first byte) specifies the number of frames per second (fps), and will
    /// be one of the four SMPTE standards - 24, 25, 29d or 30, though expressed as a negative value
    /// (using 2's complement notation), as follows:
    ///
    /// - 24 fps: `0xE8`
    /// - 25 fps: `0xE7`
    /// - 29.97 drop fps: `0xE3`
    /// - 30 fps: `0xE2`
    public enum FrameRate: UInt8, CaseIterable, Equatable, Hashable {
        case fps24    = 0b1101000 // 0xE8, assuming top bit of 1
        case fps25    = 0b1100111 // 0xE7, assuming top bit of 1
        case fps29_97d = 0b1100011 // 0xE3, assuming top bit of 1
        case fps30    = 0b1100010 // 0xE2, assuming top bit of 1
    }
}

extension MIDIFile.FrameRate: Sendable { }

extension MIDIFile.FrameRate: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .fps24:
            return "24fps"
            
        case .fps25:
            return "25fps"
            
        case .fps29_97d:
            return "29.97dfps"
            
        case .fps30:
            return "30fps"
        }
    }

    public var debugDescription: String {
        "FrameRate(" + description + ")"
    }
}
