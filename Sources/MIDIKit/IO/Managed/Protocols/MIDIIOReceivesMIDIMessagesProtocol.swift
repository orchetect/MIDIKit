//
//  MIDIIOReceivesMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

public protocol MIDIIOReceivesMIDIMessagesProtocol: MIDIIOManagedProtocol {
    /// MIDI Protocol version used for this endpoint.
    /* public private(set) */ var midiProtocol: MIDI.IO.ProtocolVersion { get }
}

#endif
