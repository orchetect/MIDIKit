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
    
}

extension Array where Element == MIDI.IO.OutputEndpoint {
    
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemSourceEndpoints
        
    }
    
}
