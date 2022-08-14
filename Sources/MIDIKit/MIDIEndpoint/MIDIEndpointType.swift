//
//  MIDIEndpointType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

public enum MIDIEndpointType: Equatable, Hashable, CaseIterable {
    case input
    case output
}

#endif
