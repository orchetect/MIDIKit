//
//  MIDIIOSendsMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOSendsMIDIMessagesProtocol {
    
    var portRef: MIDIPortRef? { get }
    
    func send(rawMessage: [MIDI.Byte]) throws
    func send(rawMessages: [[MIDI.Byte]]) throws
    func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
    func send(event: MIDI.Event) throws
    func send(events: [MIDI.Event]) throws
    
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

