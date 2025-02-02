//
//  AnyMIDIPacket.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// A box that can hold any MIDI packet type.
public enum AnyMIDIPacket {
    /// MIDI 1.0 MIDI Packet.
    case packet(MIDIPacketData)
    
    /// MIDI 2.0 Universal MIDI Packet.
    case universalPacket(UniversalMIDIPacketData)
}

extension AnyMIDIPacket: Equatable { }

extension AnyMIDIPacket: Hashable { }

extension AnyMIDIPacket: Sendable { }

extension AnyMIDIPacket {
    /// Flat array of raw bytes.
    public var bytes: [UInt8] {
        switch self {
        case let .packet(packetData):
            packetData.bytes
            
        case let .universalPacket(universalPacketData):
            universalPacketData.bytes
        }
    }
    
    /// Core MIDI packet timestamp.
    public var timeStamp: CoreMIDITimeStamp {
        switch self {
        case let .packet(packetData):
            packetData.timeStamp
            
        case let .universalPacket(universalPacketData):
            universalPacketData.timeStamp
        }
    }
    
    /// The MIDI endpoint from which the packet originated.
    /// If this information is not available, it may be `nil`.
    public var source: MIDIOutputEndpoint? {
        switch self {
        case let .packet(packetData):
            packetData.source
            
        case let .universalPacket(universalPacketData):
            universalPacketData.source
        }
    }
}

#endif
