//
//  MIDIIOSendsMIDIMessages.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

public protocol MIDIIOSendsMIDIMessages {
	
	var portRef: MIDIPortRef? { get }
	
	func send(rawMessage: [Byte]) throws
	func send(rawMessages: [[Byte]]) throws
	func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
	
}

extension MIDIIOSendsMIDIMessages {
	
	/// Send a MIDI Message, automatically assembling it into a `MIDIPacketList`.
	///
	/// - parameter rawMessage: MIDI message
	@inlinable public func send(rawMessage: [Byte]) throws {
		
		let packetListPointer = try MIDIIO.assemblePacket(data: rawMessage)
		
		try send(packetList: packetListPointer)
		
		// we HAVE to deallocate this here after we're done with it
		packetListPointer.deallocate()
		
	}
	
	/// Send one or more MIDI message(s), automatically assembling it into a `MIDIPacketList`.
	///
	/// - parameter rawMessages: Array of MIDI messages
	@inlinable public func send(rawMessages: [[Byte]]) throws {
		
		let packetListPointer = try MIDIIO.assemblePackets(data: rawMessages)
		
		try send(packetList: packetListPointer)
		
		// we HAVE to deallocate this here after we're done with it
		packetListPointer.deallocate()
		
	}
	
}
