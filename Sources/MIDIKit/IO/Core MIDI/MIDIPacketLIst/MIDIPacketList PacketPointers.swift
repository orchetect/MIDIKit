//
//  MIDIPacketList PacketPointers.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension UnsafePointer where Pointee == MIDIPacketList {
    
    /// Internal:
    /// Returns array of Core MIDI `MIDIPacket` pointers.
    @inline(__always)
    internal func packetsPointers() -> [UnsafePointer<MIDIPacket>] {
        
        // prefer newer Core MIDI API if platform supports it
        
        if #available(macOS 10.15, iOS 13.0, macCatalyst 13.0, *) {
            return Array(unsafeSequence())
        } else {
            return mkUnsafeSequence().pointers
        }
        
    }
    
    /// Internal:
    /// Returns array of MIDIKit `PacketData` instances.
    @inline(__always)
    internal func packets() -> [MIDI.Packet.PacketData] {
        
        packetsPointers().map { MIDI.Packet.PacketData($0) }
        
    }
    
}
