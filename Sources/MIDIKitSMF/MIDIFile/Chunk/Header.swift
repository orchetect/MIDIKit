//
//  Header.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

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

// MARK: - Header

extension MIDIFile.Chunk {
    /// Header: `MThd` chunk type.
    public struct Header {
        public var format: MIDIFile.Format = .multipleTracksSynchronous
        
        public var timebase: MIDIFile.Timebase = .default()
        
        public init() { }
        
        public init(
            format: MIDIFile.Format,
            timebase: MIDIFile.Timebase
        ) {
            self.format = format
            self.timebase = timebase
        }
    }
}

extension MIDIFile.Chunk.Header: Equatable { }

extension MIDIFile.Chunk.Header: Hashable { }

extension MIDIFile.Chunk.Header: Sendable { }

extension MIDIFile.Chunk.Header: MIDIFileChunk {
    public var identifier: String { Self.staticIdentifier }
    
    public var chunkType: MIDIFile.ChunkType { Self.staticChunkType }
}

// MARK: - Static

extension MIDIFile.Chunk.Header {
    public static let staticIdentifier: String = "MThd"
    public static let staticChunkType: MIDIFile.ChunkType = .other(identifier: staticIdentifier)
}

// MARK: - Encoding

extension MIDIFile.Chunk.Header {
    static let midi1SMFFixedRawBytesLength = 14
    
    init<D: DataProtocol>(midi1SMFRawBytes: D) throws(MIDIFile.DecodeError) {
        guard midi1SMFRawBytes.count >= Self.midi1SMFFixedRawBytesLength else {
            throw .malformed(
                "File header length is not correct. File may not be a MIDI file."
            )
        }
        
        try midi1SMFRawBytes.withDataParser { parser throws(MIDIFile.DecodeError) in
            // Header descriptor
            
            guard (try? parser.read(bytes: 4).toUInt8Bytes()) == Self.staticIdentifier.toASCIIBytes()
            else {
                throw .malformed(
                    "File header identifier is not correct. File may not be a MIDI file."
                )
            }
            
            guard let headerLengthUInt32Bytes = try? parser.read(bytes: 4)
            else {
                throw .malformed(
                    "Not enough bytes found when attempting to read MIDI file header length."
                )
            }
            
            guard let headerLengthUInt32 = headerLengthUInt32Bytes.toInt32(from: .bigEndian)
            else {
                throw .malformed(
                    "Could not read MIDI file header length."
                )
            }
            let headerLength = Int(headerLengthUInt32)
            
            guard headerLength == 6 else {
                throw .malformed(
                    "Encountered unexpected file header length."
                )
            }
            
            // MIDI Format Type specification - 0, 1, or 2 (2 bytes: big endian)
            
            guard let midiFileFormatRawValue = (try? parser.read(bytes: 2))?
                .toUInt16(from: .bigEndian),
                (0 ... 2).contains(midiFileFormatRawValue),
                let uInt8Value = UInt8(exactly: midiFileFormatRawValue),
                let midiFileFormat = MIDIFile.Format(rawValue: uInt8Value)
            else {
                throw .malformed(
                    "Could not read MIDI file format from file header."
                )
            }

            format = midiFileFormat
            
            guard let numberOfChunks = (try? parser.read(bytes: 2))?
                .toUInt16(from: .bigEndian)
            else {
                throw .malformed(
                    "Could not read number of chunks from file header; end of file encountered."
                )
            }
            
            guard let timeDivision = try? parser.read(bytes: 2) else {
                throw .malformed(
                    "Could not read division info from file header; end of file encountered."
                )
            }
            
            guard let timebase = MIDIFile.Timebase(rawData: timeDivision) else {
                throw .malformed(
                    "Could not decode timebase."
                )
            }
            
            self.timebase = timebase
            
            // technically Format 0 can only have one track (chunk),
            // so header must always state a track count of 1 in that event
            if midiFileFormat == .singleTrack,
               numberOfChunks != 1
            {
                throw .malformed(
                    "MIDI file is Format 0 which can only contain a single track, but header reports a track count of \(numberOfChunks)."
                )
            }
        }
    }
}

extension MIDIFile.Chunk.Header {
    func midi1SMFRawBytes(withChunkCount chunkCount: Int) throws(MIDIFile.EncodeError) -> Data {
        try midi1SMFRawBytes(as: Data.self, withChunkCount: chunkCount)
    }
    
    func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type, withChunkCount: Int) throws(MIDIFile.EncodeError) -> D {
        // The header chunk appears at the beginning of the file:
        //   4D 54 68 64    ASCII "MThd".
        //   00 00 00 06    4-byte size of the header; this will always be 6
        //   ff ff          format (Int16 big-endian)
        //   nn nn          track count (Int16 big-endian)
        //   dd dd          timebase / time division (Int16 big-endian)
        
        var data = D()
        
        // Header descriptor
        data += identifier.toASCIIData()
        
        // Header length (after this point - format, track count and delta-time values)
        // 0x06 is assuming three 2-byte values are following
        data += [0x00, 0x00, 0x00, 0x06]
        
        // MIDI Format specification - 0, 1, or 2 (2 bytes: big endian)
        data += UInt16(format.rawValue).toData(.bigEndian)
        
        // Track count as 16-bit number (2 bytes: big endian)
        if format == .singleTrack {
            guard withChunkCount == 1 else {
                throw .internalInconsistency(
                    "MIDI file is Format 0 which can only contain a single track, but header reports a track count of \(withChunkCount)."
                )
            }
            
            data += UInt16(1).toData(.bigEndian) // only 1 track allowed
            
        } else {
            // For format 1 or 2 files, track count can be any value. There is no limitation as far
            // as the file format is concerned, though sequencer software will generally impose a
            // practical limit.
            data += UInt16(withChunkCount).toData(.bigEndian)
        }
        
        // Time division: ticks per quarter note
        // Specifies the timing interval to be used, and whether timecode (Hrs.Mins.Secs.Frames) or
        // metrical (Bar.Beat) timebase is to be used.
        // 15-bit variable-length encoded value: big endian, with top bit reserved for timecode flag
        // Bit 15 = 0 : metrical timebase
        // Bit 15 = 1 : timecode
        
        data += timebase.rawData(as: D.self)
        
        return data
    }
}
