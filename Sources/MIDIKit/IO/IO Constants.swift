//
//  IO Constants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO {
    
    /// Size of `CoreMIDI` `MIDIPacketList` struct memory.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacketList = MemoryLayout<MIDIPacketList>.size
    
    /// Size of `CoreMIDI` `MIDIPacket` struct memory.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacket = MemoryLayout<MIDIPacket>.size
    
    /// Size of `CoreMIDI` `MIDIPacketList` header.
    ///
    /// The `MIDIPacketList` struct consists of two fields, numPackets(`UInt32`) and packet (an Array of 1 instance of `MIDIPacket`).
    ///
    /// The packet is supposed to be a "An open-ended array of variable-length MIDIPackets." but for convenience it is instantiated with one instance of a `MIDIPacket`.
    ///
    /// To determine the size of the header portion of this struct, we can get the size of a UInt32, or subtract the size of a single packet from the size of a packet list. We will opt for the latter.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacketListHeader = kSizeOfMIDIPacketList - kSizeOfMIDIPacket
    
    /// Size of `CoreMIDI` `MIDIPacket` header.
    ///
    /// The `MIDIPacket` struct consists of a timestamp (`MIDITimeStamp`), a length (`UInt16`) and data (an Array of 256 instances of `Byte`).
    ///
    /// The data field is supposed to be a "A variable-length stream of MIDI messages." but for convenience it is instantiated as 256 bytes.
    ///
    /// To determine the size of the header portion of this struct, we can add the size of the `timestamp` and `length` fields, or subtract the size of the 256 `Byte`s from the size of the whole packet. We will opt for the former.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDIPacketHeader = MemoryLayout<MIDITimeStamp>.size + MemoryLayout<UInt16>.size
    
    /// Size of both `CoreMIDI` `MIDIPacketList` header and `CoreMIDI` `MIDIPacket` header.
    @inline(__always) @usableFromInline
    internal static let kSizeOfMIDICombinedHeaders = kSizeOfMIDIPacketListHeader + kSizeOfMIDIPacketHeader
    
}
