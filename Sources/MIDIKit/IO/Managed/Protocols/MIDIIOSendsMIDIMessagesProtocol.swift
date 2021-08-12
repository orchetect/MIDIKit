//
//  MIDIIOSendsMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOSendsMIDIMessagesProtocol {
    
    /// Reference to owning `MIDI.IO.Manager`
    var midiManager: MIDI.IO.Manager? { get }
    
    /// CoreMIDI Port Ref
    var portRef: MIDIPortRef? { get }
    
    /// Send a raw MIDI message.
    func send(rawMessage: [MIDI.Byte],
              api: MIDI.CoreMIDIVersion) throws
    
    /// Send one ore more raw MIDI messages.
    func send(rawMessages: [[MIDI.Byte]],
              api: MIDI.CoreMIDIVersion) throws
    
    /// Send a MIDI Event.
    func send(event: MIDI.Event) throws
    
    /// Send one or more MIDI Events.
    func send(events: [MIDI.Event]) throws
    
    /// Send a CoreMIDI `MIDIPacketList`. (MIDI 1.0, using old CoreMIDI API).
    func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
    
    /// Send a CoreMIDI `MIDIEventList`. (MIDI 1.0 and 2.0, using new CoreMIDI API).
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message, automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessage: MIDI message
    @inlinable public func send(rawMessage: [MIDI.Byte],
                                api: MIDI.CoreMIDIVersion) throws {
        
        switch api {
        case .legacy:
            let packetListPointer = try MIDI.IO.assemblePacketList(data: rawMessage)
            
            try send(packetList: packetListPointer)
            
            // we HAVE to deallocate this here after we're done with it
            packetListPointer.deallocate()
            
        case .new:
            #warning("> code this")
            break
        }
        
    }
    
    /// Send one or more MIDI message(s), automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessages: Array of MIDI messages
    @inlinable public func send(rawMessages: [[MIDI.Byte]],
                                api: MIDI.CoreMIDIVersion) throws {
        
        switch api {
        case .legacy:
            let packetListPointer = try MIDI.IO.assemblePacketList(data: rawMessages)
            
            try send(packetList: packetListPointer)
            
            // we HAVE to deallocate this here after we're done with it
            packetListPointer.deallocate()
            
        case .new:
            #warning("> code this")
            break
            
        }
        
    }
    
}

extension MIDIIOSendsMIDIMessagesProtocol {
    
    /// Send a MIDI Message.
    @inlinable public func send(event: MIDI.Event) throws {
        
        if #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *),
           midiManager?.coreMIDIVersion == .new
        {
            #warning("> could use send(eventList:) here")
            try send(rawMessage: event.midi1RawBytes,
                     api: .legacy)
        } else {
            try send(rawMessage: event.midi1RawBytes,
                     api: .legacy)
        }
    }
    
    /// Send multiple MIDI Messages.
    @inlinable public func send(events: [MIDI.Event]) throws {
        
        if #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *),
           midiManager?.coreMIDIVersion == .new
        {
            #warning("> could use send(eventList:) here")
            try send(rawMessages: events.map { $0.midi1RawBytes },
                     api: .legacy)
        } else {
            try send(rawMessages: events.map { $0.midi1RawBytes },
                     api: .legacy)
        }
        
    }
    
}

