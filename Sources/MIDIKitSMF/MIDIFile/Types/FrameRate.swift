//
//  FrameRate.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

// MARK: - FrameRate

extension MIDIFile {
    /// Timecode Frame Rate
    /// (For use in the MIDI file header when `.timecode` timebase is selected.)
    ///
    /// MIDI file header time division 2-byte value:
    /// Bits 8 - 15 (i.e. the first byte) specifies the number of frames per second (fps), and will be one of the four SMPTE standards - 24, 25, 29d or 30, though expressed as a negative value (using 2's complement notation), as follows:
    ///
    /// - 24fps: 0xE8
    /// - 25fps: 0xE7
    /// - 29fps: 0xE3
    /// - 30fps: 0xE2
    public enum FrameRate: Byte, CaseIterable, Equatable, Hashable {
        case _24fps    = 0b1101000 // 0xE8, assuming top bit of 1
        case _25fps    = 0b1100111 // 0xE7, assuming top bit of 1
        case _2997dfps = 0b1100011 // 0xE3, assuming top bit of 1
        case _30fps    = 0b1100010 // 0xE2, assuming top bit of 1
    }
}

extension MIDIFile.FrameRate: CustomStringConvertible,
                              CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case ._24fps:
            return "24fps"
            
        case ._25fps:
            return "25fps"
            
        case ._2997dfps:
            return "29.97dfps"
            
        case ._30fps:
            return "30fps"
        }
    }

    public var debugDescription: String {
        "FrameRate(" + description + ")"
    }
}
