//
//  ActiveSensing.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Real-Time: Active Sensing
    /// (MIDI 1.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Use of Active Sensing is optional for either receivers or transmitters. This byte (`0xFE`)
    /// > is sent every 300 ms (maximum) whenever there is no other MIDI data being transmitted. If
    /// > a device never receives Active Sensing it should operate normally. However, once the
    /// > receiver recognizes Active Sensing (`0xFE`), it then will expect to get a message of some
    /// > kind every 300 milliseconds. If no messages are received within this time period the
    /// > receiver will assume the MIDI cable has been disconnected for some reason and should turn
    /// > off all voices and return to normal operation. It is recommended that transmitters
    /// > transmit Active Sensing within 270ms and receivers judge at over 330ms leaving a margin of
    /// > roughly 10%.
    ///
    /// - Note: Use of Active Sensing in modern MIDI devices is uncommon and the use of this
    ///   standard has been deprecated as of MIDI 2.0.
    public struct ActiveSensing: Equatable, Hashable {
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(group: UInt4 = 0x0) {
            self.group = group
        }
    }
    
    /// System Real-Time: Active Sensing
    /// (MIDI 1.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Use of Active Sensing is optional for either receivers or transmitters. This byte (`0xFE`)
    /// > is sent every 300 ms (maximum) whenever there is no other MIDI data being transmitted. If
    /// > a device never receives Active Sensing it should operate normally. However, once the
    /// > receiver recognizes Active Sensing (`0xFE`), it then will expect to get a message of some
    /// > kind every 300 milliseconds. If no messages are received within this time period the
    /// > receiver will assume the MIDI cable has been disconnected for some reason and should turn
    /// > off all voices and return to normal operation. It is recommended that transmitters
    /// > transmit Active Sensing within 270ms and receivers judge at over 330ms leaving a margin of
    /// > roughly 10%.
    ///
    /// - Note: Use of Active Sensing in modern MIDI devices is uncommon and the use of this
    ///   standard has been deprecated as of MIDI 2.0.
    ///
    /// - Parameters:
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func activeSensing(group: UInt4 = 0x0) -> Self {
        .activeSensing(
            .init(group: group)
        )
    }
}

extension MIDIEvent.ActiveSensing {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xFE
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        [midi1RawStatusByte()]
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: MIDIUMPMessageType = .systemRealTimeAndCommon
    
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group.uInt8Value
    
        let word = UMPWord(
            mtAndGroup,
            midi1RawStatusByte(),
            0x00, // pad empty bytes to fill 4 bytes
            0x00
        ) // pad empty bytes to fill 4 bytes
    
        return [word]
    }
}
