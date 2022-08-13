//
//  MIDIIOReceiveHandler.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import SwiftRadix

// MARK: - ReceiveHandler

public class MIDIIOReceiveHandler: MIDIIOReceiveHandlerProtocol {
    public typealias Handler = (_ packets: [AnyMIDIPacket]) -> Void
        
    @inline(__always)
    public var handler: MIDIIOReceiveHandlerProtocol
        
    @inline(__always)
    public func packetListReceived(
        _ packets: [MIDIPacketData]
    ) {
        handler.packetListReceived(packets)
    }
        
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    @inline(__always)
    public func eventListReceived(
        _ packets: [UniversalMIDIPacketData],
        protocol midiProtocol: MIDIProtocolVersion
    ) {
        handler.eventListReceived(packets, protocol: midiProtocol)
    }
        
    public init(_ handler: MIDIIOReceiveHandlerProtocol) {
        self.handler = handler
    }
}

// MARK: - ReceiveHandler.Definition

extension MIDIIOReceiveHandler {
    public enum Definition {
        case group([Definition])
        
        case events(
            translateMIDI1NoteOnZeroVelocityToNoteOff: Bool = true,
            Events.Handler
        )
        
        case eventsLogging(
            filterActiveSensingAndClock: Bool = false,
            _ handler: EventsLogging.Handler? = nil
        )
        
        case rawData(RawData.Handler)
        
        case rawDataLogging(
            filterActiveSensingAndClock: Bool = false,
            _ handler: RawDataLogging.Handler? = nil
        )
    }
}

extension MIDIIOReceiveHandler.Definition {
    internal func createReceiveHandler() -> MIDIIOReceiveHandler {
        switch self {
        case let .group(definitions):
            let handlers = definitions.map { $0.createReceiveHandler() }
            return .init(MIDIIOReceiveHandler.Group(handlers))
            
        case let .events(
            translateMIDI1NoteOnZeroVelocityToNoteOff,
            handler
        ):
            return .init(
                MIDIIOReceiveHandler.Events(
                    translateMIDI1NoteOnZeroVelocityToNoteOff: translateMIDI1NoteOnZeroVelocityToNoteOff,
                    handler
                )
            )
            
        case let .eventsLogging(
            filterActiveSensingAndClock,
            handler
        ):
            return .init(
                MIDIIOReceiveHandler.EventsLogging(
                    filterActiveSensingAndClock: filterActiveSensingAndClock,
                    handler
                )
            )
            
        case let .rawData(handler):
            return .init(MIDIIOReceiveHandler.RawData(handler))
            
        case let .rawDataLogging(filterActiveSensingAndClock, handler):
            return .init(
                MIDIIOReceiveHandler.RawDataLogging(
                    filterActiveSensingAndClock: filterActiveSensingAndClock,
                    handler
                )
            )
        }
    }
}

#endif
