//
//  UniversalPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

internal import CoreMIDI
internal import MIDIKitInternals

/// Clean consolidated data encapsulation of raw data from a Core MIDI `MIDIEventPacket` (Universal
/// MIDI Packet).
public struct UniversalMIDIPacketData {
    // /// Universal MIDI Packet Words
    // public let words: [UInt32]
    
    /// Flat array of raw bytes
    public let bytes: [UInt8]
    
    /// Core MIDI packet timestamp
    public let timeStamp: CoreMIDITimeStamp
    
    /// The MIDI endpoint from which the packet originated.
    /// If this information is not available, it may be `nil`.
    public let source: MIDIOutputEndpoint?
    
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

extension UniversalMIDIPacketData: Equatable { }

extension UniversalMIDIPacketData: Hashable { }

extension UniversalMIDIPacketData: Sendable { }

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension UniversalMIDIPacketData {
    /// Universal MIDI Packet
    init(
        _ eventPacketPtr: UnsafePointer<MIDIEventPacket>,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) {
        self = Self.unwrapPacket(eventPacketPtr, refCon: refCon, refConKnown: refConKnown)
    }
    
    /// Universal MIDI Packet
    init(
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
        UniversalMIDIPacketData(
            words: eventPacketPtr.rawWords,
            timeStamp: eventPacketPtr.pointee.timeStamp,
            source: unpackMIDIRefCon(refCon: refCon, known: refConKnown)
        )
    }
    
    fileprivate static func packetUnwrapper(
        _ eventPacket: MIDIEventPacket,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) -> UniversalMIDIPacketData {
        UniversalMIDIPacketData(
            words: eventPacket.rawWords,
            timeStamp: eventPacket.timeStamp,
            source: unpackMIDIRefCon(refCon: refCon, known: refConKnown)
        )
    }
}

#endif
