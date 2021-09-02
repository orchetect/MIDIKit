//
//  MIDIIOManagedProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

public protocol MIDIIOManagedProtocol {
    
    /// Reference to owning `MIDI.IO.Manager`
    /* public weak */ var midiManager: MIDI.IO.Manager? { get set }
    
    /// Core MIDI API version used to create the endpoint and send/receive MIDI messages (if applicable).
    /* public private(set) */ var apiVersion: MIDI.IO.APIVersion { get }
    
}
