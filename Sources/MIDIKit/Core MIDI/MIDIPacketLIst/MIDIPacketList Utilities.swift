//
//  MIDIPacketList Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI

extension MIDIPacketList {
    /// Internal:
    /// Assembles a single Core MIDI `MIDIPacket` from a MIDI message byte array and wraps it in a Core MIDI `MIDIPacketList`.
    @inline(__always)
    internal init(data: [Byte]) {
        let packetList = UnsafeMutablePointer<MIDIPacketList>(data: data)
        self = packetList.pointee
        packetList.deallocate()
    }
    
    /// Internal:
    /// Assembles an array of `Byte` arrays into Core MIDI `MIDIPacket`s and wraps them in a `MIDIPacketList`.
    @inline(__always)
    internal init(data: [[Byte]]) throws {
        let packetList = try UnsafeMutablePointer<MIDIPacketList>(data: data)
        self = packetList.pointee
        packetList.deallocate()
    }
}

extension UnsafeMutablePointer where Pointee == MIDIPacketList {
    /// Internal:
    /// Assembles a single Core MIDI `MIDIPacket` from a MIDI message byte array and wraps it in a Core MIDI `MIDIPacketList`.
    ///
    /// - Note: You must deallocate the pointer when finished with it.
    @inline(__always)
    internal init(data: [Byte]) {
        // Create a buffer that is big enough to hold the data to be sent and
        // all the necessary headers.
        let bufferSize = data.count + kSizeOfMIDIPacketCombinedHeaders
        
        // the discussion section of MIDIPacketListAdd states that "The maximum
        // size of a packet list is 65536 bytes." Checking for that limit here.
        //        if bufferSize > 65_536 {
        //            logger.default("MIDI: assemblePacketList(data:) Error: Data array is too large (\(bufferSize) bytes), requires a buffer larger than 65536")
        //            return nil
        //        }
        
        let timeTag: UInt64 = mach_absolute_time()
        
        let packetListPointer: UnsafeMutablePointer<MIDIPacketList> = .allocate(capacity: 1)
        
        // prepare packet
        var currentPacket: UnsafeMutablePointer<MIDIPacket> = MIDIPacketListInit(
            packetListPointer
        )
        
        // returns NULL if there was not room in the packet list for the event (?)
        currentPacket = MIDIPacketListAdd(
            packetListPointer,
            bufferSize,
            currentPacket,
            timeTag,
            data.count,
            data
        )
        
        self = packetListPointer
    }
    
    /// Internal:
    /// Assembles an array of `Byte` arrays into Core MIDI `MIDIPacket`s and wraps them in a `MIDIPacketList`.
    ///
    /// - Note: You must deallocate the pointer when finished with it.
    /// - Note: System Exclusive messages must each be packed in a dedicated MIDIPacketList with no other events, otherwise MIDIPacketList may fail.
    @inline(__always)
    internal init(data: [[Byte]]) throws {
        // Create a buffer that is big enough to hold the data to be sent and
        // all the necessary headers.
        let bufferSize = data
            .reduce(0) { $0 + $1.count + kSizeOfMIDIPacketHeader }
            + kSizeOfMIDIPacketListHeader
        
        // MIDIPacketListAdd's discussion section states that "The maximum size of a packet list is 65536 bytes."
        guard bufferSize <= 65536 else {
            throw MIDIIOError.malformed(
                "Data array is too large (\(bufferSize) bytes). Maximum size is 65536 bytes."
            )
        }
        
        // As per Apple docs, timeTag must not be 0 when a packet is sent with `MIDIReceived()`. It must be a proper timeTag.
        let timeTag: UInt64 = mach_absolute_time()
        
        let packetListPointer: UnsafeMutablePointer<MIDIPacketList> = .allocate(capacity: 1)
        
        // prepare packet
        var currentPacket: UnsafeMutablePointer<MIDIPacket>! =
            MIDIPacketListInit(packetListPointer)
        
        for dataBlock in 0 ..< data.count {
            // returns NULL if there was not room in the packet list for the event
            currentPacket = MIDIPacketListAdd(
                packetListPointer,
                bufferSize,
                currentPacket,
                timeTag,
                data[dataBlock].count,
                data[dataBlock]
            )
            
            guard currentPacket != nil else {
                throw MIDIIOError.malformed(
                    "Error adding MIDI packet to packet list."
                )
            }
        }
        
        self = packetListPointer
    }
}

#endif
