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
    public init(
        owned: Bool = false,
        criteria: Set<some MIDIEndpoint & Hashable>
    ) {
        self.owned = owned
    
        let ids = criteria.asAnyEndpoints().asIdentities()
        self.criteria = Set(ids)
    }
    
    /// Endpoint filter rules.
    @_disfavoredOverload
    public init(
        owned: Bool = false,
        criteria: [some MIDIEndpoint & Hashable]
    ) {
        self.init(
            owned: owned,
            criteria: Set(criteria)
        )
    }
}

extension MIDIEndpointFilter {
    /// Process a collection of MIDI endpoints events using this filter.
    ///
    /// Alternatively, a `Collection` category method is available:
    ///
    /// ```swift
    /// let endpoints: [MIDIInputEndpoint] = [ ... ]
    /// let filter = MIDIEndpointFilter( ... )
    ///
    /// // filter only matches
    /// let filtered = endpoints.filter(filter, in: midiManager)
    ///
    /// // filter by dropping matches
    /// let filtered = endpoints.filter(dropping: filter, in: midiManager)
    /// ```
    ///
    /// - Parameters:
    ///   - endpoints: Collection of endpoints to filter.
    ///   - mask: Filter behavior.
    ///   - manager: Reference to the MIDI manager.
    public func apply<Element: MIDIEndpoint>(
        to endpoints: some Collection<Element>,
        mask: MIDIEndpointFilterMask,
        in manager: MIDIManager
    ) -> [Element] {
        endpoints.filter(mask, self, in: manager)
    }
}

extension MIDIEndpointFilter: Sendable { }

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

// MARK: - Filter Mask

public enum MIDIEndpointFilterMask: Equatable, Hashable {
    /// Filter by keeping only endpoints that match the filter.
    case only
    
    /// Filter by dropping endpoints that match the filter and retaining all others.
    case drop
}

extension MIDIEndpointFilterMask: Sendable { }

public enum MIDIEndpointMaskedFilter: Equatable, Hashable {
    /// Filter by keeping only endpoints that match the filter.
    case only(MIDIEndpointFilter)
    
    /// Filter by dropping endpoints that match the filter and retaining all others.
    case drop(MIDIEndpointFilter)
}

extension MIDIEndpointMaskedFilter: Sendable { }

// MARK: - Collection Methods

extension Collection where Element: MIDIEndpoint {
    // MARK: - Filter Mask Methods
    
    /// Return a new endpoint collection filtered by the given criteria.
    ///
    /// - Parameters:
    ///   - mask: Filter behavior.
    ///   - endpointFilter: Filter to use.
    ///   - manager: Reference to the MIDI manager.
    public func filter(
        _ mask: MIDIEndpointFilterMask,
        _ endpointFilter: MIDIEndpointFilter,
        in manager: MIDIManager
    ) -> [Element] {
        switch mask {
        case .only:
            return filter(endpointFilter, in: manager)
        case .drop:
            return filter(dropping: endpointFilter, in: manager)
        }
    }
    
    /// Return a new endpoint collection filtered by the given criteria.
    ///
    /// - Parameters:
    ///   - maskedFilter: Masked filter to use.
    ///   - manager: Reference to the MIDI manager.
    public func filter(
        _ maskedFilter: MIDIEndpointMaskedFilter,
        in manager: MIDIManager
    ) -> [Element] {
        switch maskedFilter {
        case let .only(endpointFilter):
            return filter(endpointFilter, in: manager)
        case let .drop(endpointFilter):
            return filter(dropping: endpointFilter, in: manager)
        }
    }
    
    // MARK: - Filter Methods
    
    /// Return a new endpoint collection filtered by keeping only endpoints matching the given
    /// criteria.
    public func filter(
        _ endpointFilter: MIDIEndpointFilter,
        in manager: MIDIManager
    ) -> [Element] {
        filter(
            endpointFilter,
            ownedInputs: Array(manager.managedInputs.values),
            ownedOutputs: Array(manager.managedOutputs.values)
        )
    }
    
    /// Return a new endpoint collection filtered by keeping only endpoints matching the given
    /// criteria.
    func filter(
        _ endpointFilter: MIDIEndpointFilter,
        ownedInputs: [MIDIInput],
        ownedOutputs: [MIDIOutput]
    ) -> [Element] {
        filter(
            endpointFilter,
            ownedInputEndpoints: ownedInputs.map(\.endpoint),
            ownedOutputEndpoints: ownedOutputs.map(\.endpoint)
        )
    }
    
    /// Return a new endpoint collection filtered by keeping only endpoints matching the given
    /// criteria.
    func filter(
        _ endpointFilter: MIDIEndpointFilter,
        ownedInputEndpoints: [MIDIInputEndpoint],
        ownedOutputEndpoints: [MIDIOutputEndpoint]
    ) -> [Element] {
        filter { endpoint in
            if !endpointFilter.criteria.isEmpty {
                guard endpointFilter.criteria
                    .contains(where: { $0.matches(endpoint: endpoint) })
                else { return false }
            }
            
            if endpointFilter.owned {
                let inputs = ownedInputEndpoints.asAnyEndpoints()
                let outputs = ownedOutputEndpoints.asAnyEndpoints()
                guard (inputs + outputs)
                    .contains(endpoint.asAnyEndpoint())
                else { return false }
            }
            return true
        }
    }
    
    /// Return a new endpoint collection filtered by excluding endpoints matching the given
    /// criteria.
    public func filter(
        dropping endpointFilter: MIDIEndpointFilter,
        in manager: MIDIManager
    ) -> [Element] {
        filter(
            dropping: endpointFilter,
            ownedInputs: Array(manager.managedInputs.values),
            ownedOutputs: Array(manager.managedOutputs.values)
        )
    }
    
    /// Return a new endpoint collection filtered by excluding endpoints matching the given
    /// criteria.
    func filter(
        dropping endpointFilter: MIDIEndpointFilter,
        ownedInputs: [MIDIInput],
        ownedOutputs: [MIDIOutput]
    ) -> [Element] {
        filter(
            dropping: endpointFilter,
            ownedInputEndpoints: ownedInputs.map(\.endpoint),
            ownedOutputEndpoints: ownedOutputs.map(\.endpoint)
        )
    }
    
    /// Return a new endpoint collection filtered by excluding endpoints matching the given
    /// criteria.
    func filter(
        dropping endpointFilter: MIDIEndpointFilter,
        ownedInputEndpoints: [MIDIInputEndpoint],
        ownedOutputEndpoints: [MIDIOutputEndpoint]
    ) -> [Element] {
        filter { endpoint in
            if !endpointFilter.criteria.isEmpty {
                guard !endpointFilter.criteria
                    .contains(where: { $0.matches(endpoint: endpoint) })
                else { return false }
            }
            
            if endpointFilter.owned {
                let inputs = ownedInputEndpoints.asAnyEndpoints()
                let outputs = ownedOutputEndpoints.asAnyEndpoints()
                guard !(inputs + outputs)
                    .contains(endpoint.asAnyEndpoint())
                else { return false }
            }
            return true
        }
    }
}

#endif
