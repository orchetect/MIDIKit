//
//  MIDIPacketList PacketListIterator.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

extension MIDIPacketList {
	
	/// Custom iterator to iterate `MIDIPacket`s within a `MIDIPacketList`.
	public struct PacketListIterator: IteratorProtocol {
		
		public typealias Element = MIDIPacket
		
		var count: UInt32
		var index: Int = 0
		var packet: MIDIPacket
		
		/// Initialize the packet list generator with a packet list
		/// - parameter packetList: MIDI Packet List
		init(_ packetList: MIDIPacketList) {
			
			self.packet = packetList.packet
			self.count = packetList.numPackets
			
		}
		
		@_optimize(none)
		public mutating func next() -> Element? {
			
			// On Intel and PowerPC, MIDIPacket is unaligned.
			// On ARM, MIDIPacket must be 4-byte aligned
			// MIDIPacketNext(...) takes care of this.
			
			guard index < count else { return nil }
			
			if index > 0 {
				packet = MIDIPacketNext(&packet).pointee
			}
			index += 1
			
			return packet
			
		}
		
	}
	
}
