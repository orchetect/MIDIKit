//
//  SystemReset.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Real-Time: System Reset
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > System Reset commands all devices in a system to return to their initialized, power-up
    /// > condition. This message should be used sparingly, and should typically be sent by manual
    /// > control only. It should not be sent automatically upon power-up and under no condition
    /// > should this message be echoed.
    public struct SystemReset: Equatable, Hashable {
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(group: UInt4 = 0x0) {
            self.group = group
        }
    }
    
    /// System Real-Time: System Reset
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > System Reset commands all devices in a system to return to their initialized, power-up
    /// > condition. This message should be used sparingly, and should typically be sent by manual
    /// > control only. It should not be sent automatically upon power-up and under no condition
    /// > should this message be echoed.
    ///
    /// - Parameters:
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func systemReset(group: UInt4 = 0x0) -> Self {
        .systemReset(
            .init(group: group)
        )
    }
}

extension MIDIEvent.SystemReset {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xFF
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
