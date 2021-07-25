//
//  MIDI2Parser.swift.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI {
    
    /// Parser for MIDI 2.0 events.
    public class MIDI2Parser {
        
        /// Parse
        public func parsedEvents(in packetData: MIDI.Packet.UniversalPacketData) -> [MIDI.Event] {
            
            Self.parsedEvents(in: packetData.bytes)
            
            
        }
        
        /// Parses raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
        public static func parsedEvents(
            in bytes: [MIDI.Byte]
        ) -> [MIDI.Event] {
            
            #warning("> code this")
            
            return []
            
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
