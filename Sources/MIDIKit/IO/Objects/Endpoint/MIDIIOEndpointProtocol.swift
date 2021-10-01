//
//  MIDIIOEndpointProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Public Protocol

public protocol MIDIIOEndpointProtocol: MIDIIOObjectProtocol {
    
    // implemented in extension _MIDIIOEndpointProtocol
    
    /// Returns the entity the endpoint originates from. For virtual endpoints, this will return `nil`.
    func getEntity() -> MIDI.IO.Entity?
    
    /// Returns the endpoint as a type-erased `AnyEndpoint`.
    func asAnyEndpoint() -> MIDI.IO.AnyEndpoint
    
}

// MARK: - Internal Protocol

internal protocol _MIDIIOEndpointProtocol: MIDIIOEndpointProtocol, _MIDIIOObjectProtocol {
    
}

// MIDIIOObjectProtocol implementation

extension _MIDIIOEndpointProtocol {
    
    public var objectType: MIDI.IO.ObjectType { .endpoint }
    
}

// MIDIIOEndpointProtocol implementation

extension _MIDIIOEndpointProtocol {
    
    public func getEntity() -> MIDI.IO.Entity? {
        
        try? MIDI.IO.getSystemEntity(for: self.coreMIDIObjectRef)
        
    }
    
}
