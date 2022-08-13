//
//  JRClock.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDIEvent {
    /// JR Clock (Jitter-Reduction Clock)
    /// (MIDI 2.0 Utility Messages)
    ///
    /// - remark: MIDI 2.0 Spec:
    ///
    /// "The JR Clock message defines the current time of the Sender.
    ///
    /// A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1 MHz / 32).
    ///
    /// The time value is expected to wrap around every 2.09712 seconds.
    ///
    /// To avoid ambiguity of the 2.09712 seconds wrap, and to provide sufficient JR Clock messages for the Receiver, the Sender shall send a JR Clock message at least once every 250 milliseconds."
    public struct JRClock: Equatable, Hashable {
        /// 16-Bit Time Value
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// "A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1 MHz / 32).
        ///
        /// The time value is expected to wrap around every 2.09712 seconds.
        ///
        /// To avoid ambiguity of the 2.09712 seconds wrap, and to provide sufficient JR Clock messages for the Receiver, the Sender shall send a JR Clock message at least once every 250 milliseconds."
        public var time: UInt16
        
        /// UMP Group (0x0...0xF)
        public var group: UInt4 = 0x0
        
        /// JR Clock (Jitter-Reduction Clock)
        /// (MIDI 2.0 Utility Messages)
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// "The JR Clock message defines the current time of the Sender.
        ///
        /// A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1 MHz / 32).
        ///
        /// The time value is expected to wrap around every 2.09712 seconds.
        ///
        /// To avoid ambiguity of the 2.09712 seconds wrap, and to provide sufficient JR Clock messages for the Receiver, the Sender shall send a JR Clock message at least once every 250 milliseconds."
        public init(
            time: UInt16,
            group: UInt4 = 0x0
        ) {
            self.time = time
            self.group = group
        }
    }
    
    /// JR Clock (Jitter-Reduction Clock)
    /// (MIDI 2.0 Utility Messages)
    ///
    /// - remark: MIDI 2.0 Spec:
    ///
    /// "The JR Clock message defines the current time of the Sender.
    ///
    /// A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1 MHz / 32).
    ///
    /// The time value is expected to wrap around every 2.09712 seconds.
    ///
    /// To avoid ambiguity of the 2.09712 seconds wrap, and to provide sufficient JR Clock messages for the Receiver, the Sender shall send a JR Clock message at least once every 250 milliseconds."
    @inline(__always)
    public static func jrClock(
        time: UInt16,
        group: UInt4 = 0x0
    ) -> Self {
        .jrClock(
            .init(
                time: time,
                group: group
            )
        )
    }
}

extension MIDIEvent.JRClock {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: UniversalMIDIPacketData.MessageType = .utility
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        let utilityStatus: UniversalMIDIPacketData.UtilityStatusField = .jrClock
        
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
