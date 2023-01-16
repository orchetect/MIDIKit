//
//  MIDIPacket Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import CoreMIDI

extension UnsafePointer where Pointee == MIDIPacket {
    /// Returns the raw bytes of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawBytes: [UInt8] {
        MIDIPacket.extractBytes(from: self, count: Int(pointee.length))
    }
}

extension UnsafeMutablePointer where Pointee == MIDIPacket {
    /// Returns the raw bytes of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawBytes: [UInt8] {
        MIDIPacket.extractBytes(from: self, count: Int(pointee.length))
    }
}

// MARK: - Helpers

extension MIDIPacket {
    fileprivate static let midiPacketDataOffset: Int = MemoryLayout.offset(of: \MIDIPacket.data)!
    
    fileprivate static func extractBytes(from ptr: UnsafeRawPointer, count: Int) -> [UInt8] {
        // Access the raw memory instead of using the .pointee
        // This workaround is needed due to a variety of crashes that can occur when either the
        // thread sanitizer is on, or large/malformed MIDI packet lists / packets arrive
        let rawMIDIPacketDataPtr = UnsafeRawBufferPointer(
            start: ptr + midiPacketDataOffset,
            count: count
        )
        
        return [UInt8](rawMIDIPacketDataPtr)
    }
}

#endif
