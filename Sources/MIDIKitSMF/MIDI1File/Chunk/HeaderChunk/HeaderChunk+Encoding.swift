//
//  HeaderChunk+Encoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

extension MIDI1File.HeaderChunk {
    public func midi1SMFRawBytes(withTrackCount trackCount: Int) throws(MIDIFileEncodeError) -> Data {
        try midi1SMFRawBytes(as: Data.self, withTrackCount: trackCount)
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type, withTrackCount trackCount: Int) throws(MIDIFileEncodeError) -> D {
        // The header chunk appears at the beginning of the file:
        //   4D 54 68 64    ASCII "MThd".
        //   00 00 00 06    4-byte size of the header; this will always be 6
        //   ff ff          format (Int16 big-endian)
        //   nn nn          track count (Int16 big-endian)
        //   dd dd          timebase / time division (Int16 big-endian)
        
        var data = D()
        
        // Header descriptor
        data += identifier.string.toASCIIData()
        
        // Header length (after this point - format, track count, delta-time values, and optionally additional bytes if present)
        let headerLength = 6 + (additionalBytes?.count ?? 0)
        data += UInt32(headerLength).toData(.bigEndian)
        
        // MIDI Format specification - 0, 1, or 2 (2 bytes: big endian)
        data += UInt16(format.rawValue).toData(.bigEndian)
        
        // Track count as 16-bit number (2 bytes: big endian)
        if format == .singleTrack {
            guard trackCount == 1 else {
                throw .internalInconsistency(
                    "MIDI file is Format 0 which should only contain a single track, but header encoding encountered a track count of \(trackCount)."
                )
            }
            
            data += UInt16(1).toData(.bigEndian) // only 1 track allowed
            
        } else {
            // For format 1 or 2 files, track count can be any value. There is no limitation as far
            // as the file format is concerned, though sequencer software will generally impose a
            // practical limit.
            data += UInt16(trackCount).toData(.bigEndian)
        }
        
        // Time division: ticks per quarter note
        // Specifies the timing interval to be used, and whether timecode (Hrs.Mins.Secs.Frames) or
        // metrical (Bar.Beat) timebase is to be used.
        // 15-bit variable-length encoded value: big endian, with top bit reserved for timecode flag
        // Bit 15 = 0 : metrical timebase
        // Bit 15 = 1 : timecode
        
        data += timebase.rawData(as: D.self)
        
        // Additional bytes
        if let additionalBytes {
            data += additionalBytes
        }
        
        return data
    }
}
