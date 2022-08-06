//
//  Byte.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    /// Type representing an 8-bit byte.
    public typealias Byte = UInt8
}

extension MIDI.Byte {
    /// Returns a `Byte` as its 4-bit nibbles: high `(& 0xF0 >> 4)` and low `(& 0x0F)`.
    @inline(__always)
    public var nibbles: (high: MIDI.Nibble, low: MIDI.Nibble) {
        let high = (self & 0b1111_0000) >> 4
        let low = self & 0b1111
        
        return (high: MIDI.Nibble(high), low: MIDI.Nibble(low))
    }
    
    /// Convenience initializer from high and low 4-bit nibbles.
    @inline(__always)
    public init(high: MIDI.Nibble, low: MIDI.Nibble) {
        self = (high.uInt8Value << 4) + low.uInt8Value
    }
}
