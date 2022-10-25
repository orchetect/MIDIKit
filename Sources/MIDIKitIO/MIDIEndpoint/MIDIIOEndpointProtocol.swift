//
//  MIDIIOEndpointProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Public Protocol

public protocol MIDIIOEndpointProtocol: MIDIIOObject {
    /// Display name of the endpoint.
    /// This typically includes the model number and endpoint name.
    var displayName: String { get }
    
    // implemented in extension _MIDIIOEndpointProtocol
    
    /// Returns the entity the endpoint originates from.
    /// For virtual endpoints, this will return `nil`.
    func getEntity() -> MIDIEntity?
    
    /// Returns the device the endpoint originates from.
    /// For virtual endpoints, this will return `nil`.
    func getDevice() -> MIDIDevice?
    
    /// Returns the endpoint as a type-erased ``AnyMIDIEndpoint``.
    func asAnyEndpoint() -> AnyMIDIEndpoint
}

// MARK: - Internal Protocol

internal protocol _MIDIIOEndpointProtocol: MIDIIOEndpointProtocol { }

// MIDIIOEndpointProtocol implementation

extension _MIDIIOEndpointProtocol {
    public func getEntity() -> MIDIEntity? {
        try? getSystemEntity(for: coreMIDIObjectRef)
    }
    
    public func getDevice() -> MIDIDevice? {
        guard let entity = getEntity() else { return nil }
        return try? getSystemDevice(for: entity.coreMIDIObjectRef)
    }
}

// MARK: - Additional properties

extension MIDIIOEndpointProtocol {
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
