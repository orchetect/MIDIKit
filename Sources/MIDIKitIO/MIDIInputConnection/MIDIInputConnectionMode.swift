//
//  MIDIInputConnectionMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// Behavior of a managed MIDI connection.
public enum MIDIInputConnectionMode: Equatable, Hashable {
    /// Specific endpoint(s) criteria.
    case outputs(matching: Set<MIDIEndpointIdentity>)
    
    /// Automatically connects to all endpoints.
    /// (Endpoint filters are respected.)
    ///
    /// Note that this mode overrides endpoints / identity criteria.
    case allOutputs
}

extension MIDIInputConnectionMode: Sendable { }

extension MIDIInputConnectionMode {
    /// Specific endpoint(s) criteria.
    @_disfavoredOverload
    public static func outputs(matching identities: [MIDIEndpointIdentity]) -> Self {
        .outputs(matching: Set(identities))
    }
    
    /// Specific endpoint(s) criteria.
    public static func outputs(_ endpoints: [MIDIOutputEndpoint]) -> Self {
        .outputs(matching: endpoints.asIdentities())
    }
    
    /// Empty endpoint(s) criteria set.
    public static let none: Self = .outputs(matching: [])
}

#endif
