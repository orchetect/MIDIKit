//
//  EndpointFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.IO {
    
    /// Endpoint filter rules.
    public struct EndpointFilter<T: MIDIIOEndpointProtocol & Hashable>: Equatable, Hashable {
        
        /// Virtual endpoints owned by the MIDI I/O `Manager` instance.
        public var owned: Bool = false
        
        /// Endpoints matching the given criteria.
        public var criteria: Set<MIDI.IO.EndpointIDCriteria<T>> = []
        
        public init(owned: Bool = false,
                    criteria: Set<MIDI.IO.EndpointIDCriteria<T>> = []) {
            
            self.owned = owned
            self.criteria = criteria
            
        }
        
        @_disfavoredOverload
        public init(owned: Bool = false,
                    criteria: [MIDI.IO.EndpointIDCriteria<T>]) {
            
            self.owned = owned
            self.criteria = Set(criteria)
            
        }
        
        @_disfavoredOverload
        public init(owned: Bool = false,
                    criteria: Set<T>) {
            
            self.owned = owned
            
            let ids = criteria.asAnyEndpoints().map { $0.uniqueID.coreMIDIUniqueID }
            let typedIDs = ids.map { T.UniqueID($0) }
            let typedCrit = typedIDs.map { MIDI.IO.EndpointIDCriteria<T>.uniqueID($0) }
            self.criteria = Set(typedCrit)
            
        }
        
        @_disfavoredOverload
        public init(owned: Bool = false,
                    criteria: [T]) {
            
            self.init(owned: owned, criteria: Set(criteria))
            
        }
        
    }
    
}

extension MIDI.IO {
    
    /// Enum describing the rules with which to filter input endpoints.
    public typealias InputEndpointFilter = MIDI.IO.EndpointFilter<MIDI.IO.InputEndpoint>
    
    /// Enum describing the rules with which to filter output endpoints.
    public typealias OutputEndpointFilter = MIDI.IO.EndpointFilter<MIDI.IO.OutputEndpoint>
    
}

extension MIDI.IO.EndpointFilter {
    
    public static func `default`() -> Self {
        
        .init()
        
    }
    
    /// Convenience constructor to return an instance of `owned == true` and empty criteria.
    public static func owned() -> Self {
        
        .init(owned: true, criteria: [])
        
    }
    
}
