//
//  InputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Static conveniences

extension Set where Element == MIDI.IO.EndpointIDCriteria {
    /// Returns the current input endpoints in the system.
    public static func currentInputs() -> Self {
        Set(MIDI.IO.getSystemDestinationEndpoints.asCriteria())
    }
}

extension Array where Element == MIDI.IO.EndpointIDCriteria {
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func currentInputs() -> Self {
        MIDI.IO.getSystemDestinationEndpoints.asCriteria()
    }
}

extension Set where Element == MIDI.IO.InputEndpoint {
    /// Returns the current input endpoints in the system.
    public static func currentInputs() -> Self {
        Set(MIDI.IO.getSystemDestinationEndpoints)
    }
    
    /// Returns the endpoints as endpoint criteria.
    public func asCriteria() -> Set<MIDI.IO.EndpointIDCriteria> {
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDI.IO.EndpointIDCriteria>()) {
            $0.insert(.uniqueID($1.uniqueID))
        }
    }
}

extension Array where Element == MIDI.IO.InputEndpoint {
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func currentInputs() -> Self {
        MIDI.IO.getSystemDestinationEndpoints
    }
    
    /// Returns the endpoints as endpoint criteria.
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.EndpointIDCriteria] {
        map { .uniqueID($0.uniqueID) }
    }
}

#endif
