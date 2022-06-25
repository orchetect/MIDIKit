//
//  SysEx8 Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
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