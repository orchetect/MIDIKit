//
//  MIDIIOSendsMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOSendsMIDIMessagesProtocol: MIDIIOManagedProtocol {
    
    /// MIDI Spec version used for this endpoint.
    /* public private(set) */ var `protocol`: MIDI.IO.ProtocolVersion { get }
    
    /// Core MIDI Port Ref
    var portRef: MIDIPortRef? { get }
    
    /// Send a raw MIDI message.
    func send(rawMessage: [MIDI.Byte]) throws
    
    /// Send one ore more raw MIDI messages.
    func send(rawMessages: [[MIDI.Byte]]) throws
    
    /// Send a MIDI Event.
    func send(event: MIDI.Event) throws
    
    /// Send one or more MIDI Events.
    func send(events: [MIDI.Event]) throws
    
    /// Send a Core MIDI `MIDIPacketList`. (MIDI 1.0, using old Core MIDI API).
    func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
    
    /// Send a Core MIDI `MIDIEventList`. (MIDI 1.0 and 2.0, using new Core MIDI API).
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws
    
    /// Send a Universal MIDI Packet (MIDI 2.0).
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    func send(rawWords: [MIDI.UMPWord]) throws
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message, automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessage: MIDI message
    @inlinable public func send(rawMessage: [MIDI.Byte]) throws {
        
        switch api {
        case .legacyCoreMIDI:
            var packetList = MIDIPacketList(data: rawMessage)
            
            try withUnsafeMutablePointer(to: &packetList) { ptr in
                try send(packetList: ptr)
            }
            
        case .newCoreMIDI:
            #warning("> code this")
            throw MIDI.IO.MIDIError.internalInconsistency("Not yet implemented.")
            
        }
        
    }
    
    /// Send one or more MIDI message(s), automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessages: Array of MIDI messages
    @inlinable public func send(rawMessages: [[MIDI.Byte]]) throws {
        
        switch api {
        case .legacyCoreMIDI:
            var packetList = try MIDIPacketList(data: rawMessages)
            
            try withUnsafeMutablePointer(to: &packetList) { ptr in
                try send(packetList: ptr)
            }
            
        case .newCoreMIDI:
            #warning("> code this")
            throw MIDI.IO.MIDIError.internalInconsistency("Not yet implemented.")
            
        }
        
    }
    
    /// Send a MIDI message inside a Universal MIDI Packet.
    ///
    /// - Parameter rawWords: Array of `UInt32` words
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inlinable public func send(rawWords: [MIDI.UMPWord]) throws {
        
        switch api {
        case .legacyCoreMIDI:
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Universal MIDI Packet words cannot be sent using old Core MIDI API."
            )
            
        case .newCoreMIDI:
            var eventList = try MIDIEventList(
                protocol: self.protocol.coreMIDIProtocol,
                packetWords: rawWords
            )
            
            try withUnsafeMutablePointer(to: &eventList) { ptr in
                try send(eventList: ptr)
            }
            
        }
        
    }
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message.
    @inlinable public func send(event: MIDI.Event) throws {
        
        switch api {
        case .legacyCoreMIDI:
            try send(rawMessage: event.midi1RawBytes)
            
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *) else {
                throw MIDI.IO.MIDIError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
            
            try send(rawWords: event.umpRawWords)
        }
        
    }
    
    /// Send multiple MIDI Messages.
    @inlinable public func send(events: [MIDI.Event]) throws {
        
        switch api {
        case .legacyCoreMIDI:
            try send(rawMessages: events.map { $0.midi1RawBytes })
            
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *) else {
                throw MIDI.IO.MIDIError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
            
            for event in events {
                try send(rawWords: event.umpRawWords)
            }
        }
        
    }
    
}

