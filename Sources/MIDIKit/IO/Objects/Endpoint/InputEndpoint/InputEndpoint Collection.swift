//
//  InputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Static conveniences

extension Set where Element == MIDI.IO.InputEndpointIDCriteria {
    
    /// Returns the current input endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemDestinationEndpoints.map { .uniqueID($0.uniqueID) })
        
    }
    
}

extension Array where Element == MIDI.IO.InputEndpointIDCriteria {
    
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemDestinationEndpoints.map { .uniqueID($0.uniqueID) }
        
    }
    
}

extension Set where Element == MIDI.IO.InputEndpoint {
    
    /// Returns the current input endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemDestinationEndpoints)
        
    }
    
    /// Returns the endpoints as endpoint criteria.
    public func asCriteria() -> Set<MIDI.IO.InputEndpointIDCriteria> {
        
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDI.IO.InputEndpointIDCriteria>()) {
            $0.insert(.uniqueID($1.uniqueID))
        }
        
    }
    
}

extension Array where Element == MIDI.IO.InputEndpoint {
    
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemDestinationEndpoints
        
    }
    
    /// Returns the endpoints as endpoint criteria.
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.InputEndpointIDCriteria] {
        
        map { MIDI.IO.InputEndpointIDCriteria.uniqueID($0.uniqueID) }
        
    }
    
}
