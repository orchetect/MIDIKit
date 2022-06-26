//
//  BytePair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Byte {
    
    /// Type that holds a pair of `MIDI.Byte`s - one MSB `Byte`, one LSB `Byte`
    public struct Pair: Equatable, Hashable {
        
        public let msb: MIDI.Byte
        public let lsb: MIDI.Byte
        
        /// Initialize from two UInt8 bytes.
        @inline(__always)
        public init(msb: MIDI.Byte, lsb: MIDI.Byte) {
            
            self.msb = msb
            self.lsb = lsb
            
        }
        
        /// Initialize from a UInt16 value.
        @inline(__always)
        public init(_ uInt16: UInt16) {
            
            self.msb = MIDI.Byte((uInt16 & 0xFF00) >> 8)
            self.lsb = MIDI.Byte((uInt16 & 0xFF))
            
        }
        
        /// Returns a UInt16 value by combining the byte pair.
        public var uInt16Value: UInt16 {
            
            (UInt16(msb) << 8) + UInt16(lsb)
            
        }
        
    }
    
}

extension UInt16 {
    
    /// Initialize by combining a byte pair.
    public init(bytePair: MIDI.Byte.Pair) {
        
        self = bytePair.uInt16Value
        
    }
    
    /// Returns a struct that holds a pair of `MIDI.Byte`s - one MSB `Byte`, one LSB `Byte`.
    public var bytePair: MIDI.Byte.Pair {
        
        MIDI.Byte.Pair(self)
        
    }
    
}
