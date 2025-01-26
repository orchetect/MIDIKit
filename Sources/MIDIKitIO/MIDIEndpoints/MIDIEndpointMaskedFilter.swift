//
//  MIDIEndpointMaskedFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

public enum MIDIEndpointMaskedFilter {
    /// Filter by keeping only endpoints that match the filter.
    case only(MIDIEndpointFilter)
    
    /// Filter by dropping endpoints that match the filter and retaining all others.
    case drop(MIDIEndpointFilter)
}

extension MIDIEndpointMaskedFilter: Equatable { }

extension MIDIEndpointMaskedFilter: Hashable { }

extension MIDIEndpointMaskedFilter: Sendable { }

#endif
