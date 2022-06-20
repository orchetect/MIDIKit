//
//  SysEx Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    /// Parse a complete raw MIDI 1.0 System Exclusive 7 message and return a `.sysEx7()` or `.universalSysEx7()` case if successful.
    /// Message must begin with 0xF0 but terminating 0xF7 byte is optional.
    ///
    /// - Throws: `MIDI.Event.ParseError` if message is malformed.
    @inline(__always)
    public static func sysEx7(
        rawBytes: [MIDI.Byte],
        group: MIDI.UInt4 = 0
    ) throws -> Self {
        
        var readPos = rawBytes.startIndex
        
        func readPosAdvance(by: Int) throws {
            let newPos = readPos + by
            guard readPos + by < rawBytes.endIndex else {
                throw ParseError.malformed
            }
            readPos = newPos
        }
        
        func readData() throws -> [MIDI.Byte] {
            let actualEndIndex = rawBytes.endIndex.advanced(by: -1)
            
            var dataBytes: [MIDI.Byte] = []
            let bytesRemaining = actualEndIndex - readPos
            dataBytes.reserveCapacity(bytesRemaining)
            
            for idx in readPos...actualEndIndex {
                let byte = rawBytes[idx]
                if byte == 0xF7 && idx == actualEndIndex {
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
        guard let idByte1 = MIDI.UInt7(exactly: rawBytes[readPos]) else {
            throw ParseError.malformed
        }
        
        switch idByte1 {
        case 0x7E, 0x7F:
            // universal sys ex
            
            guard let universalType = UniversalSysExType(rawValue: idByte1) else {
                throw ParseError.malformed
            }
            
            try readPosAdvance(by: 1)
            guard let deviceID = MIDI.UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
            
            try readPosAdvance(by: 1)
            guard let subID1 = MIDI.UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
            
            try readPosAdvance(by: 1)
            guard let subID2 = MIDI.UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
            
            try readPosAdvance(by: 1)
            let data = try readData()
            
            return .universalSysEx7(
                .init(universalType: universalType,
                      deviceID: deviceID,
                      subID1: subID1,
                      subID2: subID2,
                      data: data,
                      group: group)
            )
            
        case 0x00...0x7D:
            var readManufacturer: SysExManufacturer?
            
            switch idByte1 {
            case 0x00:
                // 3-byte ID; 0x00 means 2 bytes will follow
                try readPosAdvance(by: 1)
                guard let idByte2 = MIDI.UInt7(exactly: rawBytes[readPos]) else {
                    throw ParseError.malformed
                }
                
                try readPosAdvance(by: 1)
                guard let idByte3 = MIDI.UInt7(exactly: rawBytes[readPos]) else {
                    throw ParseError.malformed
                }
                
                readManufacturer = .threeByte(byte2: idByte2, byte3: idByte3)
                
            case 0x01...0x7D:
                // 1-byte ID
                readManufacturer = .oneByte(idByte1)
                
            default:
                break // will never happen
            }
            
            guard let manufacturer = readManufacturer
            else { throw ParseError.malformed }
            
            var data: [MIDI.Byte] = []
            
            let actualEndIndex = rawBytes.endIndex.advanced(by: -1)
            if readPos < actualEndIndex {
                try readPosAdvance(by: 1)
                data = try readData()
            }
            
            return .sysEx7(
                .init(manufacturer: manufacturer,
                      data: data,
                      group: group)
            )
            
        default:
            // malformed
            throw ParseError.malformed
        }
        
    }
    
    /// Parse a complete MIDI 2.0 System Exclusive 8 message (starting with the Stream ID byte until the end of the packet) and return a `.sysEx8()` or `.universalSysEx8()` case if successful.
    ///
    /// Valid rawBytes count is 1...14. (Must always contain a Stream ID, even if there are zero data bytes to follow)
    ///
    /// - Throws: `MIDI.Event.ParseError` if message is malformed.
    @inline(__always)
    public static func sysEx8(
        rawBytes: [MIDI.Byte],
        group: MIDI.UInt4 = 0
    ) throws -> Self {
        
        var readPos = rawBytes.startIndex
        
        func readPosAdvance(by: Int) throws {
            let newPos = readPos + by
            guard readPos + by < rawBytes.endIndex else {
                throw ParseError.malformed
            }
            readPos = newPos
        }
        
        func readData() -> [MIDI.Byte] {
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
        case .universal(let universalType):
            try readPosAdvance(by: 1)
            guard let deviceID = MIDI.UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
            
            try readPosAdvance(by: 1)
            guard let subID1 = MIDI.UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
            
            try readPosAdvance(by: 1)
            guard let subID2 = MIDI.UInt7(exactly: rawBytes[readPos])
            else { throw ParseError.malformed }
            
            let data: [MIDI.Byte] = {
                if nil != (try? readPosAdvance(by: 1)) {
                    return readData()
                } else {
                    return []
                }
            }()
            
            return .universalSysEx8(
                .init(universalType: universalType,
                      deviceID: deviceID,
                      subID1: subID1,
                      subID2: subID2,
                      data: data,
                      streamID: streamID,
                      group: group)
            )
            
        case .manufacturer(let mfr):
            var data: [MIDI.Byte] = []
            
            let actualEndIndex = rawBytes.endIndex.advanced(by: -1)
            if readPos < actualEndIndex {
                if nil != (try? readPosAdvance(by: 1)) {
                    data = readData()
                }
            }
            
            return .sysEx8(
                .init(manufacturer: mfr,
                      data: data,
                      streamID: streamID,
                      group: group)
            )
            
        default:
            // malformed
            throw ParseError.malformed
        }
        
    }
    
}

// MARK: - API Transition (release 0.4.12)

extension MIDI.Event {
    
    /// Parse a complete raw MIDI 1.0 System Exclusive 7 message and return a `.sysEx7()` or `.universalSysEx7()` case if successful.
    /// Message must begin with 0xF0 but terminating 0xF7 byte is optional.
    ///
    /// - Throws: `MIDI.Event.ParseError` if message is malformed.
    @available(*, unavailable, renamed: "Event.sysEx7(rawBytes:group:)")
    @inline(__always)
    public init(
        sysEx7RawBytes rawBytes: [MIDI.Byte],
        group: MIDI.UInt4 = 0
    ) throws {
        
        let sysEx = try Self.sysEx7(rawBytes: rawBytes,
                                    group: group)
        
        self = sysEx
        
    }
    
    /// Parse a complete MIDI 2.0 System Exclusive 8 message (starting with the Stream ID byte until the end of the packet) and return a `.sysEx8()` or `.universalSysEx8()` case if successful.
    ///
    /// Valid rawBytes count is 1...14. (Must always contain a Stream ID, even if there are zero data bytes to follow)
    ///
    /// - Throws: `MIDI.Event.ParseError` if message is malformed.
    @available(*, unavailable, renamed: "Event.sysEx8(rawBytes:group:)")
    @inline(__always)
    public init(
        sysEx8RawBytes rawBytes: [MIDI.Byte],
        group: MIDI.UInt4 = 0
    ) throws {
        
        let sysEx = try Self.sysEx8(rawBytes: rawBytes,
                                    group: group)
        
        self = sysEx
        
    }
    
}
