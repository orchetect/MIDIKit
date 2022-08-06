//
//  EndpointType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

extension MIDI.IO {
    public enum EndpointType: Equatable, Hashable, CaseIterable {
        case input
        case output
    }
}

#endif
