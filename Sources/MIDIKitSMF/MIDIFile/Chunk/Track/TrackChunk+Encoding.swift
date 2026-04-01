//
//  TrackChunk+Encoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile.TrackChunk {
    public func midi1SMFRawBytes(
        using timebase: Timebase
    ) throws(MIDIFileEncodeError) -> Data {
        try midi1SMFRawBytes(as: Data.self, using: timebase)
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(
        as dataType: D.Type,
        using timebase: Timebase
    ) throws(MIDIFileEncodeError) -> D {
        // assemble chunk body without header or length
        
        var bodyData = D()
        
        for event in events {
            bodyData.append(deltaTime: event.delta.ticks(using: timebase))
            
            // TODO: support running status
            bodyData.append(contentsOf: event.event.unwrapped.midi1SMFRawBytes(as: D.self))
        }
        
        bodyData.append(deltaTime: deltaTimeBeforeEndOfTrack.ticks(using: timebase))
        bodyData += Self.trackEndByes
        
        // assemble full chunk data with header and length
        
        var data = D()
        
        // 4-byte chunk identifier
        data += identifier.string.toASCIIData()
        
        // chunk data length (32-bit 4 byte big endian integer)
        if let trackLength = UInt32(exactly: bodyData.count) {
            data += trackLength.toData(.bigEndian)
        } else {
            // track length overflows max length integer size
            // maximum track data size is 4.294967296 GB (UInt32.max bytes)
            throw .internalInconsistency(
                "Chunk length overflowed maximum size."
            )
        }
        
        data += bodyData
        
        return data
    }
}
