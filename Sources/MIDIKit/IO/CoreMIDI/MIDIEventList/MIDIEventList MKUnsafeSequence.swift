//
//  MIDIEventList MKUnsafeSequence.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import MIDIKitC

extension UnsafePointer where Pointee == MIDIEventList {
    
    /// MIDIKit sequence on `UnsafePointer<MIDIEventList>` to return `[MIDIEventPacket]`
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    public func mkSequence() -> MIDIEventList.MKSequence {
        
        MIDIEventList.MKSequence(self)
        
    }
    
}

extension MIDIEventList {
    
    /// MIDIKit sequence on `UnsafePointer<MIDIEventList>` to return `[MIDIEventPacket]`
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    public struct MKSequence: Sequence {
        
        public typealias Element = MIDIEventPacket
        
        internal var packets: [MIDIEventPacket] = []
        
        public init(_ midiPacketListPtr: UnsafePointer<MIDIEventList>) {
            
            let numPackets = midiPacketListPtr.pointee.numPackets
            
            guard numPackets > 0 else { return }
            
            var packet = midiPacketListPtr.pointee.packet
            
            // first packet
            packets.append(midiPacketListPtr.pointee.packet)
            
            // subsequent packets, if available
            for _ in 1..<numPackets {
                MIDIEventPacketNext(&packet)
                packets.append(midiPacketListPtr.pointee.packet)
            }
            
        }
        
        public func makeIterator() -> Iterator {
            Iterator(packets)
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
    
}

