//
//  MIDIEventList PacketPointers.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

@available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
extension UnsafePointer where Pointee == MIDIEventList {
    
    @inline(__always)
    func packetsPointers() -> [UnsafePointer<MIDIEventPacket>] {
        
        Array(unsafeSequence())
        
    }
    
    @inline(__always)
    func packets() -> [MIDI.Packet.UniversalPacketData] {
        
        unsafeSequence().map { MIDI.Packet.UniversalPacketData($0) }
        
    }
    
}
