//
//  MIDIManaged.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Public Protocol

/// ``MIDIManager`` object trait adopted by objects that the manager manages.
public protocol MIDIManaged: AnyObject {
    /// Core MIDI API version used to create the endpoint
    /// and send/receive MIDI messages (if applicable).
    /* public private(set) */ var api: CoreMIDIAPIVersion { get }
}

#endif
