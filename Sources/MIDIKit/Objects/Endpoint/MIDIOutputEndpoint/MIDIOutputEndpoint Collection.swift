//
//  OutputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Static conveniences

extension Set where Element == MIDIEndpointIDCriteria {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(getSystemSourceEndpoints().asCriteria())
    }
}

extension Array where Element == MIDIEndpointIDCriteria {
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func currentOutputs() -> Self {
        getSystemSourceEndpoints().asCriteria()
    }
}

extension Set where Element == MIDIOutputEndpoint {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(getSystemSourceEndpoints())
    }
    
    /// Returns the endpoints as endpoint criteria.
    public func asCriteria() -> Set<MIDIEndpointIDCriteria> {
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDIEndpointIDCriteria>()) {
            $0.insert(.uniqueID($1.uniqueID))
        }
    }
}

extension Array where Element == MIDIOutputEndpoint {
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func currentOutputs() -> Self {
        getSystemSourceEndpoints()
    }
    
    /// Returns the endpoints as endpoint criteria.
    @_disfavoredOverload
    public func asCriteria() -> [MIDIEndpointIDCriteria] {
        map { .uniqueID($0.uniqueID) }
    }
}

#endif
