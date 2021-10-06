//
//  UniversalSysEx.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Exclusive: Universal SysEx
    /// (MIDI 1.0 / 2.0)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of 0x7F indicates "All Devices".
    public struct UniversalSysEx: Equatable, Hashable {
        
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
        
        /// Data bytes
        public var data: [MIDI.Byte]
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// System Exclusive: Universal SysEx
    /// (MIDI 1.0 / 2.0)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - Parameters:
    ///   - universalType: Universal SysEx type: realtime or non-realtime
    ///   - deviceID: `0x7F` indicates "All Devices"
    ///   - subID1: Sub ID #1
    ///   - subID2: Sub ID #2
    ///   - data: Data bytes
    ///   - group: UMP Group (0x0...0xF)
    public static func universalSysEx(universalType: UniversalSysExType,
                                      deviceID: MIDI.UInt7,
                                      subID1: MIDI.UInt7,
                                      subID2: MIDI.UInt7,
                                      data: [MIDI.Byte],
                                      group: MIDI.UInt4 = 0x0) -> Self {

        .universalSysEx(
            .init(universalType: universalType,
                  deviceID: deviceID,
                  subID1: subID1,
                  subID2: subID2,
                  data: data,
                  group: group)
        )

    }
    
}

extension MIDI.Event.UniversalSysEx {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xF0,
         MIDI.Byte(universalType.rawValue),
         deviceID.uInt8Value,
         subID1.uInt8Value,
         subID2.uInt8Value]
            + data
            + [0xF7]
        
    }
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .data64bit
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        #warning("> TODO: umpRawWords() needs coding")
        _ = mtAndGroup
        
        return []
        
    }
    
}
