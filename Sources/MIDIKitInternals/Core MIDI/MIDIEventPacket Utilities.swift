//
//  MIDIEventPacket Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
import Foundation

// MARK: - Init

extension CoreMIDI.MIDIEventPacket {
    /// Assembles a Core MIDI `MIDIEventPacket` (Universal MIDI Packet) from a `UInt32` word array.
    @_disfavoredOverload @inlinable
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    public init(
        words: [UInt32],
        timeStamp: UInt64 = mach_absolute_time()
    ) throws {
        guard !words.isEmpty else {
            throw MIDIInternalError.umpEmpty
        }
        
        guard words.count <= 64 else {
            throw MIDIInternalError.umpTooLarge
        }
        
        var packet = CoreMIDI.MIDIEventPacket()
        
        // time stamp
        packet.timeStamp = timeStamp
        
        // word count
        packet.wordCount = UInt32(words.count)
        
        // words
        let mutablePtr = CoreMIDI.UnsafeMutableMIDIEventPacketPointer(&packet)
        for wordsIndex in 0 ..< words.count {
            mutablePtr[mutablePtr.startIndex.advanced(by: wordsIndex)] = words[wordsIndex]
        }
        
        self = packet
    }
    
    // Note: this init isn't used but it works.
    // It implements Apple's built-in Core MIDI event packet builder.
    
    /// Assembles a Core MIDI `MIDIEventPacket` (Universal MIDI Packet) from a `UInt32` word array.
    @_disfavoredOverload @inlinable
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    package init(
        wordsUsingBuilder words: [UInt32],
        timeStamp: UInt64 = mach_absolute_time()
    ) throws {
        guard !words.isEmpty else {
            throw MIDIInternalError.umpEmpty
        }
        
        guard words.count <= 64 else {
            throw MIDIInternalError.umpTooLarge
        }
        
        let packetBuilder = CoreMIDI.MIDIEventPacket.Builder(
            maximumNumberMIDIWords: 64 // must be 64 or we get heap overflows/crashes!
        )
        
        packetBuilder.timeStamp = Int(timeStamp)
        
        words.forEach { packetBuilder.append($0) }
        
        let packet = try packetBuilder
            .withUnsafePointer { unsafePtr -> Result<CoreMIDI.MIDIEventPacket, Error> in
                .success(unsafePtr.pointee)
            }
            .get()
        
        self = packet
    }
}

// MARK: - Properties

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension CoreMIDI.MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket`.
    @_disfavoredOverload @inlinable
    public var rawWords: [UInt32] {
        withUnsafePointer(to: self) { $0.rawWords }
    }
}

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension UnsafePointer where Pointee == CoreMIDI.MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket` (`UnsafePointer`).
    @_disfavoredOverload @inlinable
    public var rawWords: [UInt32] {
        let wordCollection = words()
        
        guard !wordCollection.isEmpty else {
            return []
        }
        
        guard wordCollection.count <= 64 else {
            assertionFailure(
                "Received MIDIEventPacket reporting \(wordCollection.count) words."
            )
            return []
        }
        
        return Array(wordCollection)
    }
}

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension UnsafeMutablePointer where Pointee == CoreMIDI.MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket` (`UnsafeMutablePointer`).
    @_disfavoredOverload @inlinable
    public var rawWords: [UInt32] {
        UnsafePointer(self).rawWords
    }
}

#endif
