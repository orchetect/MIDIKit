//
//  MIDIUMPUtilityStatusField.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet SysEx Status Field
public enum MIDIUMPUtilityStatusField: UInt4 {
    /// NOOP (No Operation)
    case noOp = 0x0
    
    /// JR Clock (Jitter-Reduction Clock)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > The JR Clock message defines the current time of the Sender.
    /// >
    /// > A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1
    /// > MHz / 32).
    /// >
    /// > The time value is expected to wrap around every 2.09712 seconds.
    /// >
    /// > To avoid ambiguity of the 2.09712 seconds wrap, and to provide sufficient JR Clock
    /// > messages for the Receiver, the Sender shall send a JR Clock message at least once every
    /// > 250 milliseconds.
    case jrClock = 0x1
    
    /// JR Timestamp (Jitter-Reduction Timestamp)
    ///
    /// > MIDI 2.0 Spec:
    /// >
    /// > The JR Timestamp message defines the time of the following message(s). It is a complete
    /// > message.
    /// >
    /// > A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1
    /// > MHz / 32).
    case jrTimestamp = 0x2
    
    // 0x3... are unused/reserved
}

extension MIDIUMPUtilityStatusField: Equatable { }

extension MIDIUMPUtilityStatusField: Hashable { }

extension MIDIUMPUtilityStatusField: CaseIterable { }

extension MIDIUMPUtilityStatusField: Sendable { }
