//
//  JRTimestamp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// JR Timestamp (Jitter-Reduction Timestamp)
    /// (MIDI 2.0 Utility Messages)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > The JR Timestamp message defines the time of the following message(s). It is a complete
    /// > message.
    /// >
    /// > A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1
    /// > MHz / 32).
    public struct JRTimestamp: Equatable, Hashable {
        /// 16-Bit Time Value
        ///
        /// > MIDI 2.0 Spec:
        /// >
        /// > The JR Timestamp message defines the time of the following message(s). It is a
        /// > complete message.
        /// >
        /// > A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency
        /// > of 1 MHz / 32).
        public var time: UInt16
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        /// JR Timestamp (Jitter-Reduction Timestamp)
        /// (MIDI 2.0 Utility Messages)
        ///
        /// > MIDI 2.0 Spec:
        /// >
        /// > The JR Timestamp message defines the time of the following message(s). It is a
        /// > complete message.
        /// >
        /// > A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency
        /// > of 1 MHz / 32).
        public init(
            time: UInt16,
            group: UInt4 = 0x0
        ) {
            self.time = time
            self.group = group
        }
    }
    
    /// JR Timestamp (Jitter-Reduction Timestamp)
    /// (MIDI 2.0 Utility Messages)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > The JR Timestamp message defines the time of the following message(s). It is a complete
    /// > message.
    /// >
    /// > A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1
    /// > MHz / 32).
    public static func jrTimestamp(
        time: UInt16,
        group: UInt4 = 0x0
    ) -> Self {
        .jrTimestamp(
            .init(
                time: time,
                group: group
            )
        )
    }
}

extension MIDIEvent.JRTimestamp {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: MIDIUMPMessageType = .utility
    
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group.uInt8Value
    
        let utilityStatus: MIDIUMPUtilityStatusField = .jrTimestamp
    
        // MIDI 2.0 only
    
        let timeBytes = BytePair(time)
    
        let word = UMPWord(
            mtAndGroup,
            (utilityStatus.rawValue.uInt8Value << 4) + 0x0,
            timeBytes.msb,
            timeBytes.lsb
        )
    
        return [word]
    }
}
