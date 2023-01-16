//
//  MIDIEventPacket Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import CoreMIDI

@available(macOS 11, iOS 14, macCatalyst 14, *)
extension UnsafePointer where Pointee == MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket`.
    @_disfavoredOverload
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
extension MIDIEventPacket {
    /// Returns the raw words contained in the `MIDIEventPacket`.
    @_disfavoredOverload
    public var rawWords: [UInt32] {
        var mutableSelf = self
        
        return withUnsafePointer(to: self) { unsafePtr -> [UInt32] in
            let wordCollection = MIDIEventPacket.WordCollection(&mutableSelf)
            
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
}

#endif
