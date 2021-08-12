//
//  MIDI2Parser.swift.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI {
    
    /// Parser for MIDI 2.0 events.
    public class MIDI2Parser {
        
        internal static let midi1Parser: MIDI.MIDI1Parser = .init()
        
        public init() {
            
        }
        
        /// Parse
        public func parsedEvents(in packetData: MIDI.Packet.UniversalPacketData) -> [MIDI.Event] {
            
            Self.parsedEvents(in: packetData.bytes)
            
            
        }
        
        /// Parses raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
        public static func parsedEvents(
            in bytes: [MIDI.Byte]
        ) -> [MIDI.Event] {
            
            // instead of checking if it's empty, check if it's at least 4 bytes
            // since a UMP packet will never be less than 4 bytes
            guard bytes.count > 3 else { return [] }
            
            // MIDI 2.0 Spec Parser
            
            var events: [MIDI.Event] = []
            
            let byte0 = bytes[bytes.startIndex]
            let byte0Nibbles = byte0.nibbles
            
            guard let messageType = MIDI.Packet.UniversalPacketData
                    .MessageType(rawValue: byte0Nibbles.high)
            else { return events }
            let group = byte0Nibbles.low
            
            switch messageType {
            case .utility: // 0x0
                break
                
            case .systemRealTimeAndCommon: // 0x1
                // always 32 bits (4 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [status]
                // byte 2: [data1]
                // byte 3: [data2]
                break
                
            case .midi1ChannelVoice: // 0x2
                // always 32 bits (4 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [MIDI1 status & channel]
                // byte 2: [MIDI1 data byte 1 if applicable]
                // byte 3: [MIDI1 data byte 2 if applicable]
                
                let parsedMIDI1Event = Self.midi1Parser.parsedEvents(
                    in: Array(bytes[1...]),
                    umpGroup: group
                )
                
                events.append(contentsOf: parsedMIDI1Event)
                
            case .data64bit: // 0x3
                break
                
            case .midi2ChannelVoice: // 0x4
                // always 64 bits (8 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [status]
                // byte 2&3: [index]
                // byte 4...7: [data]
                
                // currently MIDIKit can only receive MIDI 1.0 events because
                // we are forcing Protocol 1.0 since MIDI 2.0 events are not
                // implemented yet, so this should never happen (for the time being)
                break
                
            case .data128bit: // 0x5
                break
                
            
            }
            
            return events
            
        }
        
    }

}

extension MIDI.Packet.UniversalPacketData {
    
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedEvents() -> [MIDI.Event] {
        
        MIDI.MIDI2Parser.parsedEvents(in: bytes)
        
    }
    
    /// Parse this instance's raw packet data into an array of MIDI Events.
    internal func parsedEvents(using parser: MIDI.MIDI2Parser) -> [MIDI.Event] {
        
        parser.parsedEvents(in: self)
        
    }
    
}

extension MIDI.Packet {
    
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedMIDI2Events() -> [MIDI.Event] {
        
        MIDI.MIDI2Parser.parsedEvents(in: bytes)
        
    }
    
}
