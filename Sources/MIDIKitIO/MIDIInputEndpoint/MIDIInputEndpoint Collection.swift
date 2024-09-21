//
//  MIDIInputEndpoint Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Static conveniences

extension Set<MIDIEndpointIdentity> {
    /// Returns the current input endpoints in the system.
    public static func currentInputs() -> Self {
        Set(getSystemDestinationEndpoints().asIdentities())
    }
}

extension [MIDIEndpointIdentity] {
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func currentInputs() -> Self {
        getSystemDestinationEndpoints().asIdentities()
    }
}

extension Set<MIDIInputEndpoint> {
    /// Returns the current input endpoints in the system.
    public static func currentInputs() -> Self {
        Set(getSystemDestinationEndpoints())
    }
}

extension [MIDIInputEndpoint] {
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func currentInputs() -> Self {
        getSystemDestinationEndpoints()
    }
}

#endif
