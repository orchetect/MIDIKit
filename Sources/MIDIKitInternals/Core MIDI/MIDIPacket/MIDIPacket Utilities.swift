//
//  MIDIPacket Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import CoreMIDI

extension UnsafePointer where Pointee == MIDIPacket {
    fileprivate static let midiPacketDataOffset: Int = MemoryLayout.offset(of: \MIDIPacket.data)!
    
    /// Returns the raw bytes of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawBytes: [UInt8] {
        let packetDataCount = Int(pointee.length)
        
        guard packetDataCount > 0 else {
            return []
        }
        
        // Access the raw memory instead of using the .pointee
        // This workaround is needed due to a variety of crashes that can occur when either the
        // thread sanitizer is on, or large/malformed MIDI packet lists / packets arrive
        let rawMIDIPacketDataPtr = UnsafeRawBufferPointer(
            start: UnsafeRawPointer(self) + Self.midiPacketDataOffset,
            count: packetDataCount
        )
        
        return [UInt8](rawMIDIPacketDataPtr)
    }
}

#endif
