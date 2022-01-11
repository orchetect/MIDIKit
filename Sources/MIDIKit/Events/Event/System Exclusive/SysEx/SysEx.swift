//
//  SysEx.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Exclusive: Manufacturer-specific
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// - "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
    ///
    /// - "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
    public struct SysEx: Equatable, Hashable {
        
        /// SysEx Manufacturer ID
        public var manufacturer: SysExManufacturer
        
        /// Data bytes (excluding leading 0xF0, trailing 0xF7 and manufacturer bytes)
        public var data: [MIDI.Byte]
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(manufacturer: MIDI.Event.SysExManufacturer,
                    data: [MIDI.Byte],
                    group: MIDI.UInt4 = 0x0) {
            
            self.manufacturer = manufacturer
            self.data = data
            self.group = group
            
        }
        
    }
    
    /// System Exclusive: Manufacturer-specific
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
    ///
    /// "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
    ///
    /// - Parameters:
    ///   - manufacturer: SysEx Manufacturer ID
    ///   - data: Data bytes
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func sysEx(manufacturer: SysExManufacturer,
                             data: [MIDI.Byte],
                             group: MIDI.UInt4 = 0x0) -> Self {
        
        .sysEx(
            .init(manufacturer: manufacturer,
                  data: data,
                  group: group)
        )
        
    }
    
}

extension MIDI.Event.SysEx {
    
    @inline(__always)
    public func midi1RawBytes(
        leadingF0: Bool = true,
        trailingF7: Bool = true
    ) -> [MIDI.Byte] {
        
        (leadingF0 ? [0xF0] : [])
        + manufacturer.bytes
        + data
        + (trailingF7 ? [0xF7] : [])
        
    }
    
    /// Generates one or more 64-bit UMP packets depending on the system exclusive data length (each packet comprised of two UInt32 words).
    @inline(__always)
    public func umpRawWords() -> [[MIDI.UMPWord]] {
        
        let rawData = manufacturer.bytes + data
        
        return Self.umpRawWords(fromSysEx7Data: rawData,
                                group: group)
        
    }
    
}

extension MIDI.Event.SysEx {
    
    @inline(__always)
    internal static func umpRawWords(fromSysEx7Data data: [MIDI.Byte],
                                     group: MIDI.UInt4) -> [[MIDI.UMPWord]] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .data64bit
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        func rawDataOrNull(_ offset: Int) -> MIDI.Byte {
            guard data.count > offset else { return 0x00 }
            return data[data.startIndex.advanced(by: offset)]
        }
        
        var rawDataByteCountRemaining: Int { data.count - rawDataPosition }
        
        var rawDataPosition = 0
        var packets: [[MIDI.UMPWord]] = []
        
        while rawDataPosition < data.count {
            
            let status: MIDI.Packet.UniversalPacketData.SysExStatusField
            switch rawDataPosition {
            case 0:
                status = rawDataByteCountRemaining < 7 ? .complete : .start
            case 6...:
                status = rawDataByteCountRemaining < 7 ? .end : .continue
            default:
                assertionFailure("Unexpected raw data position index.")
                return []
            }
            
            let statusByte = status.rawValue.uInt8Value << 4
            
            let packetDataBytes = rawDataByteCountRemaining.clamped(to: 0...6)
            
            let word1 = MIDI.UMPWord(mtAndGroup,
                                     statusByte + UInt8(packetDataBytes),
                                     rawDataOrNull(rawDataPosition + 0),
                                     rawDataOrNull(rawDataPosition + 1))
            
            let word2 = MIDI.UMPWord(rawDataOrNull(rawDataPosition + 2),
                                     rawDataOrNull(rawDataPosition + 3),
                                     rawDataOrNull(rawDataPosition + 4),
                                     rawDataOrNull(rawDataPosition + 5))
            
            packets.append([word1, word2])
            rawDataPosition += packetDataBytes
            
        }
        
        return packets
        
    }
    
}
