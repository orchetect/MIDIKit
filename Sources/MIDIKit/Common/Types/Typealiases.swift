//
//  Typealiases.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Byte and Nibble

extension MIDI {
    
    /// Type representing an 8-bit byte
    public typealias Byte = UInt8
    
    /// Type representing a 4-bit nibble
    public typealias Nibble = MIDI.UInt4
    
}

extension MIDI.Byte {
	
	/// Returns the high and low 4-bit nibbles
	@inline(__always) public var nibbles: (high: MIDI.Nibble, low: MIDI.Nibble) {
		let high = (self & 0b1111_0000) >> 4
		let low = self & 0b1111
		
        return (high: MIDI.Nibble(high), low: MIDI.Nibble(low))
	}
	
	/// Convenience initializer from high and low 4-bit nibbles
	@inlinable public init(high: MIDI.Nibble, low: MIDI.Nibble) {
		self = (high.asUInt8 << 4) + low.asUInt8
	}
	
}

// MARK: - BytePair

extension MIDI {
    
    /// Tuple representing a pair of Bytes - one MSB Byte, one LSB Byte
    public struct BytePair: Equatable, Hashable {
        
        public let MSB: MIDI.Byte
        public let LSB: MIDI.Byte
        
        @inline(__always) public init(MSB: MIDI.Byte, LSB: MIDI.Byte) {
            self.MSB = MSB
            self.LSB = LSB
        }
        
    }
    
}
