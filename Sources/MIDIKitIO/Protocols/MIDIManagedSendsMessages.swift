//
//  MIDIManagedSendsMessages.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI

// MARK: - Public Protocol

public protocol MIDIManagedSendsMessages: MIDIManaged {
    /// The Core MIDI output port ref.
    /* public private(set) */ var coreMIDIOutputPortRef: CoreMIDIPortRef? { get }
    
    /// MIDI Protocol version used for this endpoint.
    /* public private(set) */ var midiProtocol: MIDIProtocolVersion { get }
    
    /// Send a MIDI Event.
    func send(event: MIDIEvent) throws
    
    /// Send one or more MIDI Events.
    func send(events: [MIDIEvent]) throws
}

// MARK: - Internal Protocol

internal protocol _MIDIManagedSendsMessages: MIDIManagedSendsMessages {
    /// Internal:
    /// Send a legacy MIDI 1.0 Message, automatically assembling it into a `MIDIPacketList`.
    ///
    /// This method is internal-only and its use is discouraged.
    ///
    /// - Parameter rawMessage: MIDI message.
    func send(rawMessage: [UInt8]) throws
    
    /// Internal:
    /// Send one or more legacy MIDI 1.0 message(s), automatically assembling it into a
    /// `MIDIPacketList`.
    ///
    /// This method is internal-only and its use is discouraged.
    ///
    /// - Parameter rawMessages: Array of MIDI messages.
    func send(rawMessages: [[UInt8]]) throws
    
    /// Internal:
    /// Send a Core MIDI `MIDIPacketList`. (MIDI 1.0, using old Core MIDI API).
    func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
    
    /// Internal:
    /// Send a Core MIDI `MIDIEventList`. (MIDI 1.0 and 2.0, using new Core MIDI API).
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws
    
    /// Internal:
    /// Send a MIDI message inside a Universal MIDI Packet.
    ///
    /// - Parameter rawWords: Array of `UInt32` words
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    func send(rawWords: [UMPWord]) throws
}

// MARK: - Implementation

extension _MIDIManagedSendsMessages {
    internal func send(rawMessage: [UInt8]) throws {
        switch api {
        case .legacyCoreMIDI:
            var packetList = MIDIPacketList(data: rawMessage)
    
            try withUnsafeMutablePointer(to: &packetList) { ptr in
                try send(packetList: ptr)
            }
    
        case .newCoreMIDI:
            throw MIDIIOError.internalInconsistency(
                "Raw bytes cannot be sent using new Core MIDI API."
            )
        }
    }
    
    internal func send(rawMessages: [[UInt8]]) throws {
        switch api {
        case .legacyCoreMIDI:
            var packetList = try MIDIPacketList(data: rawMessages)
    
            try withUnsafeMutablePointer(to: &packetList) { ptr in
                try send(packetList: ptr)
            }
    
        case .newCoreMIDI:
            throw MIDIIOError.internalInconsistency(
                "Raw bytes cannot be sent using new Core MIDI API."
            )
        }
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    internal func send(rawWords: [UMPWord]) throws {
        switch api {
        case .legacyCoreMIDI:
            throw MIDIIOError.internalInconsistency(
                "Universal MIDI Packet words cannot be sent using old Core MIDI API."
            )
    
        case .newCoreMIDI:
            var eventList = try MIDIEventList(
                protocol: midiProtocol.coreMIDIProtocol,
                packetWords: rawWords
            )
    
            try withUnsafeMutablePointer(to: &eventList) { ptr in
                try send(eventList: ptr)
            }
        }
    }
}

extension _MIDIManagedSendsMessages {
    public func send(event: MIDIEvent) throws {
        switch api {
        case .legacyCoreMIDI:
            try send(rawMessage: event.midi1RawBytes())
    
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, *) else {
                throw MIDIIOError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
    
            for eventWords in event.umpRawWords(protocol: midiProtocol) {
                try send(rawWords: eventWords)
            }
        }
    }
    
    public func send(events: [MIDIEvent]) throws {
        switch api {
        case .legacyCoreMIDI:
            if events.contains(where: { $0.isSystemExclusive }) {
                // System Exclusive events must be the only event in a MIDIPacketList
                // so force each event to be sent in its own packet
                try events.forEach { try send(event: $0) }
            } else {
                // combine events into a single MIDIPacketList
                try send(rawMessages: events.map { $0.midi1RawBytes() })
            }
    
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, *) else {
                throw MIDIIOError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
    
            for event in events {
                for eventWords in event.umpRawWords(protocol: midiProtocol) {
                    try send(rawWords: eventWords)
                }
            }
        }
    }
}

#endif
