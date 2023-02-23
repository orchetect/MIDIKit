//
//  MIDIPacket Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import CoreMIDI

extension UnsafePointer where Pointee == MIDIPacket {
    /// Returns the raw bytes of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawBytes: [UInt8] {
        MIDIPacket.extractBytes(from: self)
    }
    
    /// Returns the time stamp of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawTimeStamp: MIDITimeStamp {
        MIDIPacket.extractTimeStamp(from: self)
    }
}

extension UnsafeMutablePointer where Pointee == MIDIPacket {
    /// Returns the raw bytes of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawBytes: [UInt8] {
        UnsafePointer(self).rawBytes
    }
    
    /// Returns the time stamp of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawTimeStamp: MIDITimeStamp {
        UnsafePointer(self).rawTimeStamp
    }
}

extension MIDIPacket {
    /// Returns the raw bytes of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawBytes: [UInt8] {
        withUnsafePointer(to: self) { $0.rawBytes }
    }
    
    /// Returns the time stamp of the `MIDIPacket`.
    @_disfavoredOverload
    public var rawTimeStamp: MIDITimeStamp {
        withUnsafePointer(to: self) { $0.rawTimeStamp }
    }
}

// MARK: - Helpers

extension MIDIPacket {
    fileprivate static let midiPacketLengthOffset: Int = MemoryLayout.offset(of: \MIDIPacket.length)!
    fileprivate static let midiPacketDataOffset: Int = MemoryLayout.offset(of: \MIDIPacket.data)!
    fileprivate static let midiPacketTimeStamp: Int = MemoryLayout.offset(of: \MIDIPacket.timeStamp)!
    
    fileprivate static func extractBytes(from ptr: UnsafeRawPointer) -> [UInt8] {
        // Access the raw memory instead of using the .pointee
        // This workaround is needed due to a variety of crashes that can occur when either the
        // thread sanitizer is on, or large/malformed MIDI packet lists / packets arrive
        
        let lengthPtr = ptr.advanced(by: midiPacketLengthOffset)
        let length = lengthPtr.withMemoryRebound(to: UInt16.self, capacity: 1) { pointer in
            Int(pointer.pointee)
        }
        
        let rawMIDIPacketDataPtr = UnsafeRawBufferPointer(
            start: ptr + midiPacketDataOffset,
            count: length
        )
        
        return [UInt8](rawMIDIPacketDataPtr)
    }
    
    fileprivate static func extractTimeStamp(from ptr: UnsafeRawPointer) -> MIDITimeStamp {
        // Access the raw memory instead of using the .pointee
        // This workaround is needed due to a variety of crashes that can occur when either the
        // thread sanitizer is on, or large/malformed MIDI packet lists / packets arrive
        
        let timestampPtr = ptr.advanced(by: midiPacketTimeStamp)
        
        // ⚠️ crashes and complains about alignment
        // let timeStamp = timestampPtr.withMemoryRebound(to: UInt64.self, capacity: 1) { pointer in
        //     pointer.pointee
        // }
        
        // this works and survives brute-force unit tests
        let timeStamp = timestampPtr.loadUnaligned(as: UInt64.self)
        
        return timeStamp
    }
}

#endif
