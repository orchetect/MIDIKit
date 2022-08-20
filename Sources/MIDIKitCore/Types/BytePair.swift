//
//  BytePair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Type that holds a pair of `UInt8`s - one MSB `UInt8`, one LSB `UInt8`.
public struct BytePair: Equatable, Hashable {
    public let msb: UInt8
    public let lsb: UInt8
    
    /// Initialize from two UInt8 bytes.
    public init(msb: UInt8, lsb: UInt8) {
        self.msb = msb
        self.lsb = lsb
    }
    
    /// Initialize from a UInt16 value.
    public init(_ uInt16: UInt16) {
        msb = UInt8((uInt16 & 0xFF00) >> 8)
        lsb = UInt8((uInt16 & 0xFF))
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
    
    /// Returns a struct that holds a pair of `UInt8`s - one MSB `UInt8`, one LSB `UInt8`.
    public var bytePair: BytePair {
        BytePair(self)
    }
}
