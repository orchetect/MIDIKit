//
//  Byte.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Type representing an 8-bit MIDI byte.
public typealias Byte = UInt8

extension Byte {
    /// Returns a `Byte` as its 4-bit nibbles: high `(& 0xF0 >> 4)` and low `(& 0x0F)`.
    @inline(__always)
    public var nibbles: (high: Nibble, low: Nibble) {
        let high = (self & 0b1111_0000) >> 4
        let low = self & 0b1111
    
        return (high: Nibble(high), low: Nibble(low))
    }
    
    /// Convenience initializer from high and low 4-bit nibbles.
    @inline(__always)
    public init(high: Nibble, low: Nibble) {
        self = (high.uInt8Value << 4) + low.uInt8Value
    }
}
