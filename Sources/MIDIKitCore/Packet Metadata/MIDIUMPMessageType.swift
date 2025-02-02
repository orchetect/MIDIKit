//
//  MIDIUMPMessageType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet Message Type
public enum MIDIUMPMessageType: UInt4 {
    case utility                 = 0x0
    case systemRealTimeAndCommon = 0x1
    case midi1ChannelVoice       = 0x2
    case data64bit               = 0x3
    case midi2ChannelVoice       = 0x4
    case data128bit              = 0x5
    
    // 0x6 ... 0xF are reserved as of MIDI 2.0 spec
}

extension MIDIUMPMessageType: Equatable { }

extension MIDIUMPMessageType: Hashable { }

extension MIDIUMPMessageType: CaseIterable { }

extension MIDIUMPMessageType: Sendable { }

extension MIDIUMPMessageType {
    /// Returns the number of words associated with the Universal MIDI Packet Message Type.
    ///
    /// - Note: MIDI 2.0 Utility (``utility``) messages themselves are always 1 word, however they
    ///   may be followed by additional words that comprise another UMP message since utility messages
    ///   can be timestamps that prepend non-utility UMP messages. (For example, a 64-bit channel
    ///   voice UMP may be prepended by a 32-bit timestamp UMP to form a 96-bit timestamped message.)
    ///   See the MIDI 2.0 Spec for details.
    @inlinable
    public var wordLength: Int {
        switch self {
        case .utility: 1
        case .systemRealTimeAndCommon: 1
        case .midi1ChannelVoice: 1
        case .data64bit: 2
        case .midi2ChannelVoice: 2
        case .data128bit: 4
        }
    }
}
