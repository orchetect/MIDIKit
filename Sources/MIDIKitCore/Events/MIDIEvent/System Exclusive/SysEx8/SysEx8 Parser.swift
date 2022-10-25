//
//  SysEx8 Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIEvent {
    /// Parse a complete MIDI 2.0 System Exclusive 8 message (starting with the Stream ID byte until
    /// the end of the packet) and return a ``sysEx8(manufacturer:data:group:)`` or
    /// ``universalSysEx8(universalType:deviceID:subID1:subID2:data:group:)`` case if successful.
    ///
    /// Valid rawBytes count is `1 ... 14`. (Must always contain a Stream ID, even if there are zero
    /// data bytes to follow)
    ///
    /// > Note: This does not parse an entire SysEx8 UMP packet.
    /// >
    /// > `rawBytes` must start with the Stream ID byte and supply all bytes until the end of the
    /// packet.
    ///
    /// - Throws: ``ParseError`` if message is malformed.
    public static func sysEx8(
        rawBytes: [UInt8],
        group: UInt4 = 0
    ) throws -> Self {
        var readPos = rawBytes.startIndex
    
        func readPosAdvance(by: Int) throws {
            let newPos = readPos + by
            guard readPos + by < rawBytes.endIndex else {
                throw ParseError.malformed
            }
            readPos = newPos
        }
    
        func readData() -> [UInt8] {
            Array(rawBytes[readPos...])
        }
    
        // prevent zero-byte events from being formed
        guard !rawBytes.isEmpty else {
            throw ParseError.rawBytesEmpty
        }
    
        // minimum length
        guard rawBytes.count > 1 else {
            throw ParseError.malformed
        }
    
        let streamID = rawBytes[readPos]
    
        // ID bytes
    
        try readPosAdvance(by: 1)
        let idByte1 = rawBytes[readPos]
        try readPosAdvance(by: 1)
        let idByte2 = rawBytes[readPos]
    
        let sysExID = SysExID(sysEx8RawBytes: [idByte1, idByte2])
    
        switch sysExID {
        case let .universal(universalType):
            try readPosAdvance(by: 1)
            guard let deviceID = UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
    
            try readPosAdvance(by: 1)
            guard let subID1 = UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
    
            try readPosAdvance(by: 1)
            guard let subID2 = UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
    
            let data: [UInt8] = {
                if (try? readPosAdvance(by: 1)) != nil {
                    return readData()
                } else {
                    return []
                }
            }()
    
            return .universalSysEx8(
                .init(
                    universalType: universalType,
                    deviceID: deviceID,
                    subID1: subID1,
                    subID2: subID2,
                    data: data,
                    streamID: streamID,
                    group: group
                )
            )
    
        case let .manufacturer(mfr):
            var data: [UInt8] = []
    
            let actualEndIndex = rawBytes.endIndex.advanced(by: -1)
            if readPos < actualEndIndex {
                if (try? readPosAdvance(by: 1)) != nil {
                    data = readData()
                }
            }
    
            return .sysEx8(
                .init(
                    manufacturer: mfr,
                    data: data,
                    streamID: streamID,
                    group: group
                )
            )
    
        default:
            // malformed
            throw ParseError.malformed
        }
    }
}
