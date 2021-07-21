//
//  UInt7.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import OTCore
@_implementationOnly import OTCoreTesting

extension MIDI {
	
	/// A 7-bit unsigned integer value type used in `MIDIKit`.
	public struct UInt7: MIDIKitIntegerProtocol {
		
		// MARK: Storage
		
        public typealias Storage = UInt8
        public internal(set) var value: Storage
		
		// MARK: Inits
		
        public init() {
            value = 0
        }
		
        public init<T: BinaryInteger>(_ source: T) {
            if source.int < Self.min(Int.self) { fatalError("Underflow") }
            if source.int > Self.max(Int.self) { fatalError("Overflow") }
            value = Storage(source)
        }
        
		// MARK: Constants
		
		public static let bitWidth: Int = 7
		
        public static func min<T: BinaryInteger>(_ ofType: T.Type) -> T { 0 }
        
        public static let midpoint = Self(Self.midpoint(Storage.self))
        public static func midpoint<T: BinaryInteger>(_ ofType: T.Type) -> T { 64 }
        
        public static func max<T: BinaryInteger>(_ ofType: T.Type) -> T { 0b111_1111 }
        
		// MARK: Computed properties
		
		/// Returns the integer as a `UInt8` instance
		public var uint8: UInt8 { value }
		
	}
	
}

extension MIDI.UInt7: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = Storage
    
    public init(integerLiteral value: Storage) {
        self.init(value)
    }
    
}

extension MIDI.UInt7: Equatable, Comparable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.value == rhs.value
	}
	
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.value < rhs.value
	}
	
}

extension MIDI.UInt7: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}
	
}

extension MIDI.UInt7: Codable {
	
	enum CodingKeys: String, CodingKey {
		case value = "UInt7"
	}
	
}

extension MIDI.UInt7: CustomStringConvertible {
    
    public var description: String {
        "\(value)"
    }
    
}

// MARK: - Standard library extensions

extension BinaryInteger {
	
	/// Convenience initializer for `MIDI.UInt7`.
	public var midiUInt7: MIDI.UInt7 {
		MIDI.UInt7(self)
	}
	
    /// Convenience initializer for `MIDI.UInt7(exactly:)`.
    public var midiUInt7Exactly: MIDI.UInt7? {
        MIDI.UInt7(exactly: self)
    }
    
}
