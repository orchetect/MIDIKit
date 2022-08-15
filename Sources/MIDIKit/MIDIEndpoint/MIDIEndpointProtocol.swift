//
//  MIDIEndpointProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Public Protocol

public protocol MIDIEndpointProtocol: MIDIIOObject {
    /// Display name of the endpoint.
    /// This typically includes the model number and endpoint name.
    var displayName: String { get }
    
    // implemented in extension _MIDIEndpointProtocol
    
    /// Returns the entity the endpoint originates from. For virtual endpoints, this will return `nil`.
    func getEntity() -> MIDIEntity?
    
    /// Returns the endpoint as a type-erased `AnyEndpoint`.
    func asAnyEndpoint() -> AnyMIDIEndpoint
}

// MARK: - Internal Protocol

internal protocol _MIDIEndpointProtocol: MIDIEndpointProtocol { }

// MIDIEndpointProtocol implementation

extension _MIDIEndpointProtocol {
    public func getEntity() -> MIDIEntity? {
        try? getSystemEntity(for: coreMIDIObjectRef)
    }
}

// MARK: - Additional properties

extension MIDIEndpointProtocol {
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
