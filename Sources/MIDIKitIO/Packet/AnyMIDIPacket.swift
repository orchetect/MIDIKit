//
//  AnyMIDIPacket.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// A box that can hold any MIDI packet type.
public enum AnyMIDIPacket {
    /// MIDI 1.0 MIDI Packet
    case packet(MIDIPacketData)
    
    /// MIDI 2.0 Universal MIDI Packet
    case universalPacket(UniversalMIDIPacketData)
    
    /// Flat array of raw bytes
    public var bytes: [UInt8] {
        switch self {
        case let .packet(packetData):
            return packetData.bytes
    
        case let .universalPacket(universalPacketData):
            return universalPacketData.bytes
        }
    }
    
    /// Core MIDI packet timestamp
    public var timeStamp: CoreMIDITimeStamp {
        switch self {
        case let .packet(packetData):
            return packetData.timeStamp
    
        case let .universalPacket(universalPacketData):
            return universalPacketData.timeStamp
        }
    }
}
