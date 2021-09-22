//
//  UniversalSysEx.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Exclusive: Universal SysEx (Status `0xF0`)
    ///
    /// Used in both MIDI 1.0 and 2.0 spec.
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of 0x7F indicates "All Devices".
    public struct UniversalSysEx: Equatable, Hashable {
        
        public var universalType: UniversalSysExType
        
        public var deviceID: MIDI.UInt7
        
        public var subID1: MIDI.UInt7
        
        public var subID2: MIDI.UInt7
        
        public var data: [MIDI.Byte]
        
        public var group: MIDI.UInt4 = 0
        
    }
    
    /// System Exclusive: Universal SysEx (Status `0xF0`)
    ///
    /// Used in both MIDI 1.0 and 2.0 spec.
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - Parameters:
    ///   - universalType: Universal SysEx type: realtime or non-realtime
    ///   - deviceID: `0x7F` indicates "All Devices"
    ///   - subID1: Sub ID #1
    ///   - subID2: Sub ID #2
    ///   - data: Data bytes
    ///   - group: UMP group
    public static func universalSysEx(universalType: UniversalSysExType,
                                      deviceID: MIDI.UInt7,
                                      subID1: MIDI.UInt7,
                                      subID2: MIDI.UInt7,
                                      data: [MIDI.Byte],
                                      group: MIDI.UInt4 = 0) -> Self {

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
    
    #warning("> this needs specializing?")
    public static let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .data64bit
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        #warning("> needs coding")
        
        let mtAndGroup = (Self.umpMessageType.rawValue.uInt8Value << 4) + group
        
        return []
        
    }
    
}
