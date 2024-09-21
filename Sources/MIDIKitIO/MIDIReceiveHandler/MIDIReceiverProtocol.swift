//
//  MIDIReceiverProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// MIDI I/O Receive Handler Protocol.
///
/// For backwards compatibility with older operating systems,
/// both `MIDIReadBlock` (old Core MIDI API)
/// and `MIDIReceiveBlock` (new Core MIDI API) must be handled.
public protocol MIDIReceiverProtocol: AnyObject {
    /// CoreMIDI `MIDIReadBlock`
    /// (deprecated after macOS 11 / iOS 14)
    func packetListReceived(
        _ packets: [MIDIPacketData]
    )
    
    /// CoreMIDI `MIDIReceiveBlock`
    /// (introduced in macOS 11 / iOS 14)
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    func eventListReceived(
        _ packets: [UniversalMIDIPacketData],
        protocol midiProtocol: MIDIProtocolVersion
    )
}

#endif
