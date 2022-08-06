//
//  OutputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Static conveniences

extension Set where Element == MIDI.IO.EndpointIDCriteria {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(MIDI.IO.getSystemSourceEndpoints.asCriteria())
    }
}

extension Array where Element == MIDI.IO.EndpointIDCriteria {
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func currentOutputs() -> Self {
        MIDI.IO.getSystemSourceEndpoints.asCriteria()
    }
}

extension Set where Element == MIDI.IO.OutputEndpoint {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(MIDI.IO.getSystemSourceEndpoints)
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

extension Array where Element == MIDI.IO.OutputEndpoint {
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func currentOutputs() -> Self {
        MIDI.IO.getSystemSourceEndpoints
    }
    
    /// Returns the endpoints as endpoint criteria.
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.EndpointIDCriteria] {
        map { .uniqueID($0.uniqueID) }
    }
}

#endif
