//
//  Byte Pair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Type that holds a pair of `Byte`s - one MSB `Byte`, one LSB `Byte`.
public struct BytePair: Equatable, Hashable {
    public let msb: Byte
    public let lsb: Byte
    
    /// Initialize from two UInt8 bytes.
    @inline(__always)
    public init(msb: Byte, lsb: Byte) {
        self.msb = msb
        self.lsb = lsb
    }
    
    /// Initialize from a UInt16 value.
    @inline(__always)
    public init(_ uInt16: UInt16) {
        msb = Byte((uInt16 & 0xFF00) >> 8)
        lsb = Byte((uInt16 & 0xFF))
    }
    
    /// Returns a UInt16 value by combining the byte pair.
    public var uInt16Value: UInt16 {
        (UInt16(msb) << 8) + UInt16(lsb)
    }
}

extension UInt16 {
    /// Initialize by combining a byte pair.
    public init(bytePair: BytePair) {
        self = bytePair.uInt16Value
    }
    
    /// Returns a struct that holds a pair of `Byte`s - one MSB `Byte`, one LSB `Byte`.
    public var bytePair: BytePair {
        BytePair(self)
    }
}
