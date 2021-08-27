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
        
        /// Flat array of raw bytes
        @inline(__always) public var bytes: [MIDI.Byte]
        
        /// CoreMIDI packet timestamp
        public let timeStamp: MIDITimeStamp
        
        @inline(__always) public init(bytes: [MIDI.Byte], timeStamp: MIDITimeStamp) {
            
            self.bytes = bytes
            self.timeStamp = timeStamp
            
        }
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacketPtr: UnsafeMutablePointer<MIDIEventPacket>) {
            
            self = Self.safePacketUnwrapper(eventPacketPtr)
            
        }
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacketPtr: UnsafePointer<MIDIEventPacket>) {
            
            let mutablePtr: UnsafeMutablePointer<MIDIEventPacket> = .init(mutating: eventPacketPtr)
            
            self = Self.safePacketUnwrapper(mutablePtr)
            
        }
        
    }
    
}

@available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
extension MIDI.Packet.UniversalPacketData {
    
    @inline(__always) fileprivate
    static let midiEventPacketDataOffset: Int = MemoryLayout.offset(of: \MIDIEventPacket.words)!
    
    @inline(__always) fileprivate
    static func safePacketUnwrapper(_ midiEventPacketPtr: UnsafeMutablePointer<MIDIEventPacket>) -> MIDI.Packet.UniversalPacketData {
        
        let packetDataCount = Int(midiEventPacketPtr.pointee.wordCount) * 4
        
        guard packetDataCount > 0 else {
            return MIDI.Packet.UniversalPacketData(
                bytes: [],
                timeStamp: midiEventPacketPtr.pointee.timeStamp
            )
        }
        
        // Access the raw memory instead of using the .pointee
        // This workaround is needed due to a variety of crashes that can occur when either the thread sanitizer is on, or large/malformed MIDI event lists / packets arrive
        let rawMIDIEventPacketWordsPtr = UnsafeRawBufferPointer(
            start: UnsafeRawPointer(midiEventPacketPtr) + midiEventPacketDataOffset,
            count: packetDataCount
        )
        
        return MIDI.Packet.UniversalPacketData(
            bytes: Array<MIDI.Byte>(rawMIDIEventPacketWordsPtr),
            timeStamp: midiEventPacketPtr.pointee.timeStamp
        )
        
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
