//
//  MIDIEndpointFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Endpoint filter rules.
public struct MIDIEndpointFilter: Equatable, Hashable {
    /// Virtual endpoints owned by the MIDI I/O ``MIDIManager`` instance.
    public var owned: Bool = false
    
    /// Endpoints matching the given criteria.
    public var criteria: Set<MIDIEndpointIdentity> = []
    
    /// Endpoint filter rules.
    public init(
        owned: Bool = false,
        criteria: Set<MIDIEndpointIdentity> = []
    ) {
        self.owned = owned
        self.criteria = criteria
    }
    
    /// Endpoint filter rules.
    @_disfavoredOverload
    public init(
        owned: Bool = false,
        criteria: [MIDIEndpointIdentity]
    ) {
        self.owned = owned
        self.criteria = Set(criteria)
    }
    
    /// Endpoint filter rules.
    @_disfavoredOverload
    public init<T: MIDIEndpoint & Hashable>(
        owned: Bool = false,
        criteria: Set<T>
    ) {
        self.owned = owned
    
        let ids = criteria.asAnyEndpoints().asIdentities()
        self.criteria = Set(ids)
    }
    
    /// Endpoint filter rules.
    @_disfavoredOverload
    public init<T: MIDIEndpoint & Hashable>(
        owned: Bool = false,
        criteria: [T]
    ) {
        self.init(
            owned: owned,
            criteria: Set(criteria)
        )
    }
}

extension MIDIEndpointFilter {
    /// Convenience constructor to return default endpoint filter.
    public static func `default`() -> Self {
        .init()
    }
    
    /// Convenience constructor to return an instance of `owned == true` and empty criteria.
    public static func owned() -> Self {
        .init(
            owned: true,
            criteria: []
        )
    }
}

// MARK: - Collection Methods

extension Collection where Element: MIDIEndpoint {
    public func filter(
        using endpointFilter: MIDIEndpointFilter,
        in manager: MIDIManager,
        isIncluded: Bool = true
    ) -> [Element] {
        filter { endpoint in
            if !endpointFilter.criteria.isEmpty {
                guard endpointFilter.criteria
                    .allSatisfy({ $0.matches(endpoint: endpoint) }) != isIncluded
                else { return false }
            }
            
            if endpointFilter.owned {
                let inputs = manager.managedInputs.map(\.value.endpoint).asAnyEndpoints()
                let outputs = manager.managedOutputs.map(\.value.endpoint).asAnyEndpoints()
                guard (inputs + outputs).contains(endpoint.asAnyEndpoint()) != isIncluded
                else { return false }
            }
            return true
        }
    }
}

#endif
