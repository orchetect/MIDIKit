//
//  UniversalSysEx8.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Universal System Exclusive (8-bit)
    /// (MIDI 2.0 only)
    ///
    /// - `deviceID` of 0x7F indicates "All Devices".
    public struct UniversalSysEx8: Equatable, Hashable {
        
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
        
        /// Data bytes (8-bit) (excluding leading 0xF0, trailing 0xF7, universal type and ID bytes)
        public var data: [MIDI.Byte]
        
        /// Interleaving of multiple simultaneous System Exclusive 8 messages is enabled by use of an 8-bit Stream ID field.
        internal var streamID: UInt8 = 0x00
        
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
        
        internal init(universalType: MIDI.Event.UniversalSysExType,
                      deviceID: MIDI.UInt7,
                      subID1: MIDI.UInt7,
                      subID2: MIDI.UInt7,
                      data: [MIDI.Byte],
                      streamID: UInt8,
                      group: MIDI.UInt4 = 0x0) {
            
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
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func universalSysEx8(universalType: UniversalSysExType,
                                       deviceID: MIDI.UInt7,
                                       subID1: MIDI.UInt7,
                                       subID2: MIDI.UInt7,
                                       data: [MIDI.Byte],
                                       group: MIDI.UInt4 = 0x0) -> Self {
        
        .universalSysEx8(
            .init(universalType: universalType,
                  deviceID: deviceID,
                  subID1: subID1,
                  subID2: subID2,
                  data: data,
                  group: group)
        )

    }
    
}

extension MIDI.Event.UniversalSysEx8 {
    
    @inline(__always)
    public func umpRawWords() -> [[MIDI.UMPWord]] {
        
        let rawData =
        [0x00,
         MIDI.Byte(universalType.rawValue),
         deviceID.uInt8Value,
         subID1.uInt8Value,
         subID2.uInt8Value]
        + data
        
        return MIDI.Event.SysEx8.umpRawWords(fromSysEx8Data: rawData,
                                             streamID: streamID,
                                             group: group)
        
    }
    
}
