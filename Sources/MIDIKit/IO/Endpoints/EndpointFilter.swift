//
//  EndpointFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation

extension MIDI.IO {
    
    /// Endpoint filter rules.
    public struct EndpointFilter: Equatable, Hashable {
        
        /// Virtual endpoints owned by the MIDI I/O `Manager` instance.
        public var owned: Bool = false
        
        /// Endpoints matching the given criteria.
        public var criteria: Set<MIDI.IO.EndpointIDCriteria> = []
        
        /// Endpoint filter rules.
        public init(owned: Bool = false,
                    criteria: Set<MIDI.IO.EndpointIDCriteria> = []) {
            
            self.owned = owned
            self.criteria = criteria
            
        }
        
        /// Endpoint filter rules.
        @_disfavoredOverload
        public init(owned: Bool = false,
                    criteria: [MIDI.IO.EndpointIDCriteria]) {
            
            self.owned = owned
            self.criteria = Set(criteria)
            
        }
        
        /// Endpoint filter rules.
        @_disfavoredOverload
        public init<T: MIDIIOEndpointProtocol & Hashable>(owned: Bool = false,
                                                          criteria: Set<T>) {
            
            self.owned = owned
            
            let ids = criteria.asAnyEndpoints().asCriteria()
            self.criteria = Set(ids)
            
        }
        
        /// Endpoint filter rules.
        @_disfavoredOverload
        public init<T: MIDIIOEndpointProtocol & Hashable>(owned: Bool = false,
                                                          criteria: [T]) {
            
            self.init(owned: owned,
                      criteria: Set(criteria))
            
        }
        
    }
    
}

extension MIDI.IO.EndpointFilter {
    
    /// Convenience constructor to return default endpoint filter.
    public static func `default`() -> Self {
        
        .init()
        
    }
    
    /// Convenience constructor to return an instance of `owned == true` and empty criteria.
    public static func owned() -> Self {
        
        .init(owned: true,
              criteria: [])
        
    }
    
}

#endif
