//
//  MIDIKitInteger.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-24.
//

/// Specialized integer types representing non-standard bit-width values in `MIDIKit`
public protocol MIDIKitInteger {
	
	// Inits
	
	/// Creates a new value equal to zero.
	init()
	
	/// Creates a new instance from the given integer.
	/// Throws an exception in the event of overflow.
	init<T: BinaryInteger>(_ source: T)
	
	/// Creates a new instance from the given integer.
	/// Returns `nil` in the event of overflow.
	init?<T: BinaryInteger>(exactly source: T)
	
	/// Creates a new instance from the given integer.
	/// Clamps value to `min` or `max` in the event of overflow.
	init<T: BinaryInteger>(clamping source: T)
	
	// Constants
	
	/// Bit width of the integer
	static var bitWidth: Int { get }
	
	/// Bit width of the integer
	static var min: Self { get }
	
	/// Bit width of the integer
	static var max: Self { get }
	
	// Computed properties
	
	/// Returns the integer as an `Int` instance
	var asInt: Int { get }
	
}
