//
//  UniversalSysEx8.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Universal System Exclusive (8-bit)
    /// (MIDI 2.0 only)
    ///
    /// - `deviceID` of `0x7F` indicates "All Devices".
    public struct UniversalSysEx8: Equatable, Hashable {
        /// Universal SysEx type:
        /// realtime or non-realtime
        public var universalType: UniversalSysExType
    
        /// Device ID:
        /// `0x7F` indicates "All Devices"
        public var deviceID: UInt7
    
        /// Sub ID #1
        public var subID1: UInt7
    
        /// Sub ID #2
        public var subID2: UInt7
    
        /// Data bytes (8-bit) (excluding leading 0xF0, trailing 0xF7, universal type and ID bytes)
        public var data: [UInt8]
    
        /// Interleaving of multiple simultaneous System Exclusive 8 messages is enabled by use of
        /// an 8-bit Stream ID field.
        internal var streamID: UInt8 = 0x00
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(
            universalType: MIDIEvent.UniversalSysExType,
            deviceID: UInt7,
            subID1: UInt7,
            subID2: UInt7,
            data: [UInt8],
            group: UInt4 = 0x0
        ) {
            self.universalType = universalType
            self.deviceID = deviceID
            self.subID1 = subID1
            self.subID2 = subID2
            self.data = data
            self.group = group
        }
    
        internal init(
            universalType: MIDIEvent.UniversalSysExType,
            deviceID: UInt7,
            subID1: UInt7,
            subID2: UInt7,
            data: [UInt8],
            streamID: UInt8,
            group: UInt4 = 0x0
        ) {
            self.universalType = universalType
            self.deviceID = deviceID
            self.subID1 = subID1
            self.subID2 = subID2
            self.data = data
            self.streamID = streamID
            self.group = group
        }
    }
    
    /// System Exclusive: Universal SysEx (8-bit)
    /// (MIDI 2.0 only)
    ///
    /// - Parameters:
    ///   - universalType: Universal SysEx type: realtime or non-realtime
    ///   - deviceID: `0x7F` indicates "All Devices"
    ///   - subID1: Sub ID #1
    ///   - subID2: Sub ID #2
    ///   - data: Data bytes (8-bit)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func universalSysEx8(
        universalType: UniversalSysExType,
        deviceID: UInt7,
        subID1: UInt7,
        subID2: UInt7,
        data: [UInt8],
        group: UInt4 = 0x0
    ) -> Self {
        .universalSysEx8(
            .init(
                universalType: universalType,
                deviceID: deviceID,
                subID1: subID1,
                subID2: subID2,
                data: data,
                group: group
            )
        )
    }
}

extension MIDIEvent.UniversalSysEx8 {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [[UMPWord]] {
        let rawData =
            [
                0x00,
                UInt8(universalType.rawValue),
                deviceID.uInt8Value,
                subID1.uInt8Value,
                subID2.uInt8Value
            ]
            + data
    
        return MIDIEvent.SysEx8.umpRawWords(
            fromSysEx8Data: rawData,
            streamID: streamID,
            group: group
        )
    }
}
