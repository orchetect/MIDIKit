//
//  MIDIIOSendsMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOSendsMIDIMessagesProtocol {
    
    /// CoreMIDI Port Ref
    var portRef: MIDIPortRef? { get }
    
    /// Send a raw MIDI message.
    func send(rawMessage: [MIDI.Byte]) throws
    
    /// Send one ore more raw MIDI messages.
    func send(rawMessages: [[MIDI.Byte]]) throws
    
    /// Send a MIDI Event.
    func send(event: MIDI.Event) throws
    
    /// Send one or more MIDI Events.
    func send(events: [MIDI.Event]) throws
    
    /// Send a CoreMIDI `MIDIPacketList`.
    func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
    
    /// Send a CoreMIDI `MIDIEventList`.
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message, automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessage: MIDI message
    @inlinable public func send(rawMessage: [MIDI.Byte]) throws {
        
        let packetListPointer = try MIDI.IO.assemblePacketList(data: rawMessage)
        
        try send(packetList: packetListPointer)
        
        // we HAVE to deallocate this here after we're done with it
        packetListPointer.deallocate()
        
    }
    
    /// Send one or more MIDI message(s), automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessages: Array of MIDI messages
    @inlinable public func send(rawMessages: [[MIDI.Byte]]) throws {
        
        let packetListPointer = try MIDI.IO.assemblePacketList(data: rawMessages)
        
        try send(packetList: packetListPointer)
        
        // we HAVE to deallocate this here after we're done with it
        packetListPointer.deallocate()
        
    }
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message.
    @inlinable public func send(event: MIDI.Event) throws {
        
        try send(rawMessage: event.rawBytes)
        
    }
    
    /// Send multiple MIDI Messages.
    @inlinable public func send(events: [MIDI.Event]) throws {
        
        try send(rawMessages: events.map { $0.rawBytes })
        
    }
    
}

