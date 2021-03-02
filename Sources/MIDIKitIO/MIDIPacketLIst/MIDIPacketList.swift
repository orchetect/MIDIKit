//
//  MIDIPacketList.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

extension MIDIPacketList: Sequence {
	
	public typealias Iterator = PacketListIterator

	/// Create a generator from the packet list
	@inline(__always) public func makeIterator() -> Iterator {
		
		Iterator(self)
		
	}
	
}

