//
//  UniversalPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

@_implementationOnly import CoreMIDI

/// Clean consolidated data encapsulation of raw data from a CoreMIDI `MIDIEventPacket` (Universal MIDI Packet).
public struct UniversalMIDIPacketData {
//    /// Universal MIDI Packet Words
//    public let words: [UInt32]
    
    /// Flat array of raw bytes
    public var bytes: [Byte]
    
    /// Core MIDI packet timestamp
    public let timeStamp: CoreMIDITimeStamp
    
    public init(bytes: [Byte], timeStamp: CoreMIDITimeStamp) {
        self.bytes = bytes
        self.timeStamp = timeStamp
    }
    
    public init(words: [UMPWord], timeStamp: CoreMIDITimeStamp) {
        bytes = words.umpWordsToBytes()
        self.timeStamp = timeStamp
    }
}

#if !os(tvOS) && !os(watchOS)

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension UniversalMIDIPacketData {
    /// Universal MIDI Packet
    internal init(_ eventPacketPtr: UnsafePointer<MIDIEventPacket>) {
        self = Self.unwrapPacket(eventPacketPtr)
    }
    
    /// Universal MIDI Packet
    internal init(_ eventPacket: MIDIEventPacket) {
        self = Self.packetUnwrapper(eventPacket)
    }
    
    fileprivate static func unwrapPacket(
        _ eventPacketPtr: UnsafePointer<MIDIEventPacket>
    ) -> UniversalMIDIPacketData {
        let wordCollection = eventPacketPtr.words()
    
        guard !wordCollection.isEmpty else {
            return UniversalMIDIPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp
            )
        }
    
        guard wordCollection.count <= 64 else {
            assertionFailure(
                "Received MIDIEventPacket reporting \(wordCollection.count) words."
            )
            return UniversalMIDIPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp
            )
        }
    
        var words: [UMPWord] = []
        words.reserveCapacity(wordCollection.count)
    
        for word in wordCollection {
            words.append(word)
        }
    
        return UniversalMIDIPacketData(
            words: words,
            timeStamp: eventPacketPtr.pointee.timeStamp
        )
    }
    
    fileprivate static func packetUnwrapper(
        _ eventPacket: MIDIEventPacket
    ) -> UniversalMIDIPacketData {
        var localEventPacket = eventPacket
    
        return withUnsafePointer(to: localEventPacket) { unsafePtr -> UniversalMIDIPacketData in
            let wordCollection = MIDIEventPacket.WordCollection(&localEventPacket)
    
            guard !wordCollection.isEmpty else {
                return UniversalMIDIPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp
                )
            }
    
            guard wordCollection.count <= 64 else {
                assertionFailure(
                    "Received MIDIEventPacket reporting \(wordCollection.count) words."
                )
                return UniversalMIDIPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp
                )
            }
    
            var words: [UMPWord] = []
            words.reserveCapacity(wordCollection.count)
    
            for word in wordCollection {
                words.append(word)
            }
    
            return UniversalMIDIPacketData(
                words: words,
                timeStamp: localEventPacket.timeStamp
            )
        }
    }
}

#endif
