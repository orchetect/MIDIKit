//
//  MIDIIOManagedProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Public Protocol

public protocol MIDIIOManagedProtocol: AnyObject {
    /// Core MIDI API version used to create the endpoint and send/receive MIDI messages (if applicable).
    /* public private(set) */ var api: MIDI.IO.APIVersion { get }
}

// MARK: - Internal Protocol

internal protocol _MIDIIOManagedProtocol: MIDIIOManagedProtocol {
    /// Internal:
    /// Reference to owning `MIDI.IO.Manager`
    /* weak */ var midiManager: MIDI.IO.Manager? { get set }
}

#endif
