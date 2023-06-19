//
//  SysEx7.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Exclusive: Manufacturer-specific (7-bit)
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > - Receivers should ignore non-universal Exclusive messages with ID numbers that do not
    /// > correspond to their own ID.
    /// >
    /// > - Any manufacturer of MIDI hardware or software may use the system exclusive codes of any
    /// > existing product without the permission of the original manufacturer. However, they may
    /// > not modify or extend it in any way that conflicts with the original specification
    /// > published by the designer. Once published, an Exclusive format is treated like any other
    /// > part of the instruments MIDI implementation — so long as the new instrument remains within
    /// > the definitions of the published specification.
    public struct SysEx7: Equatable, Hashable {
        /// SysEx Manufacturer ID
        public var manufacturer: SysExManufacturer
    
        /// Data bytes (7-bit) (excluding leading 0xF0, trailing 0xF7 and manufacturer bytes)
        public var data: [UInt8]
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
        
        /// - Throws: ``MIDIEvent/ParseError`` if any data bytes overflow 7 bits.
        public init(
            manufacturer: MIDIEvent.SysExManufacturer,
            data: [UInt8],
            group: UInt4 = 0x0
        ) throws {
            self.manufacturer = manufacturer
            
            // data must all be 7-bit bytes,
            // but we make the array [UInt8] instead of [UInt7] to reduce friction
            guard data.allSatisfy({ $0 < 0x80 }) else {
                throw ParseError.malformed
            }
            self.data = data
            
            self.group = group
        }
        
        @_disfavoredOverload
        public init(
            manufacturer: MIDIEvent.SysExManufacturer,
            data: [UInt7],
            group: UInt4 = 0x0
        ) {
            self.manufacturer = manufacturer
            self.data = data.map(\.uInt8Value)
            
            self.group = group
        }
    }
    
    /// System Exclusive: Manufacturer-specific (7-bit)
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Receivers should ignore non-universal Exclusive messages with ID numbers that do not
    /// > correspond to their own ID.
    /// >
    /// > Any manufacturer of MIDI hardware or software may use the system exclusive codes of any
    /// > existing product without the permission of the original manufacturer. However, they may
    /// > not modify or extend it in any way that conflicts with the original specification
    /// > published by the designer. Once published, an Exclusive format is treated like any other
    /// > part of the instruments MIDI implementation — so long as the new instrument remains within
    /// > the definitions of the published specification.
    ///
    /// - Parameters:
    ///   - manufacturer: SysEx Manufacturer ID
    ///   - data: Data bytes (7-bit)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    ///
    /// - Throws: ``ParseError`` if any data bytes overflow 7 bits.
    public static func sysEx7(
        manufacturer: SysExManufacturer,
        data: [UInt8],
        group: UInt4 = 0x0
    ) throws -> Self {
        try .sysEx7(
            .init(
                manufacturer: manufacturer,
                data: data,
                group: group
            )
        )
    }
    
    /// System Exclusive: Manufacturer-specific (7-bit)
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Receivers should ignore non-universal Exclusive messages with ID numbers that do not
    /// > correspond to their own ID.
    /// >
    /// > Any manufacturer of MIDI hardware or software may use the system exclusive codes of any
    /// > existing product without the permission of the original manufacturer. However, they may
    /// > not modify or extend it in any way that conflicts with the original specification
    /// > published by the designer. Once published, an Exclusive format is treated like any other
    /// > part of the instruments MIDI implementation — so long as the new instrument remains within
    /// > the definitions of the published specification.
    ///
    /// - Parameters:
    ///   - manufacturer: SysEx Manufacturer ID
    ///   - data: Data bytes (7-bit)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    @_disfavoredOverload
    public static func sysEx7(
        manufacturer: SysExManufacturer,
        data: [UInt7],
        group: UInt4 = 0x0
    ) -> Self {
        .sysEx7(
            .init(
                manufacturer: manufacturer,
                data: data,
                group: group
            )
        )
    }
}

extension MIDIEvent.SysEx7 {
    /// Returns the raw MIDI 1.0 message bytes that comprise the event as a human-readable string of
    /// hex characters.
    ///
    /// By default the string is returned separated by spaces (ie: `"F7 01 02 03 F0"`).
    ///
    /// A custom separator may be used or pass `nil` for no separator (ie: `"F7010203F0"`).
    public func midi1RawHexString(
        leadingF0: Bool = true,
        trailingF7: Bool = true,
        separator: String? = " "
    ) -> String {
        let bytes = midi1RawBytes(
            leadingF0: leadingF0,
            trailingF7: trailingF7
        )
    
        if let separator = separator {
            return bytes.hexString(padEachTo: 2, prefixes: false, separator: separator)
        } else {
            return bytes.hexString(padEachTo: 2, prefixes: false, separator: "")
        }
    }
}

extension MIDIEvent.SysEx7 {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xF0
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes(
        leadingF0: Bool = true,
        trailingF7: Bool = true
    ) -> [UInt8] {
        (leadingF0 ? [0xF0] : [])
            + manufacturer.sysEx7RawBytes()
            + data
            + (trailingF7 ? [0xF7] : [])
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// Generates one or more 64-bit UMP packets depending on the system exclusive data length (each
    /// packet comprised of two UInt32 words).
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [[UMPWord]] {
        let rawData = manufacturer.sysEx7RawBytes() + data
    
        return Self.umpRawWords(
            fromSysEx7Data: rawData,
            group: group
        )
    }
}

extension MIDIEvent.SysEx7 {
    /// Internal:
    /// Helper method to build the raw UMP packet words. This is not meant to be accessed directly;
    /// use the public `umpRawWords()` method instead.
    internal static func umpRawWords(
        fromSysEx7Data data: [UInt8],
        group: UInt4
    ) -> [[UMPWord]] {
        let maxDataBytesPerPacket = 6
    
        let umpMessageType: MIDIUMPMessageType = .data64bit
    
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group.uInt8Value
    
        func rawDataOrNull(_ offset: Int) -> UInt8 {
            guard data.count > offset else { return 0x00 }
            return data[data.startIndex.advanced(by: offset)]
        }
    
        var rawDataByteCountRemaining: Int { data.count - rawDataPosition }
    
        var rawDataPosition = 0
        var packets: [[UMPWord]] = []
    
        while rawDataPosition < data.count {
            let status: MIDIUMPSysExStatusField
            switch rawDataPosition {
            case 0:
                status = rawDataByteCountRemaining <= maxDataBytesPerPacket ? .complete : .start
            case maxDataBytesPerPacket...:
                status = rawDataByteCountRemaining <= maxDataBytesPerPacket ? .end : .continue
            default:
                assertionFailure("Unexpected raw data position index.")
                return []
            }
    
            let statusByte = status.rawValue.uInt8Value << 4
    
            let packetDataBytes = rawDataByteCountRemaining.clamped(to: 0 ... maxDataBytesPerPacket)
    
            let word1 = UMPWord(
                mtAndGroup,
                statusByte + UInt8(packetDataBytes),
                rawDataOrNull(rawDataPosition + 0),
                rawDataOrNull(rawDataPosition + 1)
            )
    
            let word2 = UMPWord(
                rawDataOrNull(rawDataPosition + 2),
                rawDataOrNull(rawDataPosition + 3),
                rawDataOrNull(rawDataPosition + 4),
                rawDataOrNull(rawDataPosition + 5)
            )
    
            packets.append([word1, word2])
            rawDataPosition += packetDataBytes
        }
    
        return packets
    }
}
