//
//  MIDIEndpointType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

public enum MIDIEndpointType: Equatable, Hashable, CaseIterable {
    case input
    case output
}

#endif
