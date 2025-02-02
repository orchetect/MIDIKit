//
//  NoOp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// NOOP - No Operation
    /// (MIDI 2.0 Utility Messages)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > The UMP Format provides a set of Utility Messages. Utility Messages include but are not
    /// > limited to NOOP and timestamps, and might in the future include UMP transport-related
    /// > functions.
    public struct NoOp {
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
        
        public init(group: UInt4 = 0x0) {
            self.group = group
        }
    }
}

extension MIDIEvent.NoOp: Equatable { }

extension MIDIEvent.NoOp: Hashable { }

extension MIDIEvent.NoOp: Sendable { }

extension MIDIEvent {
    /// NOOP - No Operation
    /// (MIDI 2.0 Utility Messages)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > The UMP Format provides a set of Utility Messages. Utility Messages include but are not
    /// > limited to NOOP and timestamps, and might in the future include UMP transport-related
    /// > functions.
    ///
    /// - Parameters:
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func noOp(group: UInt4 = 0x0) -> Self {
        .noOp(
            .init(group: group)
        )
    }
}

extension MIDIEvent.NoOp {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    ///   of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: MIDIUMPMessageType = .utility
    
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group.uInt8Value
    
        let utilityStatus: MIDIUMPUtilityStatusField = .noOp
    
        // MIDI 2.0 only
    
        let word = UMPWord(
            mtAndGroup,
            (utilityStatus.rawValue.uInt8Value << 4) + 0x0,
            0x00,
            0x00
        )
    
        return [word]
    }
}
