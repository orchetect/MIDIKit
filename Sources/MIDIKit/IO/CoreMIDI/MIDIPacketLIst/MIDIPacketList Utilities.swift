//
//  MIDIPacketList Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO {
    
    /// Internal use.
    /// Assembles a single `CoreMIDI` `MIDIPacket` from a MIDI message byte array and wraps it in a `CoreMIDI` `MIDIPacketList`.
    ///
    /// - Note: You must deallocate the pointer when finished with it.
    @inlinable internal static func assemblePacketList(data: [MIDI.Byte]) throws -> UnsafeMutablePointer<MIDIPacketList> {
        
        // Create a buffer that is big enough to hold the data to be sent and
        // all the necessary headers.
        let bufferSize = data.count + MIDI.IO.kSizeOfMIDICombinedHeaders
        
        // the discussion section of MIDIPacketListAdd states that "The maximum
        // size of a packet list is 65536 bytes." Checking for that limit here.
        //        if bufferSize > 65_536 {
        //            Log.default("MIDI: assemblePacketList(data:) Error: Data array is too large (\(bufferSize) bytes), requires a buffer larger than 65536")
        //            return nil
        //        }
        
        let timeTag = mach_absolute_time()
        
        let packetListPointer: UnsafeMutablePointer<MIDIPacketList> = .allocate(capacity: 1)
        
        // prepare packet
        var currentPacket: UnsafeMutablePointer<MIDIPacket>?
        currentPacket = MIDIPacketListInit(packetListPointer)
        
        // returns NULL if there was not room in the packet list for the event
        currentPacket = MIDIPacketListAdd(packetListPointer,
                                          bufferSize,
                                          currentPacket!,
                                          timeTag,
                                          data.count,
                                          data)
        
        guard currentPacket != nil else {
            throw MIDIError.malformed(
                "Failed to add packet to packet list."
            )
        }
        
        return packetListPointer
        
    }
    
    /// Experimental.
    /// Assembles an array of `Byte` arrays into `CoreMIDI` `MIDIPacket`s and wraps them in a `MIDIPacketList`.
    ///
    /// - Note: You must deallocate the pointer when finished with it.
    @inlinable internal static func assemblePacketList(data: [[MIDI.Byte]]) throws -> UnsafeMutablePointer<MIDIPacketList> {
        
        // Create a buffer that is big enough to hold the data to be sent and
        // all the necessary headers.
        let bufferSize = data
            .reduce(0, { $0 + $1.count + MIDI.IO.kSizeOfMIDIPacketHeader })
            + MIDI.IO.kSizeOfMIDIPacketListHeader
        
        // MIDIPacketListAdd's discussion section states that "The maximum size of a packet list is 65536 bytes."
        guard bufferSize <= 65536 else {
            throw MIDIError.malformed(
                "Data array is too large (\(bufferSize) bytes). Maximum size is 65536 bytes."
            )
        }
        
        let timeTag = mach_absolute_time()
        
        let packetListPointer: UnsafeMutablePointer<MIDIPacketList> = .allocate(capacity: 1)
        
        // prepare packet
        var currentPacket: UnsafeMutablePointer<MIDIPacket>?
        
        currentPacket = MIDIPacketListInit(packetListPointer)
        
        for dataBlock in 0..<data.count {
            
            // returns NULL if there was not room in the packet list for the event
            currentPacket = MIDIPacketListAdd(packetListPointer,
                                              bufferSize, currentPacket!,
                                              timeTag,
                                              data[dataBlock].count,
                                              data[dataBlock])
            
            guard currentPacket != nil else {
                throw MIDIError.malformed(
                    "Failed to add packet index \(dataBlock) of \(data.count-1) to packet list."
                )
            }
            
        }
        
        return packetListPointer
        
    }
    
}
