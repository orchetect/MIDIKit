//
//  MIDIReceiveHandler.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// MARK: - ReceiveHandler

/// Shell class for MIDI receive handlers.
internal class MIDIReceiveHandler: MIDIIOReceiveHandlerProtocol {
    public typealias Handler = (_ packets: [AnyMIDIPacket]) -> Void
    
    /// The specialized MIDI receiver instance.
    public var handler: MIDIIOReceiveHandlerProtocol
    
    /// Parses a MIDI Packet (MIDI 1.0, legacy Core MIDI API) and passes parsed data to the handler.
    public func packetListReceived(
        _ packets: [MIDIPacketData]
    ) {
        handler.packetListReceived(packets)
    }
    
    /// Parses a Universal MIDI Packet (UMP; MIDI 2.0, new Core MIDI API) and passes parsed data to
    /// the handler.
    @available(macOS 11, iOS 14, macCatalyst 14, *)
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

#endif
