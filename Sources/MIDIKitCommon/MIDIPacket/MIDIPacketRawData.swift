//
//  MIDIPacketRawData.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

extension MIDIPacket {
	
	/// `MIDIPacket.data` raw size in number of bytes
	@inline(__always) public static let rawDataTupleLength = 256
	
}

/// a.k.a `MIDIPacket.data`
public typealias MIDIPacketRawData =
	(Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte,
	 Byte, Byte, Byte, Byte, Byte, Byte, Byte, Byte)
