//
//  SysEx7 Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIEvent {
    /// Parse a complete raw MIDI 1.0 System Exclusive 7 message and return a `.sysEx7()` or `.universalSysEx7()` case if successful.
    /// Message must begin with 0xF0 but terminating 0xF7 byte is optional.
    ///
    /// - Throws: `MIDIEvent.ParseError` if message is malformed.
    public static func sysEx7(
        rawBytes: [Byte],
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
    
        func readData() throws -> [Byte] {
            let actualEndIndex = rawBytes.endIndex.advanced(by: -1)
    
            var dataBytes: [Byte] = []
            let bytesRemaining = actualEndIndex - readPos
            dataBytes.reserveCapacity(bytesRemaining)
    
            for idx in readPos ... actualEndIndex {
                let byte = rawBytes[idx]
                if byte == 0xF7, idx == actualEndIndex {
                    // ignore if final byte is 0xF7
                } else if byte < 0x80 {
                    dataBytes.append(byte)
                } else {
                    // invalid byte
                    throw ParseError.malformed
                }
            }
    
            return dataBytes
        }
    
        // prevent zero-byte events from being formed
        guard !rawBytes.isEmpty else {
            throw ParseError.rawBytesEmpty
        }
    
        // minimum length
        guard rawBytes.count > 1 else {
            throw ParseError.malformed
        }
    
        guard rawBytes.first == 0xF0 else {
            throw ParseError.malformed
        }
    
        // manufacturer byte
    
        try readPosAdvance(by: 1)
        guard let idByte1 = UInt7(exactly: rawBytes[readPos]) else {
            throw ParseError.malformed
        }
    
        switch idByte1 {
        case 0x7E, 0x7F:
            // universal sys ex
    
            guard let universalType = UniversalSysExType(rawValue: idByte1) else {
                throw ParseError.malformed
            }
    
            try readPosAdvance(by: 1)
            guard let deviceID = UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
    
            try readPosAdvance(by: 1)
            guard let subID1 = UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
    
            try readPosAdvance(by: 1)
            guard let subID2 = UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
    
            try readPosAdvance(by: 1)
            let data = try readData()
    
            return .universalSysEx7(
                .init(
                    universalType: universalType,
                    deviceID: deviceID,
                    subID1: subID1,
                    subID2: subID2,
                    data: data,
                    group: group
                )
            )
    
        case 0x00 ... 0x7D:
            var readManufacturer: SysExManufacturer?
    
            switch idByte1 {
            case 0x00:
                // 3-byte ID; 0x00 means 2 bytes will follow
                try readPosAdvance(by: 1)
                guard let idByte2 = UInt7(exactly: rawBytes[readPos]) else {
                    throw ParseError.malformed
                }
    
                try readPosAdvance(by: 1)
                guard let idByte3 = UInt7(exactly: rawBytes[readPos]) else {
                    throw ParseError.malformed
                }
    
                readManufacturer = .threeByte(byte2: idByte2, byte3: idByte3)
    
            case 0x01 ... 0x7D:
                // 1-byte ID
                readManufacturer = .oneByte(idByte1)
    
            default:
                break // will never happen
            }
    
            guard let manufacturer = readManufacturer
            else { throw ParseError.malformed }
    
            var data: [Byte] = []
    
            let actualEndIndex = rawBytes.endIndex.advanced(by: -1)
            if readPos < actualEndIndex {
                try readPosAdvance(by: 1)
                data = try readData()
            }
    
            return .sysEx7(
                .init(
                    manufacturer: manufacturer,
                    data: data,
                    group: group
                )
            )
    
        default:
            // malformed
            throw ParseError.malformed
        }
    }
    
    /// Parse a complete raw MIDI 1.0 System Exclusive 7 message in the form of a hex string and return a `.sysEx7()` or `.universalSysEx7()` case if successful.
    /// Message must begin with `F0` but terminating `F7` byte is optional.
    ///
    /// Hex string may be formatted with (`"F7 01 02 03 F0"`) or without spaces (`"F7010203F0"`). String is case-insensitive.
    ///
    /// - Throws: `MIDIEvent.ParseError` if message is malformed.
    public static func sysEx7<S: StringProtocol>(
        rawHexString: S,
        group: UInt4 = 0
    ) throws -> Self {
        // basic string sanitation and split into character pairs
        let hexStrings = rawHexString
            .removing(.whitespacesAndNewlines)
            .split(every: 2)
    
        // ensure all elements are a character pair
        guard !hexStrings.isEmpty,
              hexStrings.last?.count == 2
        else {
            throw ParseError.malformed
        }
    
        // map to integers
        let conditionalBytes = hexStrings
            .map { Byte($0, radix: 16) }
    
        // ensure values successfully converted (all valid hex strings)
        guard conditionalBytes.allSatisfy({ $0 != nil })
        else {
            throw ParseError.malformed
        }
    
        let bytes = conditionalBytes
            .compactMap { $0 }
    
        // parse bytes as normal
        return try sysEx7(
            rawBytes: bytes,
            group: group
        )
    }
}
