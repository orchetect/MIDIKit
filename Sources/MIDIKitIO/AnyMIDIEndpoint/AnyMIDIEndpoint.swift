//
//  AnyMIDIEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// Type-erased box that can contain ``MIDIInputEndpoint`` or ``MIDIOutputEndpoint``.
public struct AnyMIDIEndpoint: _MIDIIOEndpointProtocol {
    // MARK: MIDIIOObject
    
    public var objectType: MIDIIOObjectType
    
    public let name: String
    
    public let uniqueID: MIDIIdentifier
    
    public let coreMIDIObjectRef: CoreMIDIEndpointRef
    
    public func asAnyMIDIIOObject() -> AnyMIDIIOObject {
        switch endpointType {
        case .input:
            let newEndpoint = MIDIInputEndpoint(from: coreMIDIObjectRef)
            return .inputEndpoint(newEndpoint)
        case .output:
            let newEndpoint = MIDIOutputEndpoint(from: coreMIDIObjectRef)
            return .outputEndpoint(newEndpoint)
        }
    }
    
    // MARK: MIDIEndpoint
    
    public let displayName: String
    
    public func asAnyEndpoint() -> AnyMIDIEndpoint {
        // // ridiculous but we have to fulfill the conformance requirement
        .init(self)
    }
    
    // MARK: Struct specific
    
    public let endpointType: MIDIEndpointType
    
    // MARK: Init
    
    internal init<E: _MIDIIOEndpointProtocol>(_ base: E) {
        switch base {
        case is MIDIInputEndpoint:
            objectType = .inputEndpoint
            endpointType = .input
    
        case is MIDIOutputEndpoint:
            objectType = .outputEndpoint
            endpointType = .output
    
        case let otherCast as Self:
            objectType = otherCast.objectType
            endpointType = otherCast.endpointType
    
        default:
            preconditionFailure("Unexpected MIDIIOEndpointProtocol type: \(base)")
        }
    
        coreMIDIObjectRef = base.coreMIDIObjectRef
        name = base.name
        displayName = base.displayName
        uniqueID = .init(base.uniqueID)
    }
}

extension AnyMIDIEndpoint: Equatable {
    // default implementation provided in MIDIIOObject
}

extension AnyMIDIEndpoint: Hashable {
    // default implementation provided in MIDIIOObject
}

extension AnyMIDIEndpoint: Identifiable {
    // default implementation provided by MIDIIOObject
}

extension AnyMIDIEndpoint: CustomDebugStringConvertible {
    public var debugDescription: String {
        "AnyMIDIEndpoint(name: \(name.quoted), uniqueID: \(uniqueID))"
    }
}

// MARK: - Extensions

extension _MIDIIOEndpointProtocol {
    /// Returns the endpoint as a type-erased ``AnyMIDIEndpoint``.
    public func asAnyEndpoint() -> AnyMIDIEndpoint {
        .init(self)
    }
}

extension Collection where Element: MIDIIOEndpointProtocol {
    /// Returns the collection as a collection of type-erased ``AnyMIDIEndpoint`` endpoints.
    public func asAnyEndpoints() -> [AnyMIDIEndpoint] {
        map { $0.asAnyEndpoint() }
    }
}

#endif
