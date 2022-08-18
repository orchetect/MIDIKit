//
//  MIDIPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

@_implementationOnly import CoreMIDI

/// Clean consolidated data encapsulation of raw data from a Core MIDI `MIDIPacket` (MIDI 1.0).
public struct MIDIPacketData {
    let bytes: [Byte]
    
    /// Core MIDI packet timestamp
    let timeStamp: CoreMIDITimeStamp
    
    public init(
        bytes: [Byte],
        timeStamp: CoreMIDITimeStamp
    ) {
        self.bytes = bytes
        self.timeStamp = timeStamp
    }
}

extension MIDIPacketData {
    internal init(_ midiPacketPtr: UnsafePointer<MIDIPacket>) {
        self = Self.unwrapPacket(midiPacketPtr)
    }
    
    fileprivate static let midiPacketDataOffset: Int = MemoryLayout.offset(of: \MIDIPacket.data)!
    
    fileprivate static func unwrapPacket(
        _ midiPacketPtr: UnsafePointer<MIDIPacket>
    ) -> MIDIPacketData {
        let packetDataCount = Int(midiPacketPtr.pointee.length)
    
        guard packetDataCount > 0 else {
            return MIDIPacketData(
                bytes: [],
                timeStamp: midiPacketPtr.pointee.timeStamp
            )
        }
    
        // Access the raw memory instead of using the .pointee
        // This workaround is needed due to a variety of crashes that can occur when either the thread sanitizer is on, or large/malformed MIDI packet lists / packets arrive
        let rawMIDIPacketDataPtr = UnsafeRawBufferPointer(
            start: UnsafeRawPointer(midiPacketPtr) + midiPacketDataOffset,
            count: packetDataCount
        )
    
        return MIDIPacketData(
            bytes: [Byte](rawMIDIPacketDataPtr),
            timeStamp: midiPacketPtr.pointee.timeStamp
        )
    }
}
