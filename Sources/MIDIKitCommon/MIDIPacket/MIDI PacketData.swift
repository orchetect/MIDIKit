//
//  MIDIPacketData.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI {
	
	/// Clean data encapsulation of a `MIDIPacket`.
	public struct PacketData {
		
		/// Raw data
		@inline(__always) public var data: Data
		
		@inline(__always) public var timeStamp: MIDITimeStamp
		
		/// Returns `[Byte]` representation `.data`.
		/// - Note: accessing `.data` property is more performant.
		@inline(__always) public var bytes: [Byte] {
			
			[Byte](data)
			
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
	
}
