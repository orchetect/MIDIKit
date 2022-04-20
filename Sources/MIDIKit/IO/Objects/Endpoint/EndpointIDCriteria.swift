//
//  Endpoint IDCriteria.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// Enum describing the criteria with which to identify endpoints.
    ///
    /// It is recommended to use `uniqueID` primarily. For added resiliency, it is also possible to use `uniqueID` with fallback criteria in the event the endpoint provider does not correctly restore its unique identifier number.
    public enum EndpointIDCriteria<T: MIDIIOObjectProtocol> {
        
        /// Utilizes first endpoint matching the endpoint name.
        /// Use of this is discouraged outside of debugging, since multiple endpoints can potentially share the same name in the system.
        case name(String)
        
        /// Utilizes first endpoint matching the display name.
        /// Use of this is discouraged outside of debugging, since multiple endpoints can potentially share the same display name in the system.
        case displayName(String)
        
        /// Endpoint matching the unique ID. (Recommended)
        /// This is typically the primary piece of criteria that should be used to persistently identify a unique endpoint in the system.
        case uniqueID(T.UniqueID)
        
        /// Priority is given to the endpoint matching the given unique ID. If an endpoint is not found with that ID, the first endpoint matching the display name is used.
        /// This may be useful in the event an endpoint vendor does not correctly maintain its own unique identifier number persistently.
        /// However it is still recommended to use the `uniqueID` exclusive case where possible and not rely on falling back to fuzzy criteria such as display name.
        case uniqueIDWithFallback(id: T.UniqueID,
                                  fallbackDisplayName: String)
        
    }
    
}

extension MIDI.IO {
    
    /// Enum describing the criteria with which to identify input endpoints.
    public typealias InputEndpointIDCriteria = MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>
    
    /// Enum describing the criteria with which to identify output endpoints.
    public typealias OutputEndpointIDCriteria = MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint>
    
}

extension MIDI.IO.EndpointIDCriteria: Equatable where T : MIDIIOObjectProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch lhs {
        case .name(let lhsName):
            guard case .name(let rhsName) = rhs else { return false }
            return lhsName == rhsName
            
        case .displayName(let lhsDisplayName):
            guard case .displayName(let rhsDisplayName) = rhs else { return false }
            return lhsDisplayName == rhsDisplayName
            
        case .uniqueID(let lhsUniqueID):
            guard case .uniqueID(let rhsUniqueID) = rhs else { return false }
            return lhsUniqueID.isEqual(to: rhsUniqueID)
            
        case .uniqueIDWithFallback(id: let lhsUniqueID,
                                   fallbackDisplayName: let lhsFallbackDisplayName):
            guard case .uniqueIDWithFallback(id: let rhsUniqueID,
                                             fallbackDisplayName: let rhsFallbackDisplayName) = rhs
            else { return false }
            
            return lhsUniqueID.isEqual(to: rhsUniqueID)
                && lhsFallbackDisplayName == rhsFallbackDisplayName
        }
        
    }
    
}

extension MIDI.IO.EndpointIDCriteria: Hashable where T : MIDIIOObjectProtocol {
    
    public func hash(into hasher: inout Hasher) {
        
        switch self {
        case .name(let name):
            hasher.combine("name")
            hasher.combine(name)
            
        case .displayName(let displayName):
            hasher.combine("displayName")
            hasher.combine(displayName)
            
        case .uniqueID(let uniqueID):
            hasher.combine("uniqueID")
            uniqueID.hash(into: &hasher)
            
        case .uniqueIDWithFallback(id: let uniqueID,
                                   fallbackDisplayName: let fallbackDisplayName):
            hasher.combine("uniqueIDWithFallback")
            uniqueID.hash(into: &hasher)
            fallbackDisplayName.hash(into: &hasher)
            
        }
        
    }
    
}

extension MIDI.IO.EndpointIDCriteria: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .name(let endpointName):
            return "EndpointName: \(endpointName.quoted)"
            
        case .displayName(let displayName):
            return "EndpointDisplayName: \(displayName.quoted))"
            
        case .uniqueID(let uniqueID):
            return "UniqueID: \(uniqueID)"
            
        case .uniqueIDWithFallback(id: let uniqueID,
                                   fallbackDisplayName: let fallbackDisplayName):
            return "UniqueID: \(uniqueID) with fallback EndpointDisplayName: \(fallbackDisplayName.quoted)"
        }
        
    }
    
}

extension MIDI.IO.EndpointIDCriteria where T : MIDIIOEndpointProtocol {
    
    /// A MIDI endpoint.
    public static func endpoint(_ endpoint: T) -> Self {
        
        if !endpoint.displayName.isEmpty {
            return .uniqueIDWithFallback(id: endpoint.uniqueID,
                                         fallbackDisplayName: endpoint.displayName)
        } else {
            return .uniqueID(endpoint.uniqueID)
        }
        
    }
    
}

extension MIDI.IO.EndpointIDCriteria where T : MIDIIOEndpointProtocol {
    
    /// Uses the criteria to find the first match and returns it if found.
    internal func locate(in endpoints: [T]) -> T? {
        
        switch self {
        case .name(let endpointName):
            return endpoints
                .filter(name: endpointName)
                .first
            
        case .displayName(let endpointName):
            return endpoints
                .filter(displayName: endpointName)
                .first
            
        case .uniqueID(let uniqueID):
            return endpoints
                .first(whereUniqueID: uniqueID)
            
        case .uniqueIDWithFallback(id: let uniqueID,
                                   fallbackDisplayName: let fallbackDisplayName):
            return endpoints
                .first(whereUniqueID: uniqueID,
                       fallbackDisplayName: fallbackDisplayName,
                       ignoringEmpty: true)
            
        }
        
    }
    
}
