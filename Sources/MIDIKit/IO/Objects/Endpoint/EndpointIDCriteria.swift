//
//  Endpoint IDCriteria.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// Enum describing the criteria with which to identify endpoints.
    public enum EndpointIDCriteria<T: MIDIIOObjectProtocol> {
        
        /// Utilizes first endpoint matching the endpoint name.
        /// Use of this is discouraged outside of debugging, since multiple endpoints can potentially share the same name in the system.
        case name(String)
        
        /// Utilizes first endpoint matching the display name.
        /// Use of this is discouraged outside of debugging, since multiple endpoints can potentially share the same name in the system.
        case displayName(String)
        
        /// Endpoint matching the unique ID.
        case uniqueID(T.UniqueID)
        
    }
    
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
            
        case .uniqueID(let uID):
            return "UniqueID: \(uID)"
            
        }
        
    }
    
}

extension MIDI.IO.EndpointIDCriteria where T : MIDIIOEndpointProtocol {
    
    /// A MIDI endpoint.
    public static func endpoint(_ endpoint: T) -> Self {
        
        .uniqueID(endpoint.uniqueID)
        
    }
    
}

extension MIDI.IO.EndpointIDCriteria where T : MIDIIOObjectProtocol {
    
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
            
        case .uniqueID(let uID):
            return endpoints
                .first(whereUniqueID: uID)
            
        }
        
    }
    
}
