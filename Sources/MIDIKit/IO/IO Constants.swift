//
//  IO Constants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO {
    
    /// Size of Core MIDI `MIDIPacketList` struct memory.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacketList = MemoryLayout<MIDIPacketList>.size
    
    /// Size of Core MIDI `MIDIPacket` struct memory.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacket = MemoryLayout<MIDIPacket>.size
    
    /// Size of Core MIDI `MIDIPacketList` header.
    ///
    /// The `MIDIPacketList` struct consists of two portions: numPackets `UInt32` and packet.
    ///
    /// The packet is an "open-ended array of variable-length MIDIPackets" of `numPackets` count.
    ///
    /// To determine the size of the header, we can get the size of a `UInt32`, or subtract the size of a single packet from the size of a packet list.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacketListHeader = kSizeOfMIDIPacketList - kSizeOfMIDIPacket
    
    /// Size of Core MIDI `MIDIPacket` header.
    ///
    /// The `MIDIPacket` struct consists of a `MIDITimeStamp` timestamp, a `UInt16` length, followed by data bytes of the length specified.
    ///
    /// To determine the size of the header, add the size of the `timestamp` and `length` portions.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacketHeader = MemoryLayout<MIDITimeStamp>.size + MemoryLayout<UInt16>.size
    
    /// Size of both Core MIDI `MIDIPacketList` header and `MIDIPacket` header.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDICombinedHeaders = kSizeOfMIDIPacketListHeader + kSizeOfMIDIPacketHeader
    
}
