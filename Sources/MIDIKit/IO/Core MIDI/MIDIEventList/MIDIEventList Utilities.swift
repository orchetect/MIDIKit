//
//  MIDIEventList Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDIEventPacket {
    
    /// Internal use.
    /// Assembles a Core MIDI `MIDIEventPacket` (Universal MIDI Packet) from a `UInt32` word array.
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inlinable internal init(
        words: [MIDI.UMPWord]
    ) throws {
        
        guard words.count > 0 else {
            throw MIDI.IO.MIDIError.malformed(
                "A Universal MIDI Packet cannot contain zero UInt32 words."
            )
        }
        
        guard words.count <= 64 else {
            throw MIDI.IO.MIDIError.malformed(
                "A Universal MIDI Packet cannot contain more than 64 UInt32 words."
            )
        }
        
        var packet = MIDIEventPacket()
        
        // time stamp
        packet.timeStamp = .zero // zero means "now" when sending MIDI
        
        // word count
        packet.wordCount = UInt32(words.count)
        
        // words
        let mutablePtr = UnsafeMutableMIDIEventPacketPointer(&packet)
        for wordsIndex in 0..<words.count {
            mutablePtr[mutablePtr.startIndex.advanced(by: wordsIndex)] = words[wordsIndex]
        }
        
        self = packet
        
    }
    
}

// MARK: - This method "works" but MIDIEventPacket.Builder appears to have a heap overflow bug, so we shouldn't use this code for the meantime. A radar has been filed with Apple.

//extension MIDIEventPacket {
//
//    /// Internal use.
//    /// Assembles a Core MIDI `MIDIEventPacket` (Universal MIDI Packet) from a `UInt32` word array.
//    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
//    @inlinable internal init(
//        words: [MIDI.UMPWord]
//    ) throws {
//
//        guard words.count > 0 else {
//            throw MIDI.IO.MIDIError.malformed(
//                "A Universal MIDI Packet cannot contain zero UInt32 words."
//            )
//        }
//
//        guard words.count <= 64 else {
//            throw MIDI.IO.MIDIError.malformed(
//                "A Universal MIDI Packet cannot contain more than 64 UInt32 words."
//            )
//        }
//
//        let packetBuilder = MIDIEventPacket
//            .Builder(maximumNumberMIDIWords: words.count)
//
//        words.forEach { packetBuilder.append($0) }
//
//        let packet = try packetBuilder
//            .withUnsafePointer { unsafePtr -> Result<MIDIEventPacket, Error> in
//                // this "works", but when ASAN is enabled accessing pointee throws a heap overflow error
//                // I filed a radar with Apple on Sep 18, 2021: FB9637098
//                .success(unsafePtr.pointee)
//            }
//            .get()
//
//        self = packet
//
//    }
//
//}

extension MIDIEventList {
    
    /// Internal use.
    /// Assembles a single Core MIDI `MIDIEventPacket` from a Universal MIDI Packet `UInt32` word array and wraps it in a Core MIDI `MIDIEventList`.
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inlinable internal init(
        protocol midiProtocol: MIDIProtocolID,
        packetWords: [MIDI.UMPWord]
    ) throws {
        
        let packet = try MIDIEventPacket(words: packetWords)
        
        self = MIDIEventList(protocol: midiProtocol,
                             numPackets: 1,
                             packet: packet)
        
    }
    
}
