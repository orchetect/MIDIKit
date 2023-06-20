//
//  SongSelect.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Common: Song Select
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Specifies which song or sequence is to be played upon receipt of a Start message in
    /// > sequencers and drum machines capable of holding multiple songs or sequences. This message
    /// > should be ignored if the receiver is not set to respond to incoming Real-Time messages
    /// > (MIDI Sync).
    public struct SongSelect: Equatable, Hashable {
        /// Song Number
        public var number: UInt7
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(
            number: UInt7,
            group: UInt4 = 0x0
        ) {
            self.number = number
            self.group = group
        }
    }
    
    /// System Common: Song Select
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > Specifies which song or sequence is to be played upon receipt of a Start message in
    /// > sequencers and drum machines capable of holding multiple songs or sequences. This message
    /// > should be ignored if the receiver is not set to respond to incoming Real-Time messages
    /// > (MIDI Sync).
    ///
    /// - Parameters:
    ///   - number: Song Number
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func songSelect(
        number: UInt7,
        group: UInt4 = 0x0
    ) -> Self {
        .songSelect(
            .init(
                number: number,
                group: group
            )
        )
    }
}

extension MIDIEvent.SongSelect {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xF3
    }
    
    /// Returns the raw MIDI 1.0 data bytes for the event (excluding status byte).
    public func midi1RawDataBytes() -> UInt8 {
        number.uInt8Value
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        [midi1RawStatusByte(), midi1RawDataBytes()]
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
            midi1RawDataBytes(),
            0x00
        ) // pad an empty byte to fill 4 bytes
    
        return [word]
    }
}
