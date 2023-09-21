//
//  MIDIOutputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Static conveniences

extension Set<MIDIEndpointIdentity> {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(getSystemSourceEndpoints().asIdentities())
    }
}

extension [MIDIEndpointIdentity] {
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func currentOutputs() -> Self {
        getSystemSourceEndpoints().asIdentities()
    }
}

extension Set<MIDIOutputEndpoint> {
    /// Returns the current output endpoints in the system.
    public static func currentOutputs() -> Self {
        Set(getSystemSourceEndpoints())
    }
}

extension [MIDIOutputEndpoint] {
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func currentOutputs() -> Self {
        getSystemSourceEndpoints()
    }
}

#endif
