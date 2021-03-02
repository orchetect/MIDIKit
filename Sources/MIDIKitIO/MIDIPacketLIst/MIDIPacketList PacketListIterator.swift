//
//  MIDIPacketList PacketListIterator.swift
//  MIDIIOKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

extension MIDIPacketList {
	
	/// Custom iterator to iterate `MIDIPacket`s within a `MIDIPacketList`.
	public struct PacketListIterator: IteratorProtocol {
		
		public typealias Element = MIDIPacket
		
		// Extracted packet list info
		var count: UInt32
		var index: Int = -1
		
		// Iteration state
		var packet: MIDIPacket
		
		/// Initialize the packet list generator with a packet list
		/// - parameter packetList: MIDI Packet List
		@inline(__always) init(_ packetList: MIDIPacketList) {
			
			self.packet = packetList.packet
			self.count = packetList.numPackets
			
		}
		
		/// Provide the next element (packet)
		@inline(__always) public mutating func next() -> Element? {
			
			// On Intel and PowerPC, MIDIPacket is unaligned.
			// On ARM, MIDIPacket must be 4-byte aligned; MIDIPacketNext(...) takes care of this.
			
			index += 1
			
			// ensure we are able to advance the index before proceeding,
			// otherwise MIDIPacketNext will produce a crash (thanks, Apple)
			guard index < count else { return nil }
			
			// advance to next packet if not the first packet
			if index > 0 {
				// advance and return pointer to next packet
				// withUnsafePointer is needed - do not just pass packet directly into MIDIPacketNext
				packet = withUnsafePointer(to: &packet) { MIDIPacketNext($0).pointee }
			}
			
			return packet
			
		}
		
	}
	
}
