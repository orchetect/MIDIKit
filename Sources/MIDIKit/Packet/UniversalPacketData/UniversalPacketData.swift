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
        
        @inline(__always) public init(words: [UInt32], timeStamp: MIDITimeStamp) {
            
            self.bytes = wordsToBytes(words)
            self.timeStamp = timeStamp
            
        }
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacketPtr: UnsafePointer<MIDIEventPacket>) {
            
            self = Self.safePacketUnwrapper(eventPacketPtr)
            
        }
        
        /// Universal MIDI Packet
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public init(_ eventPacket: MIDIEventPacket) {
            
            self = Self.packetUnwrapper(eventPacket)
            
        }
        
    }
    
}

@available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
extension MIDI.Packet.UniversalPacketData {
    
//    @inline(__always) fileprivate
//    static let midiEventPacketDataOffset: Int = MemoryLayout.offset(of: \MIDIEventPacket.words)!
    
    @inline(__always) fileprivate
    static func safePacketUnwrapper(
        _ eventPacketPtr: UnsafePointer<MIDIEventPacket>
    ) -> MIDI.Packet.UniversalPacketData {
        
        let wordCollection = MIDIEventPacket.WordCollection(eventPacketPtr)
        
        guard wordCollection.count > 0 else {
            return MIDI.Packet.UniversalPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp
            )
        }
        
        guard wordCollection.count <= 64 else {
            assertionFailure("Received MIDIEventPacket reporting \(wordCollection.count) words.")
            return MIDI.Packet.UniversalPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp
            )
        }
        
        var words: [UInt32] = []
        words.reserveCapacity(wordCollection.count)
        
        for word in wordCollection {
            words.append(word)
        }
        
        return MIDI.Packet.UniversalPacketData(
            words: words,
            timeStamp: eventPacketPtr.pointee.timeStamp
        )
        
    }
    
    @inline(__always) fileprivate
    static func packetUnwrapper(
        _ eventPacket: MIDIEventPacket
    ) -> MIDI.Packet.UniversalPacketData {
        
        var localEventPacket = eventPacket
        
        return withUnsafePointer(to: localEventPacket)
        { unsafePtr -> MIDI.Packet.UniversalPacketData in
            
            let wordCollection = MIDIEventPacket.WordCollection(&localEventPacket)
            
            guard wordCollection.count > 0 else {
                return MIDI.Packet.UniversalPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp
                )
            }
            
            guard wordCollection.count <= 64 else {
                assertionFailure("Received MIDIEventPacket reporting \(wordCollection.count) words.")
                return MIDI.Packet.UniversalPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp
                )
            }
            
            var words: [UInt32] = []
            words.reserveCapacity(wordCollection.count)
            
            for word in wordCollection {
                words.append(word)
            }
            
            return MIDI.Packet.UniversalPacketData(
                words: words,
                timeStamp: localEventPacket.timeStamp
            )
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
