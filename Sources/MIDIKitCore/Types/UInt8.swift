//
//  UInt8.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// a.k.a. 8-bit MIDI byte.
extension UInt8 {
    /// Returns a `UInt8` as its 4-bit nibbles:
    /// High `((& 0xF0) >> 4)` and low `(& 0x0F)`.
    @_disfavoredOverload @inline(__always)
    public var nibbles: (high: UInt4, low: UInt4) {
        let high = (self & 0xF0) >> 4
        let low = self & 0xF
    
        return (high: UInt4(high), low: UInt4(low))
    }
    
    /// Convenience initializer from high and low 4-bit nibbles.
    @_disfavoredOverload @inline(__always)
    public init(high: UInt4, low: UInt4) {
        self = (high.uInt8Value << 4) + low.uInt8Value
    }
}
