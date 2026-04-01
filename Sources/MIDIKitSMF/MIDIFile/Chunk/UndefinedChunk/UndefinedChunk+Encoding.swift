//
//  UndefinedChunk+Encoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile.UndefinedChunk {
    public func midi1SMFRawBytes() throws(MIDIFileEncodeError) -> Data {
        try midi1SMFRawBytes(as: Data.self)
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) throws(MIDIFileEncodeError) -> D {
        // assemble track body without header or length
        
        let bodyData = rawData
        
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
