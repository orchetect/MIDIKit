//
//  MIDIIOSendsMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

// MARK: - Public Protocol

public protocol MIDIIOSendsMIDIMessagesProtocol: MIDIIOManagedProtocol {
    
    /// MIDI Protocol version used for this endpoint.
    /* public private(set) */ var midiProtocol: MIDI.IO.ProtocolVersion { get }
    
    /// Send a MIDI Event.
    func send(event: MIDI.Event) throws
    
    /// Send one or more MIDI Events.
    func send(events: [MIDI.Event]) throws
    
}

// MARK: - Internal Protocol

internal protocol _MIDIIOSendsMIDIMessagesProtocol: MIDIIOSendsMIDIMessagesProtocol {
    
    /// Internal:
    /// Core MIDI Port Ref(s)
    var outputPortRef: MIDI.IO.CoreMIDIPortRef? { get }
    
    /// Internal:
    /// Send a MIDI Message, automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessage: MIDI message
    func send(rawMessage: [MIDI.Byte]) throws
    
    /// Internal:
    /// Send one or more MIDI message(s), automatically assembling it into a `MIDIPacketList`.
    ///
    /// - Parameter rawMessages: Array of MIDI messages
    func send(rawMessages: [[MIDI.Byte]]) throws
    
    /// Internal:
    /// Send a Core MIDI `MIDIPacketList`. (MIDI 1.0, using old Core MIDI API).
    func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
    
    /// Internal:
    /// Send a Core MIDI `MIDIEventList`. (MIDI 1.0 and 2.0, using new Core MIDI API).
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws
    
    /// Internal:
    /// Send a MIDI message inside a Universal MIDI Packet.
    ///
    /// - Parameter rawWords: Array of `UInt32` words
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    func send(rawWords: [MIDI.UMPWord]) throws
    
}

// MARK: - Implementation

extension _MIDIIOSendsMIDIMessagesProtocol {
    
    @inline(__always)
    internal func send(rawMessage: [MIDI.Byte]) throws {
        
        switch api {
        case .legacyCoreMIDI:
            var packetList = MIDIPacketList(data: rawMessage)
            
            try withUnsafeMutablePointer(to: &packetList) { ptr in
                try send(packetList: ptr)
            }
            
        case .newCoreMIDI:
            #warning("> TODO: send(rawMessage:) new API code this")
            throw MIDI.IO.MIDIError.internalInconsistency("Not yet implemented.")
            
        }
        
    }
    
    @inline(__always)
    internal func send(rawMessages: [[MIDI.Byte]]) throws {
        
        switch api {
        case .legacyCoreMIDI:
            var packetList = try MIDIPacketList(data: rawMessages)
            
            try withUnsafeMutablePointer(to: &packetList) { ptr in
                try send(packetList: ptr)
            }
            
        case .newCoreMIDI:
            #warning("> TODO: send(rawMessages:) new API code this")
            throw MIDI.IO.MIDIError.internalInconsistency("Not yet implemented.")
            
        }
        
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inline(__always)
    internal func send(rawWords: [MIDI.UMPWord]) throws {
        
        switch api {
        case .legacyCoreMIDI:
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Universal MIDI Packet words cannot be sent using old Core MIDI API."
            )
            
        case .newCoreMIDI:
            var eventList = try MIDIEventList(
                protocol: self.midiProtocol.coreMIDIProtocol,
                packetWords: rawWords
            )
            
            try withUnsafeMutablePointer(to: &eventList) { ptr in
                try send(eventList: ptr)
            }
            
        }
        
    }
    
}

extension _MIDIIOSendsMIDIMessagesProtocol {
    
    @inline(__always)
    public func send(event: MIDI.Event) throws {
        
        switch api {
        case .legacyCoreMIDI:
            try send(rawMessage: event.midi1RawBytes)
            
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *) else {
                throw MIDI.IO.MIDIError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
            
            try send(rawWords: event.umpRawWords(protocol: self.midiProtocol))
            
        }
        
    }
    
    @inline(__always)
    public func send(events: [MIDI.Event]) throws {
        
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
                try send(rawWords: event.umpRawWords(protocol: self.midiProtocol))
            }
            
        }
        
    }
    
}

