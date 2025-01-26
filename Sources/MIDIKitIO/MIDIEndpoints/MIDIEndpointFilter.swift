//
//  MIDIEndpointFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Endpoint filter rules.
public struct MIDIEndpointFilter {
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

extension MIDIEndpointFilter: Equatable { }

extension MIDIEndpointFilter: Hashable { }

extension MIDIEndpointFilter: Sendable { }

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

// MARK: - Static Constructors

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

#endif
