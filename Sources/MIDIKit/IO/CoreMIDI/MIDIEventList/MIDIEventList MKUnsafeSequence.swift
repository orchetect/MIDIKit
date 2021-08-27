//
//  MIDIEventList MKUnsafeSequence.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import MIDIKitC

extension UnsafePointer where Pointee == MIDIEventList {
    
    /// MIDIKit backwards-compatible implementation of CoreMIDI's `MIDIPacketList.UnsafeSequence`
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    public func mkUnsafeSequence() -> MIDIEventList.MKUnsafeSequence {
        
        MIDIEventList.MKUnsafeSequence(self)
        
    }
    
}

extension MIDIEventList {
    
    /// MIDIKit backwards-compatible implementation of CoreMIDI's `MIDIEventList.UnsafeSequence`
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    public struct MKUnsafeSequence: Sequence {
        
        public typealias Element = MIDIEventPacket
        
        internal var packets: [MIDIEventPacket] = []
        
        public init(_ midiPacketListPtr: UnsafePointer<MIDIEventList>) {
            
            guard midiPacketListPtr.pointee.numPackets > 0 else { return }
            
            var packet = midiPacketListPtr.pointee.packet
            
            // first packet
            packets.append(midiPacketListPtr.pointee.packet)
            
            for _ in 0...midiPacketListPtr.pointee.numPackets {
                MIDIEventPacketNext(&packet)
                packets.append(midiPacketListPtr.pointee.packet)
            }
            
//            CMIDIEventListIterate(midiPacketListPtr) {
//                guard let unwrappedPtr = $0 else { return }
//                pointers.append(unwrappedPtr)
//            }
            
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

