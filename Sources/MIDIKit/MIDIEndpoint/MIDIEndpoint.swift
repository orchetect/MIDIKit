//
//  MIDIEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Public Protocol

public protocol MIDIEndpoint: MIDIIOObject {
    /// Display name of the endpoint.
    /// This typically includes the model number and endpoint name.
    var displayName: String { get }
    
    // implemented in extension _MIDIEndpoint
    
    /// Returns the entity the endpoint originates from. For virtual endpoints, this will return `nil`.
    func getEntity() -> MIDIEntity?
    
    /// Returns the endpoint as a type-erased `AnyEndpoint`.
    func asAnyEndpoint() -> AnyMIDIEndpoint
}

// MARK: - Internal Protocol

internal protocol _MIDIEndpoint: MIDIEndpoint { }

// MIDIEndpoint implementation

extension _MIDIEndpoint {
    public func getEntity() -> MIDIEntity? {
        try? getSystemEntity(for: coreMIDIObjectRef)
    }
}

// MARK: - Additional properties

extension MIDIEndpoint {
    /// Returns `true` if the object exists in the system by querying Core MIDI.
    public var exists: Bool {
        getSystemDestinationEndpoint(matching: uniqueID) != nil
    }
    
    /// Returns endpoint identity criterium describing the endpoint.
    public func asIdentity() -> MIDIEndpointIdentity {
        .endpoint(self)
    }
}

#endif
