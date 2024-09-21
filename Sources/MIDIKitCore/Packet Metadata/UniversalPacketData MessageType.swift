//
//  UniversalPacketData MessageType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet Message Type
public enum MIDIUMPMessageType: UInt4, CaseIterable, Sendable {
    case utility                 = 0x0
    case systemRealTimeAndCommon = 0x1
    case midi1ChannelVoice       = 0x2
    case data64bit               = 0x3
    case midi2ChannelVoice       = 0x4
    case data128bit              = 0x5
    
    // 0x6 ... 0xF are reserved as of MIDI 2.0 spec
}

extension MIDIUMPMessageType {
    /// Returns the number of words associated with the Universal MIDI Packet Message Type.
    ///
    /// - Note: MIDI 2.0 Utility (``utility``) messages themselves are always 1 word, however they
    /// may be followed by additional words that comprise another UMP message since utility messages
    /// can be timestamps that prepend non-utility UMP messages. (For example, a 64-bit channel
    /// voice UMP may be prepended by a 32-bit timestamp UMP to form a 96-bit timestamped message.)
    /// See the MIDI 2.0 Spec for details.
    public var wordLength: Int {
        switch self {
        case .utility: return 1
        case .systemRealTimeAndCommon: return 1
        case .midi1ChannelVoice: return 1
        case .data64bit: return 2
        case .midi2ChannelVoice: return 2
        case .data128bit: return 4
        }
    }
}

/// Universal MIDI Packet SysEx Status Field.
/// Used with both SysEx7 and SysEx8.
public enum MIDIUMPSysExStatusField: UInt4, CaseIterable, Sendable {
    /// Complete System Exclusive Message in one UMP System Exclusive.
    case complete = 0x0
    
    /// System Exclusive Start UMP.
    case start = 0x1
    
    /// System Exclusive Continue UMP.
    /// There might be multiple Continue UMPs in a single message.
    case `continue` = 0x2
    
    /// System Exclusive End UMP.
    case end = 0x3
    
    // 0x4... are unused/reserved
}

/// Universal MIDI Packet Mixed Data Set Status Field.
/// Only meant to be used with SysEx8 Mixed Data Set packets.
public enum MIDIUMPMixedDataSetStatusField: UInt4, CaseIterable, Sendable {
    // 0x0...0x7 are unused/reserved
    
    /// Mixed Data Set Header UMP.
    case header = 0x8
    
    /// Mixed Data Set Payload UMP.
    case payload = 0x9
    
    // 0xA... are unused/reserved
}

/// Universal MIDI Packet SysEx Status Field
public enum MIDIUMPUtilityStatusField: UInt4, CaseIterable, Sendable {
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
