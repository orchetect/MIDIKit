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
	@inline(__always) public var array: [Byte] { Array(makeIterator()) }
	
	/// Max byte length of `MIDIPacket` data.
	@inline(__always) public static let maxLength = MIDIPacket.rawDataTupleLength
	
	/// If `length` is nil, length will default to 256 bytes.
	@inline(__always) public init(_ tuple: MIDIPacketRawData, length: Int? = nil) {
		
		rawData = tuple
		
		self.length = length?
			.clamped(to: 0...Self.maxLength)
			?? Self.maxLength
		
	}
	
	/// If `length` is nil, length will default to 256 bytes.
	@inline(__always) public init(_ tuple: MIDIPacketRawData, length: UInt16? = nil) {
		
		self.init(tuple, length: length?.int)
		
	}
	
	@inline(__always) public init(_ midiPacket: MIDIPacket) {
		
		self.init(midiPacket.data, length: midiPacket.length)
		
	}
	
	/// Custom iterator for `MIDIPacket`
	@inline(__always) public func makeIterator() -> AnyIterator<Byte> {
		
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

extension MIDIPacket {
	
	/// Converts an instance of `MIDIPacket` to `MIDIPacketData`
	@inline(__always) public var packetData: MIDIPacketData {
		
		MIDIPacketData(self)
		
	}
	
}
