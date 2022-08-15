//
//  UMPWord.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet Word: Type representing four 8-bit bytes.
public typealias UMPWord = UInt32

extension UMPWord {
    /// Internal: Pack a `UInt32` with four 8-bit bytes.
    @inline(__always) @_disfavoredOverload
    internal init(
        _ byte0: Byte,
        _ byte1: Byte,
        _ byte2: Byte,
        _ byte3: Byte
    ) {
        self =
            (Self(byte0) << 24) +
            (Self(byte1) << 16) +
            (Self(byte2) << 8) +
            Self(byte3)
    }
    
    /// Internal: Pack a `UInt32` with two `UInt16`.
    @inline(__always) @_disfavoredOverload
    internal init(
        _ byte0and1: UInt16,
        _ byte2and3: UInt16
    ) {
        self =
            (Self(byte0and1) << 16) +
            Self(byte2and3)
    }
}

extension Collection where Element == UMPWord {
    /// Internal: Flattens an array of `UInt32` UMP words into an array of bytes.
    @inline(__always)
    internal func umpWordsToBytes() -> [Byte] {
        var bytes: [Byte] = []
        bytes.reserveCapacity(4 * count)
    
        forEach { word in
            let byte1 = Byte((word & 0xFF00_0000) >> 24)
            let byte2 = Byte((word & 0x00FF_0000) >> 16)
            let byte3 = Byte((word & 0x0000_FF00) >> 8)
            let byte4 = Byte(word & 0x0000_00FF)
    
            bytes.append(byte1)
            bytes.append(byte2)
            bytes.append(byte3)
            bytes.append(byte4)
        }
    
        return bytes
    }
}
