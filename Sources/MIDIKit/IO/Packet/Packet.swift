//
//  Packet.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    /// A type that can hold any MIDI packet type.
    public enum Packet {
        /// MIDI 1.0 MIDI Packet
        case packet(PacketData)
        
        /// MIDI 2.0 Universal MIDI Packet
        case universalPacket(UniversalPacketData)
        
        /// Flat array of raw bytes
        @inline(__always)
        public var bytes: [MIDI.Byte] {
            switch self {
            case let .packet(packetData):
                return packetData.bytes
                
            case let .universalPacket(universalPacketData):
                return universalPacketData.bytes
            }
        }
        
        /// Core MIDI packet timestamp
        @inline(__always)
        public var timeStamp: MIDI.IO.TimeStamp {
            switch self {
            case let .packet(packetData):
                return packetData.timeStamp
                
            case let .universalPacket(universalPacketData):
                return universalPacketData.timeStamp
            }
        }
    }
}
