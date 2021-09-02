//
//  MIDIIOSendsMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOSendsMIDIMessagesProtocol: MIDIIOManagedProtocol {
    
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
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message, automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessage: MIDI message
    @inlinable public func send(rawMessage: [MIDI.Byte]) throws {
        
        switch apiVersion {
        case .legacyCoreMIDI:
            let packetListPointer = try MIDI.IO.assemblePacketList(data: rawMessage)
            
            try send(packetList: packetListPointer)
            
            // we HAVE to deallocate this here after we're done with it
            packetListPointer.deallocate()
            
        case .newCoreMIDI:
            #warning("> code this")
            throw MIDI.IO.MIDIError.internalInconsistency("Not yet implemented.")
            
        }
        
    }
    
    /// Send one or more MIDI message(s), automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessages: Array of MIDI messages
    @inlinable public func send(rawMessages: [[MIDI.Byte]]) throws {
        
        switch apiVersion {
        case .legacyCoreMIDI:
            let packetListPointer = try MIDI.IO.assemblePacketList(data: rawMessages)
            
            try send(packetList: packetListPointer)
            
            // we HAVE to deallocate this here after we're done with it
            packetListPointer.deallocate()
            
        case .newCoreMIDI:
            #warning("> code this")
            throw MIDI.IO.MIDIError.internalInconsistency("Not yet implemented.")
            
        }
        
    }
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message.
    @inlinable public func send(event: MIDI.Event) throws {
        
        switch apiVersion {
        case .legacyCoreMIDI:
            try send(rawMessage: event.midi1RawBytes)
            
        case .newCoreMIDI:
            #warning("> could use send(eventList:) here")
            try send(rawMessage: event.midi1RawBytes)
        }
        
    }
    
    /// Send multiple MIDI Messages.
    @inlinable public func send(events: [MIDI.Event]) throws {
        
        switch apiVersion {
        case .legacyCoreMIDI:
            try send(rawMessages: events.map { $0.midi1RawBytes })
            
        case .newCoreMIDI:
            #warning("> could use send(eventList:) here")
            try send(rawMessages: events.map { $0.midi1RawBytes })
        }
        
    }
    
}

