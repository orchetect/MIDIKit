//
//  MIDIProtocolVersion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

@_implementationOnly import CoreMIDI

/// MIDI protocol version.
public enum MIDIProtocolVersion: Equatable, Hashable {
    /// MIDI 1.0
    case _1_0
    
    /// MIDI 2.0
    case _2_0
}

extension MIDIProtocolVersion: CustomStringConvertible {
    public var description: String {
        switch self {
        case ._1_0:
            return "MIDI 1.0"
    
        case ._2_0:
            return "MIDI 2.0"
        }
    }
}
