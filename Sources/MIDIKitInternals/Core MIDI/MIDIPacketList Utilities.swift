//
//  MIDIPacketList Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI

// MARK: - Init

extension CoreMIDI.MIDIPacketList {
    /// Assembles a single Core MIDI `MIDIPacket` from a MIDI message byte array and wraps it in a
    /// Core MIDI `MIDIPacketList`.
    @_disfavoredOverload @inlinable
    public init(data: [UInt8]) {
        let packetList = UnsafeMutablePointer<CoreMIDI.MIDIPacketList>(data: data)
        self = packetList.pointee
        packetList.deallocate()
    }
    
    /// Assembles an array of `UInt8` packet arrays into Core MIDI `MIDIPacket`s and wraps them in a
    /// `MIDIPacketList`.
    @_disfavoredOverload @inlinable
    public init(data: [[UInt8]]) throws {
        let packetList = try UnsafeMutablePointer<CoreMIDI.MIDIPacketList>(data: data)
        self = packetList.pointee
        packetList.deallocate()
    }
}

extension UnsafeMutablePointer where Pointee == CoreMIDI.MIDIPacketList {
    /// Assembles a single Core MIDI `MIDIPacket` from a MIDI message byte array and wraps it in a
    /// Core MIDI `MIDIPacketList`.
    ///
    /// - Note: You must deallocate the pointer when finished with it.
    @_disfavoredOverload @inlinable
    public init(data: [UInt8]) {
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
    
        let packetListPointer: UnsafeMutablePointer<CoreMIDI.MIDIPacketList> = .allocate(capacity: 1)
    
        // prepare packet
        var currentPacket: UnsafeMutablePointer<CoreMIDI.MIDIPacket> = MIDIPacketListInit(
            packetListPointer
        )
    
        // returns NULL if there was not room in the packet list for the event (?)
        currentPacket = CoreMIDI.MIDIPacketListAdd(
            packetListPointer,
            bufferSize,
            currentPacket,
            timeTag,
            data.count,
            data
        )
    
        self = packetListPointer
    }
    
    /// Assembles an array of `UInt8` packet arrays into Core MIDI `MIDIPacket`s and wraps them in a
    /// `MIDIPacketList`.
    ///
    /// - Note: You must deallocate the pointer when finished with it.
    /// - Note: System Exclusive messages must each be packed in a dedicated `MIDIPacketList` with no
    ///   other events, otherwise MIDI packet list creation may fail.
    @_disfavoredOverload @inlinable
    public init(data: [[UInt8]]) throws {
        // Create a buffer that is big enough to hold the data to be sent and
        // all the necessary headers.
        let bufferSize = data
            .reduce(0) { $0 + $1.count * kSizeOfMIDIPacketHeader }
            + kSizeOfMIDIPacketListHeader
    
        // MIDIPacketListAdd's discussion section states that "The maximum size of a packet list is
        // 65536 bytes."
        guard bufferSize <= 65536 else {
            throw MIDIInternalError.packetTooLarge(bufferByteCount: bufferSize)
        }
    
        // As per Apple docs, timeTag must not be 0 when a packet is sent with `MIDIReceived()`. It
        // must be a proper timeTag.
        let timeTag: UInt64 = mach_absolute_time()
    
        let packetListPointer: UnsafeMutablePointer<CoreMIDI.MIDIPacketList> = .allocate(capacity: 1)
    
        // prepare packet
        var currentPacket: UnsafeMutablePointer<CoreMIDI.MIDIPacket>! =
            CoreMIDI.MIDIPacketListInit(packetListPointer)
    
        for dataBlock in 0 ..< data.count {
            // returns NULL if there was not room in the packet list for the event
            currentPacket = CoreMIDI.MIDIPacketListAdd(
                packetListPointer,
                bufferSize,
                currentPacket,
                timeTag,
                data[dataBlock].count,
                data[dataBlock]
            )
    
            guard currentPacket != nil else {
                throw MIDIInternalError.packetBuildError
            }
        }
    
        self = packetListPointer
    }
}

// MARK: - Properties

extension CoreMIDI.MIDIPacketList {
    /// Iterates packets in a `MIDIPacketList` and calls the closure for each packet.
    ///
    /// This is confirmed working on macOS 10.14 thru macOS 15.0.
    /// There were numerous difficulties in reading `MIDIPacketList` on Mojave and earlier and this
    /// solution was stable.
    @_disfavoredOverload @inlinable
    public func packetPointerIterator(_ closure: (UnsafeMutablePointer<CoreMIDI.MIDIPacket>) -> Void) {
        withUnsafePointer(to: packet) { ptr in
            var idx: UInt32 = 0
            var p = UnsafeMutablePointer(mutating: ptr)
            while idx < numPackets {
                closure(p)
                if numPackets - idx > 0 { p = CoreMIDI.MIDIPacketNext(p) }
                idx += 1
            }
        }
    }
}

#endif
