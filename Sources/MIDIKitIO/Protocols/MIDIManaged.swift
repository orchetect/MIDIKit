//
//  MIDIManaged.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Public Protocol

public protocol MIDIManaged: AnyObject {
    /// Core MIDI API version used to create the endpoint
    /// and send/receive MIDI messages (if applicable).
    /* public private(set) */ var api: CoreMIDIAPIVersion { get }
}

// MARK: - Internal Protocol

internal protocol _MIDIManaged: MIDIManaged {
    /// Internal:
    /// Reference to owning ``MIDIManager``
    /* weak */ var midiManager: MIDIManager? { get set }
}

#endif
