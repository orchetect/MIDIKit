//
//  UMPWord.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet Word: Type representing four 8-bit bytes.
public typealias UMPWord = UInt32

extension UMPWord {
    /// Internal: Pack a `UInt32` with four 8-bit bytes.
    @_disfavoredOverload
    public init(
        _ byte0: UInt8,
        _ byte1: UInt8,
        _ byte2: UInt8,
        _ byte3: UInt8
    ) {
        self =
            (Self(byte0) << 24) +
            (Self(byte1) << 16) +
            (Self(byte2) << 8) +
            Self(byte3)
    }
    
    /// Internal: Pack a `UInt32` with two `UInt16`.
    @_disfavoredOverload
    public init(
        _ byte0and1: UInt16,
        _ byte2and3: UInt16
    ) {
        self =
            (Self(byte0and1) << 16) +
            Self(byte2and3)
    }
}

extension Collection<UMPWord> {
    /// Internal: Flattens an array of `UInt32` UMP words into an array of bytes.
    public func umpWordsToBytes() -> [UInt8] {
        var bytes: [UInt8] = []
        bytes.reserveCapacity(4 * count)
    
        forEach { word in
            let byte1 = UInt8((word & 0xFF00_0000) >> 24)
            let byte2 = UInt8((word & 0x00FF_0000) >> 16)
            let byte3 = UInt8((word & 0x0000_FF00) >> 8)
            let byte4 = UInt8(word & 0x0000_00FF)
    
            bytes.append(byte1)
            bytes.append(byte2)
            bytes.append(byte3)
            bytes.append(byte4)
        }
    
        return bytes
    }
}
