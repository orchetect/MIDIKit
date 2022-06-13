//
//  MIDIPacketList Packets.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension UnsafePointer where Pointee == MIDIPacketList {
    
    /// Internal:
    /// Returns array of MIDIKit `PacketData` instances.
    @inline(__always)
    internal func packets() -> [MIDI.Packet.PacketData] {
        
        if pointee.numPackets == 0 {
            return []
        }
        
        // prefer newer Core MIDI API if platform supports it
        
        if #available(macOS 10.15, iOS 13.0, macCatalyst 13.0, *) {
            return unsafeSequence().map {
                MIDI.Packet.PacketData($0)
            }
        } else {
            var packetDatas: [MIDI.Packet.PacketData] = []
            pointee.iteratePackets {
                packetDatas.append(MIDI.Packet.PacketData($0))
            }
            return packetDatas
        }
        
    }
    
}

extension MIDIPacketList {
    
    /// Iterates packeets in a `MIDIPacketList` and calls the closure for each packet.
    /// This is confirmed working on Mojave.
    /// There were numerous difficulties in reading MIDIPacketList on Mojave and earlier and this solution was stable.
    @inline(__always)
    fileprivate func iteratePackets(_ closure: (UnsafeMutablePointer<MIDIPacket>) -> Void) {
        
        withUnsafePointer(to: packet) { ptr in
            var idx: UInt32 = 0
            var p = UnsafeMutablePointer(mutating: ptr)
            while idx < numPackets {
                closure(p)
                if numPackets - idx > 0 { p = MIDIPacketNext(p) }
                idx += 1
            }
        }
        
    }
    
}
