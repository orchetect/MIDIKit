//
//  MIDIEventPacket Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
import Foundation

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension UnsafePointer where Pointee == MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket`.
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
extension UnsafeMutablePointer where Pointee == MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket`.
    @_disfavoredOverload @inlinable
    public var rawWords: [UInt32] {
        UnsafePointer(self).rawWords
    }
}

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket`.
    @_disfavoredOverload @inlinable
    public var rawWords: [UInt32] {
        withUnsafePointer(to: self) { $0.rawWords }
    }
}

#endif
