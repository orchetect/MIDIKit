//
//  MIDIOutputConnectionMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// Behavior of a managed MIDI connection.
public enum MIDIOutputConnectionMode: Equatable, Hashable {
    /// Specific endpoint(s) criteria.
    case inputs(matching: Set<MIDIEndpointIdentity>)
    
    /// Automatically connects to all endpoints.
    /// (Endpoint filters are respected.)
    ///
    /// Note that this mode overrides endpoints / identity criteria.
    case allInputs
}

extension MIDIOutputConnectionMode {
    /// Specific endpoint(s) criteria.
    @_disfavoredOverload
    public static func inputs(matching identities: [MIDIEndpointIdentity]) -> Self {
        .inputs(matching: Set(identities))
    }
    
    /// Specific endpoint(s) criteria.
    public static func inputs(_ endpoints: [MIDIInputEndpoint]) -> Self {
        .inputs(matching: endpoints.asIdentities())
    }
    
    /// Empty endpoint(s) criteria set.
    public static let none: Self = .inputs(matching: [])
}

#endif
