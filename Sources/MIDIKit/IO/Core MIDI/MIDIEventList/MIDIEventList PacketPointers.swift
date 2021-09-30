//
//  MIDIEventList PacketPointers.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

@available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
extension UnsafePointer where Pointee == MIDIEventList {
    
    /// Internal:
    /// Returns array of Core MIDI `MIDIEventPacket` pointers.
    @inline(__always)
    internal func packetsPointers() -> [UnsafePointer<MIDIEventPacket>] {
        
        Array(unsafeSequence())
        
    }
    
    /// Internal:
    /// Returns array of MIDIKit `UniversalPacketData` instances.
    @inline(__always)
    internal func packets() -> [MIDI.Packet.UniversalPacketData] {
        
        unsafeSequence().map { MIDI.Packet.UniversalPacketData($0) }
        
    }
    
}
