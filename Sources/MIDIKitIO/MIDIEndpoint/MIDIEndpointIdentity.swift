//
//  MIDIEndpointIdentity.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI

/// Criterium with which to identify a MIDI endpoint.
///
/// It is recommended to use ``uniqueID(_:)`` primarily. For added resiliency, it is also possible
/// to use ``uniqueIDWithFallback(id:fallbackDisplayName:)`` with fallback criteria in the event the
/// endpoint provider does not correctly restore its unique identifier number.
public enum MIDIEndpointIdentity {
    /// Utilizes first endpoint matching the endpoint name. (Convenience, not recommended.)
    ///
    /// ⚠️ Use of this is discouraged outside of debugging, since multiple endpoints can potentially
    /// share the same name in the system.
    ///
    /// The best method is to use ``uniqueID(_:)``.
    case name(String)
    
    /// Utilizes first endpoint matching the display name. (Convenience, not recommended.)
    ///
    /// ⚠️ Use of this is discouraged outside of debugging, since multiple endpoints can potentially
    /// share the same display name in the system.
    ///
    /// The best method is to use ``uniqueID(_:)``.
    case displayName(String)
    
    /// Endpoint matching the unique ID. (Recommended)
    ///
    /// This is typically the primary piece of criterium that should be used to persistently
    /// identify a unique endpoint in the system.
    case uniqueID(MIDIIdentifier)
    
    /// Endpoint matching the unique ID primarily, with fallback display name criterium.
    ///
    /// Priority is given to the endpoint matching the given unique ID. If an endpoint is not found
    /// with that ID, the first endpoint matching the display name is used.
    ///
    /// This may be useful in the event an endpoint vendor does not correctly maintain its own
    /// unique identifier number persistently.
    ///
    /// ⚠️ However it is still recommended to use the ``uniqueID(_:)`` exclusive case where possible
    /// and not rely on falling back to fuzzy criteria such as display name.
    case uniqueIDWithFallback(
        id: MIDIIdentifier,
        fallbackDisplayName: String
    )
}

extension MIDIEndpointIdentity: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case let .name(lhsName):
            guard case let .name(rhsName) = rhs else { return false }
            return lhsName == rhsName
    
        case let .displayName(lhsDisplayName):
            guard case let .displayName(rhsDisplayName) = rhs else { return false }
            return lhsDisplayName == rhsDisplayName
    
        case let .uniqueID(lhsUniqueID):
            guard case let .uniqueID(rhsUniqueID) = rhs else { return false }
            return lhsUniqueID == rhsUniqueID
    
        case let .uniqueIDWithFallback(
            id: lhsUniqueID,
            fallbackDisplayName: lhsFallbackDisplayName
        ):
            guard case let .uniqueIDWithFallback(
                id: rhsUniqueID,
                fallbackDisplayName: rhsFallbackDisplayName
            ) = rhs
            else { return false }
    
            return lhsUniqueID == rhsUniqueID
                && lhsFallbackDisplayName == rhsFallbackDisplayName
        }
    }
}

extension MIDIEndpointIdentity: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .name(name):
            hasher.combine("name")
            hasher.combine(name)
    
        case let .displayName(displayName):
            hasher.combine("displayName")
            hasher.combine(displayName)
    
        case let .uniqueID(uniqueID):
            hasher.combine("uniqueID")
            uniqueID.hash(into: &hasher)
    
        case let .uniqueIDWithFallback(
            id: uniqueID,
            fallbackDisplayName: fallbackDisplayName
        ):
            hasher.combine("uniqueIDWithFallback")
            uniqueID.hash(into: &hasher)
            fallbackDisplayName.hash(into: &hasher)
        }
    }
}

extension MIDIEndpointIdentity: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .name(endpointName):
            return "Endpoint Name: \(endpointName.quoted)"
    
        case let .displayName(displayName):
            return "Endpoint Display Name: \(displayName.quoted))"
    
        case let .uniqueID(uniqueID):
            return "UniqueID: \(uniqueID)"
    
        case let .uniqueIDWithFallback(
            id: uniqueID,
            fallbackDisplayName: fallbackDisplayName
        ):
            return "UniqueID: \(uniqueID) with fallback EndpointDisplayName: \(fallbackDisplayName.quoted)"
        }
    }
}

extension MIDIEndpointIdentity {
    /// Returns endpoint identity criteria describing an endpoint.
    public static func endpoint<T: MIDIIOEndpointProtocol>(_ endpoint: T) -> Self {
        if !endpoint.displayName.isEmpty {
            return .uniqueIDWithFallback(
                id: endpoint.uniqueID,
                fallbackDisplayName: endpoint.displayName
            )
        } else {
            return .uniqueID(endpoint.uniqueID)
        }
    }
}

extension MIDIEndpointIdentity {
    /// Uses the identity criteria to find the first match in an endpoint collection.
    /// Returns `nil` if no matches are found.
    internal func locate<T: MIDIIOEndpointProtocol>(in endpoints: [T]) -> T? {
        switch self {
        case let .name(endpointName):
            return endpoints.first(whereName: endpointName)
    
        case let .displayName(endpointName):
            return endpoints.first(whereDisplayName: endpointName)
    
        case let .uniqueID(uniqueID):
            return endpoints.first(whereUniqueID: uniqueID)
    
        case let .uniqueIDWithFallback(
            id: uniqueID,
            fallbackDisplayName: fallbackDisplayName
        ):
            return endpoints.first(
                whereUniqueID: uniqueID,
                fallbackDisplayName: fallbackDisplayName,
                ignoringEmpty: true
            )
        }
    }
}

#endif
