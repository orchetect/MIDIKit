//
//  MIDIManagedReceivesMessages.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// ``MIDIManager`` object trait adopted by objects that receive MIDI messages.
public protocol MIDIManagedReceivesMessages: MIDIManaged {
    /// MIDI Protocol version used for this endpoint.
    /* public private(set) */ var midiProtocol: MIDIProtocolVersion { get }
}

#endif
