//
//  MIDIEventList Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDIEventPacket {
    
    /// Internal:
    /// Assembles a Core MIDI `MIDIEventPacket` (Universal MIDI Packet) from a `UInt32` word array.
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inline(__always)
    internal init(
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

extension MIDIEventPacket {
    
    // Note: this init isn't used but it works.
    // It implements Apple's built-in Core MIDI event packet builder.
    
    /// Internal:
    /// Assembles a Core MIDI `MIDIEventPacket` (Universal MIDI Packet) from a `UInt32` word array.
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inline(__always)
    internal init(
        wordsUsingBuilder: [MIDI.UMPWord]
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

        let packetBuilder = MIDIEventPacket
            .Builder(maximumNumberMIDIWords: 64) // must be 64 or we get crashes!
        
        words.forEach { packetBuilder.append($0) }
        
        let packet = try packetBuilder
            .withUnsafePointer { unsafePtr -> Result<MIDIEventPacket, Error> in
                    .success(unsafePtr.pointee)
            }
            .get()
        
        self = packet

    }

}

extension MIDIEventList {
    
    /// Internal:
    /// Assembles a single Core MIDI `MIDIEventPacket` from a Universal MIDI Packet `UInt32` word array and wraps it in a Core MIDI `MIDIEventList`.
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    @inline(__always)
    internal init(
        protocol midiProtocol: MIDIProtocolID,
        packetWords: [MIDI.UMPWord]
    ) throws {
        
        let packet = try MIDIEventPacket(words: packetWords)
        
        self = MIDIEventList(protocol: midiProtocol,
                             numPackets: 1,
                             packet: packet)
        
    }
    
}
