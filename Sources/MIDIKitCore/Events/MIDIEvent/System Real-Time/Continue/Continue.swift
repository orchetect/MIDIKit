//
//  Continue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Real-Time: Continue
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Continue (`0xFB`) is sent when a CONTINUE button is hit. A sequence will continue from its
    /// > current location upon receipt of the next Timing Clock (`0xF8`).
    public struct Continue: Equatable, Hashable {
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(group: UInt4 = 0x0) {
            self.group = group
        }
    }
    
    /// System Real-Time: Continue
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Continue (`0xFB`) is sent when a CONTINUE button is hit. A sequence will continue from its
    /// > current location upon receipt of the next Timing Clock (`0xF8`).
    ///
    /// - Parameters:
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func `continue`(group: UInt4 = 0x0) -> Self {
        .continue(
            .init(group: group)
        )
    }
}

extension MIDIEvent.Continue {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xFB
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
