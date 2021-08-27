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
        
        public typealias Element = UnsafePointer<MIDIEventPacket>
        
        internal var pointers: [UnsafePointer<MIDIEventPacket>] = []
        
        public init(_ midiPacketListPtr: UnsafePointer<MIDIEventList>) {
            
            CMIDIEventListIterate(midiPacketListPtr) {
                guard let unwrappedPtr = $0 else { return }
                pointers.append(unwrappedPtr)
            }
            
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

