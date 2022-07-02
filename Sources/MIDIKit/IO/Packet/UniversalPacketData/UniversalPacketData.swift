//
//  UniversalPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO.Packet {
    
    /// Clean consolidated data encapsulation of raw data from a CoreMIDI `MIDIEventPacket` (Universal MIDI Packet).
    public struct UniversalPacketData {
        
//        /// Universal MIDI Packet Words
//        public let words: [UInt32]
        
        /// Flat array of raw bytes
        @inline(__always)
        public var bytes: [MIDI.Byte]
        
        /// Core MIDI packet timestamp
        @inline(__always)
        public let timeStamp: MIDI.IO.TimeStamp
        
        @inline(__always)
        public init(bytes: [MIDI.Byte], timeStamp: MIDI.IO.TimeStamp) {
            
            self.bytes = bytes
            self.timeStamp = timeStamp
            
        }
        
        @inline(__always)
        public init(words: [MIDI.UMPWord], timeStamp: MIDI.IO.TimeStamp) {
            
            self.bytes = words.umpWordsToBytes()
            self.timeStamp = timeStamp
            
        }
        
    }
    
}

#if !os(tvOS) && !os(watchOS)

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension MIDI.IO.Packet.UniversalPacketData {
    
    /// Universal MIDI Packet
    @inline(__always)
    internal init(_ eventPacketPtr: UnsafePointer<MIDIEventPacket>) {
        
        self = Self.unwrapPacket(eventPacketPtr)
        
    }
    
    /// Universal MIDI Packet
    @inline(__always)
    internal init(_ eventPacket: MIDIEventPacket) {
        
        self = Self.packetUnwrapper(eventPacket)
        
    }
    
    @inline(__always)
    fileprivate static func unwrapPacket(
        _ eventPacketPtr: UnsafePointer<MIDIEventPacket>
    ) -> MIDI.IO.Packet.UniversalPacketData {
        
        let wordCollection = eventPacketPtr.words()
        
        guard wordCollection.count > 0 else {
            return MIDI.IO.Packet.UniversalPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp
            )
        }
        
        guard wordCollection.count <= 64 else {
            assertionFailure("Received MIDIEventPacket reporting \(wordCollection.count) words.")
            return MIDI.IO.Packet.UniversalPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp
            )
        }
        
        var words: [MIDI.UMPWord] = []
        words.reserveCapacity(wordCollection.count)
        
        for word in wordCollection {
            words.append(word)
        }
        
        return MIDI.IO.Packet.UniversalPacketData(
            words: words,
            timeStamp: eventPacketPtr.pointee.timeStamp
        )
        
    }
    
    @inline(__always)
    fileprivate static func packetUnwrapper(
        _ eventPacket: MIDIEventPacket
    ) -> MIDI.IO.Packet.UniversalPacketData {
        
        var localEventPacket = eventPacket
        
        return withUnsafePointer(to: localEventPacket)
        { unsafePtr -> MIDI.IO.Packet.UniversalPacketData in
            
            let wordCollection = MIDIEventPacket.WordCollection(&localEventPacket)
            
            guard wordCollection.count > 0 else {
                return MIDI.IO.Packet.UniversalPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp
                )
            }
            
            guard wordCollection.count <= 64 else {
                assertionFailure("Received MIDIEventPacket reporting \(wordCollection.count) words.")
                return MIDI.IO.Packet.UniversalPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp
                )
            }
            
            var words: [MIDI.UMPWord] = []
            words.reserveCapacity(wordCollection.count)
            
            for word in wordCollection {
                words.append(word)
            }
            
            return MIDI.IO.Packet.UniversalPacketData(
                words: words,
                timeStamp: localEventPacket.timeStamp
            )
        }
        
    }
    
}

#endif
