//
//  MIDIKitIntegerProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

/// Specialized integer types representing non-standard bit-width values in `MIDIKit`.
public protocol MIDIKitIntegerProtocol {
	
    // Storage
    
    associatedtype Storage: BinaryInteger
    var value: Storage { get }
    
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
	
	/// Minimum value storable
	static var min: Self { get }
    static func min<T: BinaryInteger>(_ ofType: T.Type) -> T
    
	/// Maximum value storable
	static var max: Self { get }
    static func max<T: BinaryInteger>(_ ofType: T.Type) -> T
    
	// Computed properties
	
	/// Returns the integer as an `Int` instance
	var int: Int { get }
    
}

extension MIDIKitIntegerProtocol {
    
    public init?<T: BinaryInteger>(exactly source: T) {
        if source < Self.min(Int.self) { return nil }
        if source > Self.max(Int.self) { return nil }
        self.init(source)
    }
    
    public init<T: BinaryInteger>(clamping source: T) {
        let clamped = Storage(source.int.clamped(to: Self.min(Int.self)...Self.max(Int.self)))
        self.init(clamped)
    }
    
    public static var min: Self { Self(Self.min(Storage.self)) }
    public static var max: Self { Self(Self.max(Storage.self)) }
    
    public var int: Int { value.int }
    
}

// MARK: - Operators

extension MIDIKitIntegerProtocol {
    
    @_disfavoredOverload
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value + rhs.value)
    }
    
    @_disfavoredOverload
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value - rhs.value)
    }
    
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value * rhs.value)
    }
    
    @_disfavoredOverload
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value / rhs.value)
    }
    
    @_disfavoredOverload
    public static func % (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value % rhs.value)
    }
    
    // assignment
    
    @_disfavoredOverload
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.value + rhs.value)
    }
    
    @_disfavoredOverload
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.value - rhs.value)
    }
    @_disfavoredOverload
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.value * rhs.value)
    }
    
    @_disfavoredOverload
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.value / rhs.value)
    }
    
}

extension MIDIKitIntegerProtocol {
    
    public static func + (lhs: Self, rhs: Storage) -> Self {
        Self(lhs.value + rhs)
    }
    
    public static func - (lhs: Self, rhs: Storage) -> Self {
        Self(lhs.value - rhs)
    }
    
    public static func * (lhs: Self, rhs: Storage) -> Self {
        Self(lhs.value * rhs)
    }
    
    public static func / (lhs: Self, rhs: Storage) -> Self {
        Self(lhs.value / rhs)
    }
    
    public static func % (lhs: Self, rhs: Storage) -> Self {
        Self(lhs.value % rhs)
    }
    
    // assignment
    
    public static func += (lhs: inout Self, rhs: Storage) {
        lhs = Self(lhs.value + rhs)
    }
    
    public static func -= (lhs: inout Self, rhs: Storage) {
        lhs = Self(lhs.value - rhs)
    }
    
    public static func *= (lhs: inout Self, rhs: Storage) {
        lhs = Self(lhs.value * rhs)
    }
    
    public static func /= (lhs: inout Self, rhs: Storage) {
        lhs = Self(lhs.value / rhs)
    }
    
}

extension MIDIKitIntegerProtocol {
    
    public static func + (lhs: Storage, rhs: Self) -> Storage {
        lhs + rhs.value
    }
    
    public static func - (lhs: Storage, rhs: Self) -> Storage {
        lhs - rhs.value
    }
    
    public static func * (lhs: Storage, rhs: Self) -> Storage {
        lhs * rhs.value
    }
    
    public static func / (lhs: Storage, rhs: Self) -> Storage {
        lhs / rhs.value
    }
    
    public static func % (lhs: Storage, rhs: Self) -> Storage {
        lhs % rhs.value
    }
    
    // assignment
    
    public static func += (lhs: inout Storage, rhs: Self) {
        lhs += rhs.value
    }
    
    public static func -= (lhs: inout Storage, rhs: Self) {
        lhs -= rhs.value
    }
    
    public static func *= (lhs: inout Storage, rhs: Self) {
        lhs *= rhs.value
    }
    
    public static func /= (lhs: inout Storage, rhs: Self) {
        lhs /= rhs.value
    }
    
}

extension BinaryInteger {
    
    /// Creates a new instance from the given integer.
    public init<T: MIDIKitIntegerProtocol>(_ source: T) {
        self.init(source.value)
    }
    
    /// Creates a new instance from the given integer, if it can be represented exactly.
    public init?<T: MIDIKitIntegerProtocol>(exactly source: T) {
        self.init(exactly: source.value)
    }
    
}
