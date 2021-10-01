//
//  ActiveSensing.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// System Real Time: Active Sensing
    /// (MIDI 1.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Use of Active Sensing is optional for either receivers or transmitters. This byte (`0xFE`) is sent every 300 ms (maximum) whenever there is no other MIDI data being transmitted. If a device never receives Active Sensing it should operate normally. However, once the receiver recognizes Active Sensing (`0xFE`), it then will expect to get a message of some kind every 300 milliseconds. If no messages are received within this time period the receiver will assume the MIDI cable has been disconnected for some reason and should turn off all voices and return to normal operation. It is recommended that transmitters transmit Active Sensing within 270ms and receivers judge at over 330ms leaving a margin of roughly 10%."
    ///
    /// - note: Use of Active Sensing in modern MIDI devices is uncommon and the use of this standard has been deprecated as of MIDI 2.0.
    public struct ActiveSensing: Equatable, Hashable {
        
        /// UMP Group (0x0...0xF)
        public var group: MIDI.UInt4 = 0x0
        
    }
    
    /// System Real Time: Active Sensing
    /// (MIDI 1.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "Use of Active Sensing is optional for either receivers or transmitters. This byte (`0xFE`) is sent every 300 ms (maximum) whenever there is no other MIDI data being transmitted. If a device never receives Active Sensing it should operate normally. However, once the receiver recognizes Active Sensing (`0xFE`), it then will expect to get a message of some kind every 300 milliseconds. If no messages are received within this time period the receiver will assume the MIDI cable has been disconnected for some reason and should turn off all voices and return to normal operation. It is recommended that transmitters transmit Active Sensing within 270ms and receivers judge at over 330ms leaving a margin of roughly 10%."
    ///
    /// - note: Use of Active Sensing in modern MIDI devices is uncommon and the use of this standard has been deprecated as of MIDI 2.0.
    ///
    /// - Parameters:
    ///   - group: UMP Group (0x0...0xF)
    public static func activeSensing(group: MIDI.UInt4 = 0x0) -> Self {
        
        .activeSensing(
            .init(group: group)
        )
        
    }
    
}

extension MIDI.Event.ActiveSensing {
    
    public func midi1RawBytes() -> [MIDI.Byte] {
        
        [0xFE]
        
    }
    
    public func umpRawWords() -> [MIDI.UMPWord] {
        
        let umpMessageType: MIDI.Packet.UniversalPacketData.MessageType = .systemRealTimeAndCommon
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        let word = MIDI.UMPWord(mtAndGroup,
                                0xFE,
                                0x00, // pad empty bytes to fill 4 bytes
                                0x00) // pad empty bytes to fill 4 bytes
        
        return [word]
        
    }
    
}
