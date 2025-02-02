//
//  MIDIEndpointFilterMask.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

public enum MIDIEndpointFilterMask {
    /// Filter by keeping only endpoints that match the filter.
    case only
    
    /// Filter by dropping endpoints that match the filter and retaining all others.
    case drop
}

extension MIDIEndpointFilterMask: Equatable { }

extension MIDIEndpointFilterMask: Hashable { }

extension MIDIEndpointFilterMask: Sendable { }

#endif
