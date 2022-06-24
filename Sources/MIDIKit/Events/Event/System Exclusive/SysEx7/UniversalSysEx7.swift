//
//  UniversalSysEx7.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Universal System Exclusive (7-bit)
    /// (MIDI 1.0 / 2.0)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of 0x7F indicates "All Devices".
    public struct UniversalSysEx7: Equatable, Hashable {
        
        /// Universal SysEx type:
        /// realtime or non-realtime
        public var universalType: UniversalSysExType
        
        /// Device ID:
        /// `0x7F` indicates "All Devices"
        public var deviceID: MIDI.UInt7
        
        /// Sub ID #1
        public var subID1: MIDI.UInt7
        
        /// Sub ID #2
        public var subID2: MIDI.UInt7
        
        /// Data bytes (7-bit) (excluding leading 0xF0, trailing 0xF7, universal type and ID bytes)
        public var data: [MIDI.Byte]
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
        public init(universalType: MIDI.Event.UniversalSysExType,
                    deviceID: MIDI.UInt7,
                    subID1: MIDI.UInt7,
                    subID2: MIDI.UInt7,
                    data: [MIDI.Byte],
                    group: MIDI.UInt4 = 0x0) {
            
            self.universalType = universalType
            self.deviceID = deviceID
            self.subID1 = subID1
            self.subID2 = subID2
            self.data = data
            self.group = group
            
        }
        
    }
    
    /// System Exclusive: Universal SysEx (7-bit)
    /// (MIDI 1.0 / 2.0)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - Parameters:
    ///   - universalType: Universal SysEx type: realtime or non-realtime
    ///   - deviceID: `0x7F` indicates "All Devices"
    ///   - subID1: Sub ID #1
    ///   - subID2: Sub ID #2
    ///   - data: Data bytes (7-bit)
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func universalSysEx7(universalType: UniversalSysExType,
                                       deviceID: MIDI.UInt7,
                                       subID1: MIDI.UInt7,
                                       subID2: MIDI.UInt7,
                                       data: [MIDI.Byte],
                                       group: MIDI.UInt4 = 0x0) -> Self {

        .universalSysEx7(
            .init(universalType: universalType,
                  deviceID: deviceID,
                  subID1: subID1,
                  subID2: subID2,
                  data: data,
                  group: group)
        )

    }
    
}

extension MIDI.Event.UniversalSysEx7 {
    
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func midi1RawBytes(
        leadingF0: Bool = true,
        trailingF7: Bool = true
    ) -> [MIDI.Byte] {
        
        (leadingF0 ? [0xF0] : [])
        + [MIDI.Byte(universalType.rawValue),
           deviceID.uInt8Value,
           subID1.uInt8Value,
           subID2.uInt8Value]
        + data
        + (trailingF7 ? [0xF7] : [])
        
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func umpRawWords() -> [[MIDI.UMPWord]] {
        
        let rawData =
        [MIDI.Byte(universalType.rawValue),
         deviceID.uInt8Value,
         subID1.uInt8Value,
         subID2.uInt8Value]
        + data
        
        return MIDI.Event.SysEx7.umpRawWords(fromSysEx7Data: rawData,
                                             group: group)
        
    }
    
}
