//
//  MIDIIOReceivesMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

public protocol MIDIIOReceivesMIDIMessagesProtocol: MIDIIOManagedProtocol {
    /// MIDI Protocol version used for this endpoint.
    /* public private(set) */ var midiProtocol: MIDIProtocolVersion { get }
}

#endif
