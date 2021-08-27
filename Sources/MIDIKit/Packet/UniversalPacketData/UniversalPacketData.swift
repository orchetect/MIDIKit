//
//  UniversalPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.Packet {
    
    /// Clean consolidated data encapsulation of raw data from a CoreMIDI MIDI 2.0 `MIDIEventPacket` (Universal MIDI Packet).
    public struct UniversalPacketData {
        
//        /// Universal MIDI Packet Words
//        public let words: [UInt32]
        
        /// CoreMIDI packet timestamp
        public let timeStamp: MIDITimeStamp
        
        /// Flat array of raw bytes
        @inline(__always) public var bytes: [MIDI.Byte]
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacketPtr: UnsafeMutablePointer<MIDIEventPacket>) {
            
            let wordCount = eventPacketPtr.pointee.wordCount
            
            // Access the raw memory instead of using the pointee.words tuple
            let rawMIDIPacketDataPtr = UnsafeRawBufferPointer(
                start: UnsafeRawPointer(eventPacketPtr),
                count: Int(wordCount) * 4 // byte count == word count * UInt32 length (4 bytes)
            )
            
            self.bytes = Array<UInt8>(rawMIDIPacketDataPtr)
            self.timeStamp = eventPacketPtr.pointee.timeStamp
            
        }
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacketPtr: UnsafePointer<MIDIEventPacket>) {
            
            let ptr: UnsafeMutablePointer<MIDIEventPacket> = .init(mutating: eventPacketPtr)
            
            self.init(ptr)
            
        }
        
    }
    
}

/// Internal: flattens an array of UInt32 words into a UInt8 array of bytes.
fileprivate func wordsToBytes(_ words: [UInt32]) -> [MIDI.Byte] {
    
    var bytes: [MIDI.Byte] = []
    bytes.reserveCapacity(4 * words.count)
    
    words.forEach { word in
        let byte1 = MIDI.Byte((word & 0xFF000000) >> 24)
        let byte2 = MIDI.Byte((word & 0x00FF0000) >> 16)
        let byte3 = MIDI.Byte((word & 0x0000FF00) >> 8)
        let byte4 = MIDI.Byte(word & 0x000000FF)
        
        bytes.append(byte1)
        bytes.append(byte2)
        bytes.append(byte3)
        bytes.append(byte4)
    }
    
    return bytes
    
}
