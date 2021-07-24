//
//  MIDIPacketList MKUnsafeSequence.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import MIDIKitC

extension UnsafePointer where Pointee == MIDIPacketList {
    
    /// MIDIKit backwards-compatible implementation of CoreMIDI's `MIDIPacketList.UnsafeSequence`
    public func mkUnsafeSequence() -> MIDIPacketList.MKUnsafeSequence {
        
        MIDIPacketList.MKUnsafeSequence(self)
        
    }
    
}

extension MIDIPacketList {
    
    /// MIDIKit backwards-compatible implementation of CoreMIDI's `MIDIPacketList.UnsafeSequence`
    public struct MKUnsafeSequence: Sequence {
        
        public typealias Element = UnsafePointer<MIDIPacket>
        
        internal var pointers: [UnsafePointer<MIDIPacket>] = []
        
        public init(_ midiPacketListPtr: UnsafePointer<MIDIPacketList>) {
            
            CMIDIPacketListIterate(midiPacketListPtr) {
                guard let unwrappedPtr = $0 else { return }
                pointers.append(unwrappedPtr)
            }
            
        }
        
        public func makeIterator() -> Iterator {
            Iterator(pointers)
        }
        
        public struct Iterator: IteratorProtocol {
            
            let pointers: [UnsafePointer<MIDIPacket>]
            let idx = 0
            
            init(_ pointers: [UnsafePointer<MIDIPacket>]) {
                self.pointers = pointers
            }
            
            public func next() -> Element? {
                
                guard idx < pointers.count else { return nil }
                
                return pointers[idx]
                
            }
            
        }
        
    }
    
}

