//
//  MIDIProtocolVersion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

/// MIDI protocol version.
public enum MIDIProtocolVersion: Equatable, Hashable {
    /// MIDI 1.0
    ///
    /// MIDI 1.0 defines the original MIDI specification as ratified in the mid-1980s with minor
    /// revisions through 1996.
    case midi1_0
    
    /// MIDI 2.0
    ///
    /// MIDI 2.0 defines new packet formats and events over top of the MIDI 1.0 specification and
    /// underlying transport.
    ///
    /// > TMA (The MIDI Association) states: "MIDI 2.0 is an extension of MIDI 1.0. It does not
    /// > replace MIDI 1.0 but builds on the core principles, architecture, and semantics of MIDI
    /// > 1.0. MIDI 2.0 is not a stand-alone specification. Manufacturers and developers must have a
    /// > thorough understanding of MIDI 1.0 in order to implement MIDI 2.0.
    case midi2_0
}

extension MIDIProtocolVersion: CustomStringConvertible {
    public var description: String {
        switch self {
        case .midi1_0:
            return "MIDI 1.0"
    
        case .midi2_0:
            return "MIDI 2.0"
        }
    }
}

extension MIDIProtocolVersion: Sendable { }
