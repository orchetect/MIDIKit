//
//  MIDIEndpointFilter Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

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
            filter(endpointFilter, in: manager)
        case .drop:
            filter(dropping: endpointFilter, in: manager)
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
            filter(endpointFilter, in: manager)
        case let .drop(endpointFilter):
            filter(dropping: endpointFilter, in: manager)
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
