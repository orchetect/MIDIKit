//
//  Track+Encoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile.Chunk.Track {
    public func midi1SMFRawBytes(
        using timebase: MIDIFile.Timebase
    ) throws(MIDIFile.EncodeError) -> Data {
        try midi1SMFRawBytes(as: Data.self, using: timebase)
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(
        as dataType: D.Type,
        using timebase: MIDIFile.Timebase
    ) throws(MIDIFile.EncodeError) -> D {
        // assemble chunk body without header or length
        
        var bodyData = D()
        
        for event in events {
            let unwrapped = event.smfUnwrappedEvent
            bodyData.append(deltaTime: unwrapped.delta.ticksValue(using: timebase))
            bodyData.append(contentsOf: unwrapped.event.midi1SMFRawBytes(as: D.self))
        }
        
        bodyData.append(deltaTime: 0)
        bodyData += Self.chunkEnd
        
        // assemble full chunk data with header and length
        
        var data = D()
        
        // 4-byte chunk identifier
        data += identifier.toASCIIData()
        
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
