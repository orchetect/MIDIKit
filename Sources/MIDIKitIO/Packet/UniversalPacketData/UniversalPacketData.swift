//
//  UniversalPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

@_implementationOnly import CoreMIDI

/// Clean consolidated data encapsulation of raw data from a Core MIDI `MIDIEventPacket` (Universal MIDI Packet).
public struct UniversalMIDIPacketData {
//    /// Universal MIDI Packet Words
//    public let words: [UInt32]
    
    /// Flat array of raw bytes
    public var bytes: [UInt8]
    
    /// Core MIDI packet timestamp
    public let timeStamp: CoreMIDITimeStamp
    
    /// The MIDI endpoint from which the packet originated.
    /// If this information is not available, it may be `nil`.
    let source: MIDIOutputEndpoint?
    
    public init(
        bytes: [UInt8],
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint? = nil
    ) {
        self.bytes = bytes
        self.timeStamp = timeStamp
        self.source = source
    }
    
    public init(
        words: [UMPWord],
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint? = nil
    ) {
        bytes = words.umpWordsToBytes()
        self.timeStamp = timeStamp
        self.source = source
    }
}

#if !os(tvOS) && !os(watchOS)

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension UniversalMIDIPacketData {
    /// Universal MIDI Packet
    internal init(
        _ eventPacketPtr: UnsafePointer<MIDIEventPacket>,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) {
        self = Self.unwrapPacket(eventPacketPtr, refCon: refCon, refConKnown: refConKnown)
    }
    
    /// Universal MIDI Packet
    internal init(
        _ eventPacket: MIDIEventPacket,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) {
        self = Self.packetUnwrapper(eventPacket, refCon: refCon, refConKnown: refConKnown)
    }
    
    fileprivate static func unwrapPacket(
        _ eventPacketPtr: UnsafePointer<MIDIEventPacket>,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) -> UniversalMIDIPacketData {
        let wordCollection = eventPacketPtr.words()
        
        let source = unpackMIDIRefCon(refCon: refCon, known: refConKnown)
        
        guard !wordCollection.isEmpty else {
            return UniversalMIDIPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp,
                source: source
            )
        }
    
        guard wordCollection.count <= 64 else {
            assertionFailure(
                "Received MIDIEventPacket reporting \(wordCollection.count) words."
            )
            return UniversalMIDIPacketData(
                words: [],
                timeStamp: eventPacketPtr.pointee.timeStamp,
                source: source
            )
        }
    
        var words: [UMPWord] = []
        words.reserveCapacity(wordCollection.count)
    
        for word in wordCollection {
            words.append(word)
        }
    
        return UniversalMIDIPacketData(
            words: words,
            timeStamp: eventPacketPtr.pointee.timeStamp,
            source: source
        )
    }
    
    fileprivate static func packetUnwrapper(
        _ eventPacket: MIDIEventPacket,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) -> UniversalMIDIPacketData {
        var localEventPacket = eventPacket
        
        let source = unpackMIDIRefCon(refCon: refCon, known: refConKnown)
        
        return withUnsafePointer(to: localEventPacket) { unsafePtr -> UniversalMIDIPacketData in
            let wordCollection = MIDIEventPacket.WordCollection(&localEventPacket)
    
            guard !wordCollection.isEmpty else {
                return UniversalMIDIPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp,
                    source: source
                )
            }
    
            guard wordCollection.count <= 64 else {
                assertionFailure(
                    "Received MIDIEventPacket reporting \(wordCollection.count) words."
                )
                return UniversalMIDIPacketData(
                    words: [],
                    timeStamp: localEventPacket.timeStamp,
                    source: source
                )
            }
    
            var words: [UMPWord] = []
            words.reserveCapacity(wordCollection.count)
    
            for word in wordCollection {
                words.append(word)
            }
    
            return UniversalMIDIPacketData(
                words: words,
                timeStamp: localEventPacket.timeStamp,
                source: source
            )
        }
    }
}

#endif
