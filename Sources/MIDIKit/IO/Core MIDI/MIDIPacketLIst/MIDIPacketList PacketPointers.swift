//
//  MIDIPacketList PacketPointers.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

extension UnsafePointer where Pointee == MIDIPacketList {
    
    func packetsPointers() -> [UnsafePointer<MIDIPacket>] {
        
        // prefer newer Core MIDI API if platform supports it
        
        if #available(macOS 10.15, iOS 13.0, macCatalyst 13.0, *) {
            return Array(unsafeSequence())
        } else {
            return mkUnsafeSequence().pointers
        }
        
    }
    
    func packets() -> [MIDI.Packet.PacketData] {
        
        packetsPointers().map { MIDI.Packet.PacketData($0) }
        
    }
    
}
