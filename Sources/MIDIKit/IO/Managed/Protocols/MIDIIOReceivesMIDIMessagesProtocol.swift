//
//  MIDIIOReceivesMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOReceivesMIDIMessagesProtocol: MIDIIOManagedProtocol {
    
    /// MIDI Spec version used for this endpoint.
    /* public private(set) */ var `protocol`: MIDI.IO.ProtocolVersion { get }
    
}
