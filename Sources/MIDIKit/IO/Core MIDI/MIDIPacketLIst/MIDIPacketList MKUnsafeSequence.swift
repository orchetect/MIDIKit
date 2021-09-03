//
//  MIDIPacketList MKUnsafeSequence.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import MIDIKitC

extension UnsafePointer where Pointee == MIDIPacketList {
    
    /// MIDIKit backwards-compatible implementation of Core MIDI's `MIDIPacketList.UnsafeSequence`
    internal func mkUnsafeSequence() -> MIDIPacketList.MKUnsafeSequence {
        
        MIDIPacketList.MKUnsafeSequence(self)
        
    }
    
}

extension MIDIPacketList {
    
    /// MIDIKit backwards-compatible implementation of Core MIDI's `MIDIPacketList.UnsafeSequence`
    internal struct MKUnsafeSequence: Sequence {
        
        public typealias Element = UnsafePointer<MIDIPacket>
        
        internal var pointers: [UnsafePointer<MIDIPacket>] = []
        
        public init(_ midiPacketListPtr: UnsafePointer<MIDIPacketList>) {
            
            CMIDIPacketListIterate(midiPacketListPtr) {
                guard let unwrappedPtr = $0 else { return }
                pointers.append(unwrappedPtr)
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
    
}

