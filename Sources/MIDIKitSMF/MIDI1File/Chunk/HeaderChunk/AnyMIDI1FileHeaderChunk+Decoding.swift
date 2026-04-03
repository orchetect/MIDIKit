//
//  AnyMIDI1FileHeaderChunk+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

extension AnyMIDI1FileHeaderChunk {
    /// The original Standard MIDI File spec defines the header as 14 bytes:
    /// - MThd (4 bytes)
    /// - header length (4 bytes)
    /// - format (2 bytes)
    /// - track count (2 bytes)
    /// - time division (2 bytes)
    ///
    /// However, the spec says that parsers should allow for headers that are longer, but ignore any
    /// header bytes past the first 14 bytes and continue parsing as normal. Additional bytes are possible
    /// if/when there is an addition to the Standard MIDI File spec that formally defines them.
    /// (At which point, we can update our parser to parse the additional bytes.)
    static var midi1FileMinimumRawBytesLength: Int { 14 }
    
    /// Init from MIDI file data stream.
    static func initFrom<D: DataProtocol>(
        midi1FileRawBytesStream stream: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int, bufferLength: Int) {
        // check for at least the minimum expected byte count
        guard stream.count >= Self.midi1FileMinimumRawBytesLength else {
            throw .malformed(
                "File header length is not correct. File may not be a MIDI file."
            )
        }
        
        return try stream.withDataParser { parser throws(MIDIFileDecodeError) in
            // Header descriptor
            
            guard (try? parser.read(bytes: 4).toUInt8Bytes()) == HeaderMIDI1FileChunkIdentifier().string.toASCIIBytes()
            else {
                throw .malformed(
                    "File header identifier is not correct. File may not be a MIDI file."
                )
            }
            
            guard let rawHeaderLengthBytes = try? parser.read(bytes: 4)
            else {
                throw .malformed(
                    "Not enough bytes found when attempting to read MIDI file header length."
                )
            }
            
            guard let headerLengthUInt32 = rawHeaderLengthBytes.toInt32(from: .bigEndian)
            else {
                throw .malformed(
                    "Could not read MIDI file header length."
                )
            }
            let headerLength = Int(headerLengthUInt32)
            
            // we won't validate the header length here; that is done in the subsequent initFrom() function we pass the data to
            
            // now that we know the header length, grab the entire header and pass it to the parser
            let entireHeaderLength = 4 + 4 + headerLength
            parser.seekToStart()
            let headerData = try parser.toMIDIFileDecodeError(
                malformedReason: "Not enough bytes found when attempting to read MIDI file header.",
                try parser.read(bytes: entireHeaderLength)
            )
            let (header, trackCount) = try initFrom(midi1FileRawBytes: headerData, allowMultiTrackFormat0: allowMultiTrackFormat0)
            
            return (header: header, trackCount: trackCount, bufferLength: entireHeaderLength)
        }
    }
    
    static func initFrom<D: DataProtocol>(
        midi1FileRawBytes: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int) {
        // check for at least the minimum expected byte count
        guard midi1FileRawBytes.count >= Self.midi1FileMinimumRawBytesLength else {
            throw .malformed(
                "File header length is not correct. File may not be a MIDI file."
            )
        }
        
        return try midi1FileRawBytes.withDataParser { parser throws(MIDIFileDecodeError) in
            // Header descriptor
            
            guard (try? parser.read(bytes: 4).toUInt8Bytes()) == HeaderMIDI1FileChunkIdentifier().string.toASCIIBytes()
            else {
                throw .malformed(
                    "File header identifier is not correct. File may not be a MIDI file."
                )
            }
            
            guard let rawHeaderLengthBytes = try? parser.read(bytes: 4)
            else {
                throw .malformed(
                    "Not enough bytes found when attempting to read MIDI file header length."
                )
            }
            
            guard let headerLengthUInt32 = rawHeaderLengthBytes.toInt32(from: .bigEndian)
            else {
                throw .malformed(
                    "Could not read MIDI file header length."
                )
            }
            let headerLength = Int(headerLengthUInt32)
            
            // the header may contain more than 6 bytes in the event the Standard MIDI File spec gains
            // revisions - but until that happens, we just ignore any additional bytes after the first 6
            // known (defined) bytes
            let knownHeaderLength = 6
            guard headerLength >= knownHeaderLength else {
                throw .malformed(
                    "File header length is shorter than expected."
                )
            }
            
            // MIDI Format Type specification - 0, 1, or 2 (2 bytes: big endian)
            
            guard let rawFileFormat = (try? parser.read(bytes: 2))?
                .toUInt16(from: .bigEndian),
                  (0 ... 2).contains(rawFileFormat),
                  let fileFormatUInt8 = UInt8(exactly: rawFileFormat),
                  let format = MIDI1FileFormat(rawValue: fileFormatUInt8)
            else {
                throw .malformed(
                    "Could not read MIDI file format from file header."
                )
            }
            
            // note track count is NOT total chunk count after the header;
            // non-track chunks are not included in the number
            guard let rawTrackCount = (try? parser.read(bytes: 2))?
                .toUInt16(from: .bigEndian)
            else {
                throw .malformed(
                    "Could not read number of tracks from file header; end of file encountered."
                )
            }
            
            let trackCount = Int(rawTrackCount) // UInt16 is guaranteed to fit into `Int`
            
            guard let timeDivision = try? parser.read(bytes: 2) else {
                throw .malformed(
                    "Could not read division info from file header; end of file encountered."
                )
            }
            
            guard let timebase = AnyMIDIFileTimebase(midi1FileRawBytes: timeDivision) else {
                throw .malformed(
                    "Could not decode timebase."
                )
            }
            
            // gather any additional unhandled bytes that were included in the header length beyond the known (defined) bytes
            var additionalBytes: Data? = nil
            if headerLength > knownHeaderLength {
                additionalBytes = try parser.toMIDIFileDecodeError(
                    malformedReason: "Could not read trailing bytes of file header; end of file encountered.",
                    try parser.read(bytes: headerLength - knownHeaderLength).toData()
                )
            }
            
            // technically Format 0 can only have one track, and in that case the
            // header should always state a track count of 1 (but sometimes it disobeys this)
            if format == .singleTrack {
                if trackCount != 1, !allowMultiTrackFormat0 {
                    throw .malformed(
                        "MIDI file is Format 0 which should only contain a single track, but header reports a track count of \(trackCount)."
                    )
                }
            }
            
            let header = if let additionalBytes {
                Self(format: format, timebase: timebase, additionalBytes: additionalBytes)
            } else {
                Self(format: format, timebase: timebase)
            }
            return (header: header, trackCount: trackCount)
        }
    }
}
