//
//  MIDIIOReceiveHandlerProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

/// MIDI I/O Receive Handler Protocol.
///
/// For operating system backwards compatibility, both `MIDIReadBlock` (old CoreMIDI API) and `MIDIReceiveBlock` (new CoreMIDI API) must be handled.
public protocol MIDIIOReceiveHandlerProtocol {
    
    /// CoreMIDI `MIDIReadBlock` signature
    /// (deprecated after macOS 11 / iOS 14)
    @inline(__always) func midiReadBlock(
        _ packetListPtr: UnsafePointer<MIDIPacketList>,
        _ srcConnRefCon: UnsafeMutableRawPointer?
    )
    
    /// CoreMIDI `MIDIReceiveBlock` signature
    /// (introduced in macOS 11 / iOS 14)
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inline(__always) func midiReceiveBlock(
        _ eventListPtr: UnsafePointer<MIDIEventList>,
        _ srcConnRefCon: UnsafeMutableRawPointer?
    )
    
}
