//
//  AnyMIDIEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

/// Type-erased box that can contain `MIDIInputEndpoint` or `MIDIOutputEndpoint`.
public struct AnyMIDIEndpoint: _MIDIEndpointProtocol {
    public var objectType: MIDIIOObjectType
        
    public let endpointType: MIDIEndpointType
        
    // MARK: MIDIIOObjectProtocol
        
    public let name: String
        
    public let displayName: String
        
    public let uniqueID: MIDIIdentifier
        
    public let coreMIDIObjectRef: CoreMIDIEndpointRef
        
    // MARK: Init
        
    internal init<E: _MIDIEndpointProtocol>(_ base: E) {
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
            preconditionFailure("Unexpected MIDIEndpointProtocol type: \(base)")
        }
            
        coreMIDIObjectRef = base.coreMIDIObjectRef
        name = base.name
        displayName = base.displayName
        uniqueID = .init(base.uniqueID)
    }
}

extension AnyMIDIEndpoint: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension AnyMIDIEndpoint: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension AnyMIDIEndpoint: Identifiable {
    // default implementation provided by MIDIIOObjectProtocol
}

extension AnyMIDIEndpoint: CustomDebugStringConvertible {
    public var debugDescription: String {
        "AnyMIDIEndpoint(name: \(name.quoted), uniqueID: \(uniqueID))"
    }
}

// MARK: - Extensions

extension _MIDIEndpointProtocol {
    /// Returns the endpoint as a type-erased `AnyEndpoint`.
    public func asAnyEndpoint() -> AnyMIDIEndpoint {
        .init(self)
    }
}

extension Collection where Element: MIDIEndpointProtocol {
    /// Returns the collection as a collection of type-erased `AnyEndpoint` endpoints.
    public func asAnyEndpoints() -> [AnyMIDIEndpoint] {
        map { $0.asAnyEndpoint() }
    }
}

#endif
