//
//  MIDIPacketData.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

/// Type that can iterate on raw `MIDIPacket.data` (aka `MIDIPacketRawData`)
public struct MIDIPacketData: Sequence {
	
	public typealias Element = Byte
	
	public var rawData: MIDIPacketRawData
	
	public var length: Int
	
	/// Returns a [Byte] UInt8 Array of `rawData`, sized to `length`.
	public var array: [Byte] { Array(makeIterator()) }
	
	/// Max byte length of `MIDIPacket` data.
	public static let maxLength = MIDIPacket.rawDataTupleLength
	
	/// If `length` is nil, length will default to 256 bytes.
	public init(_ tuple: MIDIPacketRawData, length: Int? = nil) {
		
		rawData = tuple
		
		self.length = length?
			.clamped(to: 0...Self.maxLength)
			?? Self.maxLength
		
	}
	
	/// If `length` is nil, length will default to 256 bytes.
	public init(_ tuple: MIDIPacketRawData, length: UInt16? = nil) {
		
		self.init(tuple, length: length?.int)
		
	}
	
	/// Custom iterator for `MIDIPacket`
	public func makeIterator() -> AnyIterator<Byte> {
		
		AnyIterator<Byte>(
			Mirror(reflecting: rawData)
				.children
				.lazy
				.prefix(length)
				.map { $0.value as! Byte }
				.makeIterator()
		)
		
	}
	
}

