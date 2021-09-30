//
//  MIDIIOEndpointProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Endpoint

public protocol MIDIIOEndpointProtocol: MIDIIOObjectProtocol {
    
}

internal protocol _MIDIIOEndpointProtocol: MIDIIOEndpointProtocol, _MIDIIOObjectProtocol {
    
}

extension MIDIIOEndpointProtocol {
    
    public var objectType: MIDI.IO.ObjectType { .endpoint }
    
    internal func getEntity() -> MIDI.IO.Entity?
    where Self : _MIDIIOEndpointProtocol
    {
        
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
