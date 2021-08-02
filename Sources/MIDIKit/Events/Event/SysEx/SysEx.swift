//
//  SysEx.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Exclusive Message
    ///
    /// Standard MIDI 1.0 Spec:
    ///
    /// "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
    ///
    /// "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
    public enum SysEx: Equatable, Hashable {
        
        static func parsed(from rawBytes: [MIDI.Byte]) throws -> MIDI.Event {
            
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
            let idByte1 = rawBytes[readPos]
            
            switch idByte1 {
            case 0x7E, 0x7F:
                // universal sys ex
                
                let universalType = UniversalType(rawValue: idByte1)!
                
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
                
                return .sysExUniversal(universalType: universalType,
                                       deviceID: deviceID,
                                       subID1: subID1,
                                       subID2: subID2,
                                       data: data)
                
            case 0x00...0x7D:
                var readManufacturer: Manufacturer?
                
                switch idByte1 {
                case 0x00:
                    // 3-byte ID; 0x00 means 2 bytes will follow
                    try readPosAdvance(by: 1)
                    let idByte2 = rawBytes[readPos]
                    try readPosAdvance(by: 1)
                    let idByte3 = rawBytes[readPos]
                    readManufacturer = Manufacturer(threeByte: (idByte2, idByte3))
                    
                case 0x01...0x7D:
                    // 1-byte ID
                    readManufacturer = Manufacturer(oneByte: idByte1)
                    
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
                
                return .sysEx(manufacturer: manufacturer,
                              data: data)
                
            default:
                // malformed
                throw ParseError.malformed
            }
            
        }
        
    }
    
}
