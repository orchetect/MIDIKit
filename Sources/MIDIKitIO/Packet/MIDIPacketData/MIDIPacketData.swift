//
//  MIDIPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI
@_implementationOnly import MIDIKitInternals

/// Clean consolidated data encapsulation of raw data from a Core MIDI `MIDIPacket` (MIDI 1.0).
public struct MIDIPacketData {
    let bytes: [UInt8]
    
    /// Core MIDI packet timestamp
    let timeStamp: CoreMIDITimeStamp
    
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
}

extension MIDIPacketData: Sendable { }

extension MIDIPacketData {
    init(
        _ midiPacketPtr: UnsafePointer<MIDIPacket>,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) {
        self = Self.unwrapPacket(midiPacketPtr, refCon: refCon, refConKnown: refConKnown)
    }
    
    fileprivate static func unwrapPacket(
        _ midiPacketPtr: UnsafePointer<MIDIPacket>,
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) -> MIDIPacketData {
        MIDIPacketData(
            bytes: midiPacketPtr.rawBytes,
            timeStamp: midiPacketPtr.rawTimeStamp,
            source: unpackMIDIRefCon(refCon: refCon, known: refConKnown)
        )
    }
}

#endif
