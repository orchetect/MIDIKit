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
                // byte 2: [MIDI1 data byte 1, or 0x00 if not applicable]
                // byte 3: [MIDI1 data byte 2, or 0x00 if not applicable]
                
                let parsedMIDI1Event = Self.midi1Parser.parsedEvents(
                    in: Array(bytes[bytes.startIndex.advanced(by: 1)...]),
                    umpGroup: group
                )
                
                events.append(contentsOf: parsedMIDI1Event)
                
            case .midi1ChannelVoice: // 0x2
                // always 32 bits (4 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [MIDI1 status & channel]
                // byte 2: [MIDI1 data byte 1, or 0x00 if not applicable]
                // byte 3: [MIDI1 data byte 2, or 0x00 if not applicable]
                
                let parsedMIDI1Event = Self.midi1Parser.parsedEvents(
                    in: Array(bytes[bytes.startIndex.advanced(by: 1)...]),
                    umpGroup: group
                )
                
                events.append(contentsOf: parsedMIDI1Event)
                
            case .data64bit: // 0x3
                // SysEx 7
                
                // MIDI 2.0 Spec:
                // "The MIDI 1.0 Protocol bracketing method with 0xF0 Start and 0xF7 End Status bytes is not used in the UMP Format. Instead, the SysEx payload is carried in one or more 64-bit UMPs, discarding the 0xF0 and 0xF7 bytes. The standard ID Number (Manufacturer ID, Special ID 0x7D, or Universal System Exclusive ID), Device ID, and Sub-ID#1 & Sub-ID#2 (if applicable) are included in the initial data bytes, just as they are in MIDI 1.0 Protocol message equivalents."
                
                let byte1Nibbles = bytes[bytes.startIndex.advanced(by: 1)].nibbles
                
                guard let sysExStatusField = MIDI.Packet.UniversalPacketData
                        .SysExStatusField(rawValue: byte1Nibbles.high)
                else {
                    return events
                }
                
                let numberOfBytes = byte1Nibbles.low.intValue
                
                switch sysExStatusField {
                case .complete:
                    guard bytes.count >= numberOfBytes + 2
                    else { return events }
                    
                    let payloadBytes = bytes[
                        bytes.startIndex.advanced(by: 2)
                        ..<
                        bytes.startIndex.advanced(by: 2 + numberOfBytes)
                    ]
                    
                    guard let parsedSysEx = try? MIDI.Event.SysEx
                            .parsed(from: [0xF0] + payloadBytes + [0xF7])
                    else { return events }
                    
                    events.append(parsedSysEx)
                    
                case .start:
                    #warning("> handle multi-packet SysEx Messages")
                    return events
                    
                case .continue:
                    #warning("> handle multi-packet SysEx Messages")
                    return events
                    
                case .end:
                    #warning("> handle multi-packet SysEx Messages")
                    return events
                    
                }
                
                break
                
            case .midi2ChannelVoice: // 0x4
                // always 64 bits (8 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [status]
                // byte 2&3: [index]
                // byte 4...7: [data bytes]
                
                // currently MIDIKit can only receive MIDI 1.0 events because
                // we are forcing Protocol 1.0 since MIDI 2.0 events are not
                // implemented yet, so this should never happen (for the time being)
                break
                
            case .data128bit: // 0x5
                // can contain a SysEx 8 message
                
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
