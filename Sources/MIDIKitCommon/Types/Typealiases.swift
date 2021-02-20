//
//  Typealiases.swift
//  MITIKit
//
//  Created by Steffan Andrews on 2021-01-24.
//

// MARK: - Byte and Nibble

/// Type representing an 8-bit byte
public typealias Byte = UInt8

/// Tuple represending a pair of Bytes - one MSB Byte, one LSB Byte
public struct BytePair: Equatable, Hashable {
	
	public let MSB: Byte
	public let LSB: Byte
	
	public init(MSB: Byte, LSB: Byte) {
		self.MSB = MSB
		self.LSB = LSB
	}
	
}

/// Type representing a 4-bit nibble
public typealias Nibble = MIDIUInt4

extension Byte {
	
	/// Returns the high and low 4-bit nibbles
	public var nibbles: (high: Nibble, low: Nibble) {
		let high = (self & 0b1111_0000) >> 4
		let low = self & 0b1111
		
		return (high: Nibble(high), low: Nibble(low))
	}
	
	/// Convenience initializer from high and low 4-bit nibbles
	public init(high: Nibble, low: Nibble) {
		self = (high.asUInt8 << 4) + low.asUInt8
	}
	
}

// MARK: - CCValue

/// Type representing a 7-bit value (0...127)
public typealias CCValue = MIDIUInt7
