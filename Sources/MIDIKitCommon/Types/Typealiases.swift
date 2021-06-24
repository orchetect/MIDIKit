//
//  Typealiases.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Byte and Nibble

/// Type representing an 8-bit byte
public typealias Byte = UInt8

/// Tuple represending a pair of Bytes - one MSB Byte, one LSB Byte
public struct BytePair: Equatable, Hashable {
	
	public let MSB: Byte
	public let LSB: Byte
	
	@inlinable public init(MSB: Byte, LSB: Byte) {
		self.MSB = MSB
		self.LSB = LSB
	}
	
}

/// Type representing a 4-bit nibble
public typealias Nibble = MIDI.UInt4

extension Byte {
	
	/// Returns the high and low 4-bit nibbles
	@inlinable public var nibbles: (high: Nibble, low: Nibble) {
		let high = (self & 0b1111_0000) >> 4
		let low = self & 0b1111
		
		return (high: Nibble(high), low: Nibble(low))
	}
	
	/// Convenience initializer from high and low 4-bit nibbles
	@inlinable public init(high: Nibble, low: Nibble) {
		self = (high.asUInt8 << 4) + low.asUInt8
	}
	
}

// MARK: - CCValue

/// Type representing a 7-bit value (0...127)
public typealias CCValue = MIDI.UInt7
