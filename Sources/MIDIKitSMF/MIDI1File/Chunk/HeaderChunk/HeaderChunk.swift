//
//  HeaderChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// [Standard MIDI File 1.0 Spec]:
//
// Header Chunks
//
// The header chunk at the beginning of the file specifies some basic information about the data in
// the file. Here's the syntax of the complete chunk:
//
// <Header Chunk> = <chunk type> <length> <format> <ntrks> <division>
//
// <chunk type> is the four ASCII characters 'MThd'; <length> is a 32-bit representation of the
// number 6 (high byte first).
//
// The data section contains three 16-bit words, stored most-significant byte first.
//
// The first word, <format>, specifies the overall organization of the file. Only three values of
// <format> are specified:
// - 0 the file contains a single multi-channel track
// - 1 the file contains one or more simultaneous tracks (or MIDI outputs) of a sequence
// - 2 the file contains one or more sequentially independent single-track patterns
//
// The next word, <ntrks>, is the number of track chunks in the file. It will always be 1 for a
// format 0 file.
//
// The third word, <division>, specifies the meaning of the delta-times. It has two formats, one for
// metrical time, and one for time-code-based time:
// ---------------------------------------------
// | 0 |        ticks per quarter-note         |
// ---------------------------------------------
// | 1 |     negative      |  ticks per frame  |
// |   |   SMPTE format    |                   |
// ---------------------------------------------
// 15   14               8   7                0
//
// If bit 15 of <division> is a zero, the bits 14 thru 0 represent the number of delta-time "ticks"
// which make up a quarter-note.
// For instance, if <division> is 96, then a time interval of an eighth-note between two events in
// the file would be 48.
//
// If bit 15 of <division> is a one, delta-times in a file correspond to subdivisions of a second,
// in a way consistent with SMPTE and MIDI time code. Bits 14 thru 8 contain one of the four values
// -24, -25, -29, or -30, corresponding to the four standard SMPTE and MIDI time code formats (-29
// corresponds to 30 drop frame), and represents the number of frames per second. These negative
// numbers are stored in two's complement form. The second byte (stored positive) is the resolution
// within a frame: typical values may be 4 (MIDI time code resolution), 8, 10, 80 (bit resolution),
// or 100. This system allows exact specification of time-code-based tracks, but also allows
// millisecond-based tracks by specifying 25 frames/sec and a resolution of 40 units per frame. If
// the events in a file are stored with bit resolution of thirty-frame time code, the division word
// would be E250 hex.
//
// MIDI File Format:
// A Format 0 file has a header chunk followed by one track chunk. It is the most interchangeable
// representation of data.
// A Format 1 or 2 file has a header chunk followed by one or more track chunks.
//
// Tempo:
// All MIDI Files should specify tempo and time signature. If they don't, the time signature is
// assumed to be 4/4, and the tempo 120 beats per minute. In format 0, these meta-events should
// occur at least at the beginning of the single multi-channel track. In format 1, these meta-
// events should be contained in the first track. In format 2, each of the temporally independent
// patterns should contain at least initial time signature and tempo information.

// NOTE:
// To allow for future expansion, a MIDI file reader should skip over (ie ignore) any chunk types
// that it does not know about (ie: besides MThd and MTrk), which it can easily do by reading the
// offending chunk's chunklen.

extension MIDI1File {
    /// Header: `MThd` chunk type.
    ///
    /// > Note:
    /// >
    /// > The header model omits the chunk (track) count property. It is automatically synthesized
    /// > based on the track count in the `MIDI1File.chunks` array when calling `MIDI1File.midi1FileRawBytes()`.
    public struct HeaderChunk {
        /// MIDI file format.
        public var format: MIDI1FileFormat
        
        /// MIDI file timebase (for duration calculations).
        public var timebase: Timebase
        
        /// Additional bytes found at the end of the header. Typically this should be left empty.
        ///
        /// The Standard MIDI File spec allows for additional bytes at the end of the file header.
        /// Technically additional bytes should only be used if they are defined at some point in
        /// a revision to the Standard MIDI File spec. However, until such event happens, file parsers
        /// should preserve and ignore these bytes.
        public var additionalBytes: Data? = nil
        
        public init(
            format: MIDI1FileFormat = .multipleTracksSynchronous,
            timebase: Timebase = .default()
        ) {
            self.format = format
            self.timebase = timebase
            self.additionalBytes = nil
        }
        
        public init(
            format: MIDI1FileFormat = .multipleTracksSynchronous,
            timebase: Timebase = .default(),
            additionalBytes: (some DataProtocol)?
        ) {
            self.format = format
            self.timebase = timebase
            self.additionalBytes = if let additionalBytes { Data(additionalBytes) } else { nil }
        }
    }
}

// MARK: - Properties

extension MIDI1File.HeaderChunk: Equatable { }

extension MIDI1File.HeaderChunk: Hashable { }

extension MIDI1File.HeaderChunk: Sendable { }

extension MIDI1File.HeaderChunk {
    /// Returns the header chunk as a type-erased ``AnyMIDI1FileHeaderChunk`` instance.
    public func asAnyMIDI1FileHeaderChunk() -> AnyMIDI1FileHeaderChunk {
        AnyMIDI1FileHeaderChunk(
            format: format,
            timebase: timebase.asAnyMIDIFileTimebase(),
            additionalBytes: additionalBytes
        )
    }
}
