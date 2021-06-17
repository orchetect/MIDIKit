//
//  MIDIPacketData.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

/// Clean data encapsulation of a `MIDIPacket`.
public struct MIDIPacketData {
	
	/// Raw data
	@inline(__always) public var data: Data
	
	@inline(__always) public var timeStamp: MIDITimeStamp
	
	/// Returns `[Byte]` representation `.data`.
	/// - Note: accessing `.data` property is more performant.
	@inline(__always) public var bytes: [Byte] {
		
		[Byte](data)
		
	}
	
	@available(swift, obsoleted: 1, renamed: "bytes")
	public var array: [Byte] {
		
		bytes
		
	}
	
	@inline(__always) public init(data: Data, timeStamp: MIDITimeStamp) {
		
		self.data = data
		self.timeStamp = timeStamp
		
	}
	
	@inline(__always) public init(data: [Byte], timeStamp: MIDITimeStamp) {
		
		self.data = Data(data)
		self.timeStamp = timeStamp
		
	}
	
}
