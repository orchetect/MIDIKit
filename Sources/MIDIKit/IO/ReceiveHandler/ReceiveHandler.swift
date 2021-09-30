//
//  ReceiveHandler.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import SwiftRadix

// MARK: - ReceiveHandler

extension MIDI.IO {
    
    public class ReceiveHandler: MIDIIOReceiveHandlerProtocol {
        
        public typealias Handler = (_ packets: [MIDI.Packet]) -> Void
        
        @inline(__always)
        public var handler: MIDIIOReceiveHandlerProtocol
        
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDI.Packet.PacketData]
        ) {
            
            handler.packetListReceived(packets)
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always)
        public func eventListReceived(
            _ packets: [MIDI.Packet.UniversalPacketData],
            protocol midiProtocol: MIDI.IO.ProtocolVersion
        ) {
            
            handler.eventListReceived(packets, protocol: midiProtocol)
            
        }
        
        public init(_ handler: MIDIIOReceiveHandlerProtocol) {
            
            self.handler = handler
            
        }
        
    }
    
}

// MARK: - ReceiveHandler.Definition

extension MIDI.IO.ReceiveHandler {
    
    public enum Definition {
        
        case group([Definition])
        
        case events(Events.Handler)
        
        case eventsLogging(filterActiveSensingAndClock: Bool = false,
                           _ handler: EventsLogging.Handler? = nil)
        
        case rawData(RawData.Handler)
        
        case rawDataLogging(filterActiveSensingAndClock: Bool = false,
                            _ handler: RawDataLogging.Handler? = nil)
        
    }
    
}

extension MIDI.IO.ReceiveHandler.Definition {
    
    internal func createReceiveHandler() -> MIDI.IO.ReceiveHandler {
        
        switch self {
        case .group(let definitions):
            let handlers = definitions.map { $0.createReceiveHandler() }
            return .init(MIDI.IO.ReceiveHandler.Group(handlers))
            
        case .events(let handler):
            return .init(MIDI.IO.ReceiveHandler.Events(handler))
            
        case .eventsLogging(let filterActiveSensingAndClock,
                            let handler):
            return .init(
                MIDI.IO.ReceiveHandler.EventsLogging(
                    filterActiveSensingAndClock: filterActiveSensingAndClock,
                    handler
                )
            )
            
        case .rawData(let handler):
            return .init(MIDI.IO.ReceiveHandler.RawData(handler))
            
        case .rawDataLogging(let filterActiveSensingAndClock, let handler):
            return .init(
                MIDI.IO.ReceiveHandler.RawDataLogging(
                    filterActiveSensingAndClock: filterActiveSensingAndClock,
                    handler
                )
            )
            
        }
        
    }
    
}
