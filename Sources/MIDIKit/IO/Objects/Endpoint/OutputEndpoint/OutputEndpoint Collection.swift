//
//  OutputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Static conveniences

extension Set where Element == MIDI.IO.OutputEndpointIDCriteria {
    
    /// Returns the current output endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemSourceEndpoints.map { .uniqueID($0.uniqueID) })
        
    }
    
}

extension Array where Element == MIDI.IO.OutputEndpointIDCriteria {
    
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemSourceEndpoints.map { .uniqueID($0.uniqueID) }
        
    }
    
}

extension Set where Element == MIDI.IO.OutputEndpoint {
    
    /// Returns the current output endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemSourceEndpoints)
        
    }
    
    /// Returns the endpoints as endpoint criteria.
    public func asCriteria() -> Set<MIDI.IO.OutputEndpointIDCriteria> {
        
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDI.IO.OutputEndpointIDCriteria>()) {
            $0.insert(.uniqueID($1.uniqueID))
        }
        
    }
    
}

extension Array where Element == MIDI.IO.OutputEndpoint {
    
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemSourceEndpoints
        
    }
    
    /// Returns the endpoints as endpoint criteria.
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.OutputEndpointIDCriteria] {
        
        map { MIDI.IO.OutputEndpointIDCriteria.uniqueID($0.uniqueID) }
        
    }
    
}
