//
//  ReceiveHandler.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

@_implementationOnly import SwiftRadix

// MARK: - ReceiveHandler

extension MIDI.IO {
    
    public struct ReceiveHandler: MIDIIOReceiveHandlerProtocol {
        
        public typealias Handler = (_ packets: [MIDI.Packet]) -> Void
        
        @inline(__always) public var handler: MIDIIOReceiveHandlerProtocol
        
        @inline(__always) public func midiReadBlock(
            _ packetListPtr: UnsafePointer<MIDIPacketList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            handler.midiReadBlock(packetListPtr, srcConnRefCon)
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public func midiReceiveBlock(
            _ eventListPtr: UnsafePointer<MIDIEventList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            handler.midiReceiveBlock(eventListPtr, srcConnRefCon)
            
        }
        
        public init(_ handler: MIDIIOReceiveHandlerProtocol) {
            
            self.handler = handler
            
        }
        
    }
    
}

// MARK: - Static inits

extension MIDI.IO.ReceiveHandler {
    
    /// Returns a new `Group` receive handler instance.
    public static func group(
        _ handlers: [MIDI.IO.ReceiveHandler]
    ) -> Self {
        
        Self(Group(handlers))
        
    }
    
    /// Returns a new `Events` receive handler instance.
    public static func events(
        _ handler: @escaping Events.Handler
    ) -> Self {
        
        Self(Events(handler))
        
    }
    
    /// Returns a new `EventsLogging` receive handler instance.
    public static func eventsLogging(
        _ handler: @escaping EventsLogging.Handler
    ) -> Self {
        
        Self(EventsLogging(handler))
        
    }
    
    /// Returns a new `RawData` receive handler instance.
    public static func rawData(
        _ handler: @escaping RawData.Handler
    ) -> Self {
        
        Self(RawData(handler))
        
    }
    
    /// Returns a new `RawDataLogging` receive handler instance.
    public static func rawDataLogging(
        filterActiveSensingAndClock: Bool = false,
        _ handler: RawDataLogging.Handler? = nil
    ) -> Self {
        
        Self(RawDataLogging(filterActiveSensingAndClock: filterActiveSensingAndClock,
                            handler))
        
    }
    
}
