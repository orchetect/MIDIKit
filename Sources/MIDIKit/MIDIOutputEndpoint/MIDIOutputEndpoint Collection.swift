//
//  MIDIOutputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Static conveniences

extension Set where Element == MIDIEndpointIdentity {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(getSystemSourceEndpoints().asIdentities())
    }
}

extension Array where Element == MIDIEndpointIdentity {
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func currentOutputs() -> Self {
        getSystemSourceEndpoints().asIdentities()
    }
}

extension Set where Element == MIDIOutputEndpoint {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(getSystemSourceEndpoints())
    }
    
    /// Returns endpoint identity criteria describing the endpoints.
    public func asIdentities() -> Set<MIDIEndpointIdentity> {
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
    
        reduce(into: Set<MIDIEndpointIdentity>()) {
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
    
    /// Returns endpoint identity criteria describing the endpoints.
    @_disfavoredOverload
    public func asIdentities() -> [MIDIEndpointIdentity] {
        map { .uniqueID($0.uniqueID) }
    }
}

#endif
