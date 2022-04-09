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
        
        packetPointers().map { MIDI.Packet.PacketData($0) }
        
    }
    
    /// Internal:
    /// Returns array of Core MIDI `MIDIPacket` pointers.
    @inline(__always)
    internal func packetPointers() -> [UnsafePointer<MIDIPacket>] {
        
        // prefer newer Core MIDI API if platform supports it
        
        if #available(macOS 10.15, iOS 13.0, macCatalyst 13.0, *) {
            return Array(unsafeSequence())
        } else {
            return packetPointerSequence().pointers
        }
        
    }
    
    /// Internal:
    /// Returns a sequence of Core MIDI `MIDIPacket` pointers.
    internal func packetPointerSequence() -> MIDIPacketList.PointerSequence {
        
        MIDIPacketList.PointerSequence(self)
        
    }
    
}

extension MIDIPacketList {
    
    /// Internal:
    /// Returns a sequence of Core MIDI `MIDIPacket` pointers.
    internal struct PointerSequence: Sequence {
        
        public typealias Element = UnsafePointer<MIDIPacket>
        
        internal var pointers: [UnsafePointer<MIDIPacket>] = []
        
        public init(_ midiPacketListPtr: UnsafePointer<MIDIPacketList>) {
            
            pointers.reserveCapacity(Int(midiPacketListPtr.pointee.numPackets))
            
            iterateMIDIPacketList(midiPacketListPtr) {
                pointers.append($0)
            }
            
            assert(pointers.count == midiPacketListPtr.pointee.numPackets,
                   "Packet count does not match iterated count.")
            
        }
        
        public func makeIterator() -> Iterator {
            
            Iterator(pointers)
            
        }
        
        public struct Iterator: IteratorProtocol {
            
            let pointers: [Element]
            var idx: Array<Element>.Index
            
            init(_ pointers: [Element]) {
                self.idx = pointers.startIndex
                self.pointers = pointers
            }
            
            public mutating func next() -> Element? {
                
                guard pointers.indices.contains(idx) else { return nil }
                
                defer { idx += idx.advanced(by: 1) }
                
                return pointers[idx]
                
            }
            
        }
        
    }
    
    /// Utility to iterate over packets in a `MIDIPacketList` and encapsulate the ugly Obj-C/Swift pointer access.
    fileprivate static func iterateMIDIPacketList(
        _ midiPacketListPtr: UnsafePointer<MIDIPacketList>,
        _ closure: (UnsafePointer<MIDIPacket>) -> Void
    ) {
        
        if midiPacketListPtr.pointee.numPackets == 0 {
            return
        }
        
        // when written in Obj-C, we'd cast the packet list
        // to MIDIPacket to access the first packet
        var midiPacket = UnsafeRawPointer(midiPacketListPtr)
            .bindMemory(to: MIDIPacket.self, capacity: 1)
        
        // call closure for first packet
        closure(midiPacket)
        
        // call closure for subsequent packets, if they exist
        for _ in 1 ..< midiPacketListPtr.pointee.numPackets {
            midiPacket = UnsafePointer(MIDIPacketNext(midiPacket))
            closure(midiPacket)
        }
        
    }
    
}
