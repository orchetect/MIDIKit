//
//  MIDI UniversalPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.Packet {
    
    /// Clean consolidated data encapsulation of raw data from a CoreMIDI MIDI 2.0 `MIDIEventPacket` (Universal MIDI Packet).
    public struct UniversalPacketData {
        
        /// Universal MIDI Packet Words
        let words: [UInt32]
        
        let timeStamp: MIDITimeStamp
        
        /// Flat array of raw bytes
        @inline(__always) public var bytes: [MIDI.Byte] {
            
            #warning("> this is dumb?")
            var bytes: [MIDI.Byte] = []
            bytes.reserveCapacity(4 * words.count)
            words.forEach { bytes.append(contentsOf: $0.toData().bytes) }
            return bytes
            
        }
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacketPtr: UnsafeMutablePointer<MIDIEventPacket>) {
            
            let unsafeWrapper = UnsafeMutableMIDIEventPacketPointer(eventPacketPtr)
            
            var words: [UInt32] = []
            words.reserveCapacity(unsafeWrapper.count)
            
            for word in unsafeWrapper {
                words.append(word)
            }
            
            self.words = words
            self.timeStamp = eventPacketPtr.pointee.timeStamp
            
        }
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacketPtr: UnsafePointer<MIDIEventPacket>) {
            
            let wordCollection = eventPacketPtr.words()
            
            var words: [UInt32] = []
            words.reserveCapacity(wordCollection.count)
            
            for word in wordCollection {
                words.append(word)
            }
            
            self.words = words
            self.timeStamp = eventPacketPtr.pointee.timeStamp
            
        }
        
    }
    
}
