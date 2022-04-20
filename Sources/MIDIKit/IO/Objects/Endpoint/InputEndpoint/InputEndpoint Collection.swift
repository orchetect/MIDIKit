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
    
}

extension Array where Element == MIDI.IO.InputEndpoint {
    
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemDestinationEndpoints
        
    }
    
}
