//
//  MIDIIOEndpointProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Endpoint

public protocol MIDIIOEndpointProtocol: MIDIIOObjectProtocol {
    
    // implemented in extension _MIDIIOEndpointProtocol
    
    func getEntity() -> MIDI.IO.Entity?
    
}

internal protocol _MIDIIOEndpointProtocol: MIDIIOEndpointProtocol, _MIDIIOObjectProtocol {
    
}

extension _MIDIIOEndpointProtocol {
    
    public var objectType: MIDI.IO.ObjectType { .endpoint }
    
    public func getEntity() -> MIDI.IO.Entity? {
        
        try? MIDI.IO.getSystemEntity(for: self.coreMIDIObjectRef)
        
    }
    
}

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns the collection as a collection of type-erased `AnyEndpoint` endpoints.
    public func asAnyEndpoints() -> [MIDI.IO.AnyEndpoint]
    where Element : _MIDIIOEndpointProtocol
    {
        
        map { MIDI.IO.AnyEndpoint($0) }
        
    }
    
}
