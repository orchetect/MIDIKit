//
//  Endpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - Endpoint

public protocol MIDIIOEndpointProtocol: MIDI.IO.Object {
    
}

extension MIDI.IO {
    
    public typealias Endpoint = MIDIIOEndpointProtocol
    
}

extension MIDI.IO.Endpoint {
    
    public static var objectType: MIDI.IO.ObjectType { .endpoint }
    
    /// List of entities within the device.
    public var entity: MIDI.IO.Entity? {
        
        try? MIDI.IO.getSystemEntity(for: ref)
        
    }
    
}
