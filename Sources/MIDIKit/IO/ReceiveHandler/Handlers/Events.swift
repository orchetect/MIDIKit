//
//  Events.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO.ReceiveHandler {
    
    /// MIDI Event receive handler.
    public class Events: MIDIIOReceiveHandlerProtocol {
        
        public typealias Handler = (_ events: [MIDI.Event]) -> Void
        
        @inline(__always) public var handler: Handler
        
        internal let midi1Parser = MIDI.MIDI1Parser()
        internal let midi2Parser = MIDI.MIDI2Parser()
        
        @inline(__always) public func packetListReceived(
            _ packets: [MIDI.Packet.PacketData]
        ) {
            
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                handler(events)
            }
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public func eventListReceived(
            _ packets: [MIDI.Packet.UniversalPacketData],
            protocol midiProtocol: MIDI.IO.ProtocolVersion
        ) {
            
            for midiPacket in packets {
                let events = midi2Parser.parsedEvents(in: midiPacket)
                handler(events)
            }
            
        }
        
        internal init(_ handler: @escaping Handler) {
            
            self.handler = handler
            
        }
        
    }
    
}
