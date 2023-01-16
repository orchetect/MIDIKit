//
//  MIDIEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Public Protocol

public protocol MIDIEndpoint: MIDIIOObject {
    /// Display name of the endpoint.
    /// This typically includes the model number and endpoint name.
    var displayName: String { get }
    
    // implemented in extension _MIDIEndpoint
    
    /// Returns the entity the endpoint originates from.
    /// For virtual endpoints, this will return `nil`.
    var entity: MIDIEntity? { get }
    
    /// Returns the device the endpoint originates from.
    /// For virtual endpoints, this will return `nil`.
    var device: MIDIDevice? { get }
    
    /// Returns the endpoint as a type-erased ``AnyMIDIEndpoint``.
    func asAnyEndpoint() -> AnyMIDIEndpoint
}

// MARK: - Internal Protocol

internal protocol _MIDIEndpoint: MIDIEndpoint { }

// MIDIEndpoint implementation

extension _MIDIEndpoint {
    /// Returns the entity that owns the endpoint, if present.
    public var entity: MIDIEntity? {
        try? getSystemEntity(for: coreMIDIObjectRef)
    }
    
    /// Returns the device that owns the endpoint, if present.
    public var device: MIDIDevice? {
        guard let entity = entity else { return nil }
        return try? getSystemDevice(for: entity.coreMIDIObjectRef)
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
    
    /// Makes a virtual endpoint in the system invisible to the user.
    func hide() throws {
        try MIDIKitIO.hide(endpoint: coreMIDIObjectRef)
    }
    
    /// Makes a virtual endpoint in the system visible to the user.
    func show() throws {
        try MIDIKitIO.show(endpoint: coreMIDIObjectRef)
    }
}

#endif
