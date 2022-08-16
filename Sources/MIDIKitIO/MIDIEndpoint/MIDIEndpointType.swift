//
//  MIDIEndpointType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// The specialized type of a MIDI endpoint (input/output).
public enum MIDIEndpointType: Equatable, Hashable, CaseIterable {
    case input
    case output
}

#endif
