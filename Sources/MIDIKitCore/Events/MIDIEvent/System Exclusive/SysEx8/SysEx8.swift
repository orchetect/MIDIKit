//
//  SysEx8.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Exclusive: Manufacturer-specific (8-bit)
    /// (MIDI 2.0 only)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > System Exclusive 8 messages have many similarities to the MIDI 1.0 Protocol’s original
    /// > System Exclusive messages, but with the added advantage of allowing all 8 bits of each
    /// > data byte to be used. By contrast, MIDI 1.0 Protocol System Exclusive requires a 0 in the
    /// > high bit of every data byte, leaving only 7 bits to carry actual data. A System Exclusive
    /// > 8 Message is carried in one or more 128-bit UMPs.
    public struct SysEx8 {
        /// SysEx Manufacturer ID
        public var manufacturer: SysExManufacturer
        
        /// Data bytes (8-bit) (excluding leading 0xF0, trailing 0xF7 and stream ID)
        ///
        /// > MIDI 2.0 Spec:
        /// >
        /// > System Exclusive 8 initial data bytes are the same as those found in MIDI 1.0 Protocol
        /// > System Exclusive messages. These bytes are Manufacturer ID (including Special ID
        /// > `0x7D`, or Universal System Exclusive IDs), Device ID, and Sub-ID#1 & Sub-ID#2 (if
        /// > applicable).
        public var data: [UInt8]
        
        /// Interleaving of multiple simultaneous System Exclusive 8 messages is enabled by use of
        /// an 8-bit Stream ID field.
        var streamID: UInt8 = 0x00
        
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
        
        public init(
            manufacturer: SysExManufacturer,
            data: [UInt8],
            group: UInt4 = 0x0
        ) {
            self.manufacturer = manufacturer
            self.data = data
            self.group = group
        }
        
        init(
            manufacturer: SysExManufacturer,
            data: [UInt8],
            streamID: UInt8,
            group: UInt4 = 0x0
        ) {
            self.manufacturer = manufacturer
            self.data = data
            self.streamID = streamID
            self.group = group
        }
    }
}

extension MIDIEvent.SysEx8: Equatable { }

extension MIDIEvent.SysEx8: Hashable { }

extension MIDIEvent.SysEx8: Sendable { }

extension MIDIEvent {
    /// System Exclusive: Manufacturer-specific (8-bit)
    /// (MIDI 2.0 only)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > System Exclusive 8 messages have many similarities to the MIDI 1.0 Protocol’s original
    /// > System Exclusive messages, but with the added advantage of allowing all 8 bits of each
    /// > data byte to be used. By contrast, MIDI 1.0 Protocol System Exclusive requires a 0 in the
    /// > high bit of every data byte, leaving only 7 bits to carry actual data. A System Exclusive
    /// > 8 Message is carried in one or more 128-bit UMPs.
    ///
    /// - Parameters:
    ///   - manufacturer: SysEx Manufacturer ID
    ///   - data: Data bytes (8-bit)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func sysEx8(
        manufacturer: SysExManufacturer,
        data: [UInt8],
        group: UInt4 = 0x0
    ) -> Self {
        .sysEx8(
            .init(
                manufacturer: manufacturer,
                data: data,
                group: group
            )
        )
    }
}

extension MIDIEvent.SysEx8 {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// Generates one or more 64-bit UMP packets depending on the system exclusive data length (each
    /// packet comprised of two UInt32 words).
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    ///   of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [[UMPWord]] {
        let rawData = manufacturer.sysEx8RawBytes() + data
    
        return Self.umpRawWords(
            fromSysEx8Data: rawData,
            streamID: streamID,
            group: group
        )
    }
}

extension MIDIEvent.SysEx8 {
    /// Internal:
    /// Helper method to build the raw UMP packet words. This is not meant to be accessed directly;
    /// use the public ``umpRawWords()`` method instead.
    static func umpRawWords(
        fromSysEx8Data data: [UInt8],
        streamID: UInt8,
        group: UInt4
    ) -> [[UMPWord]] {
        let maxDataBytesPerPacket = 13
    
        let umpMessageType: MIDIUMPMessageType = .data128bit
    
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
                statusByte + UInt8(packetDataBytes + 1), // incl. streamID byte
                streamID,
                rawDataOrNull(rawDataPosition + 0)
            )
    
            let word2 = UMPWord(
                rawDataOrNull(rawDataPosition + 1),
                rawDataOrNull(rawDataPosition + 2),
                rawDataOrNull(rawDataPosition + 3),
                rawDataOrNull(rawDataPosition + 4)
            )
    
            let word3 = UMPWord(
                rawDataOrNull(rawDataPosition + 5),
                rawDataOrNull(rawDataPosition + 6),
                rawDataOrNull(rawDataPosition + 7),
                rawDataOrNull(rawDataPosition + 8)
            )
    
            let word4 = UMPWord(
                rawDataOrNull(rawDataPosition + 9),
                rawDataOrNull(rawDataPosition + 10),
                rawDataOrNull(rawDataPosition + 11),
                rawDataOrNull(rawDataPosition + 12)
            )
    
            packets.append([word1, word2, word3, word4])
            rawDataPosition += packetDataBytes
        }
    
        return packets
    }
}
