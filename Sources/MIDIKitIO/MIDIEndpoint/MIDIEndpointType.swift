//
//  MIDIEndpointType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// The specialized type of a MIDI endpoint (input/output).
public enum MIDIEndpointType {
    case input
    case output
}

extension MIDIEndpointType: Equatable { }

extension MIDIEndpointType: Hashable { }

extension MIDIEndpointType: CaseIterable { }

extension MIDIEndpointType: Sendable { }

#endif
