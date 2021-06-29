//
//  MIDIIOSendsMIDIMessagesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOSendsMIDIMessagesProtocol {
	
	var portRef: MIDIPortRef? { get }
	
	func send(rawMessage: [Byte]) throws
	func send(rawMessages: [[Byte]]) throws
	func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws
	
}

extension MIDIIOSendsMIDIMessagesProtocol {
	
	/// Send a MIDI Message, automatically assembling it into a `MIDIPacketList`.
	///
	/// - Parameter rawMessage: MIDI message
	@inlinable public func send(rawMessage: [Byte]) throws {
		
		let packetListPointer = try MIDI.IO.assemblePacket(data: rawMessage)
		
		try send(packetList: packetListPointer)
		
		// we HAVE to deallocate this here after we're done with it
		packetListPointer.deallocate()
		
	}
	
	/// Send one or more MIDI message(s), automatically assembling it into a `MIDIPacketList`.
	///
	/// - Parameter rawMessages: Array of MIDI messages
	@inlinable public func send(rawMessages: [[Byte]]) throws {
		
		let packetListPointer = try MIDI.IO.assemblePackets(data: rawMessages)
		
		try send(packetList: packetListPointer)
		
		// we HAVE to deallocate this here after we're done with it
		packetListPointer.deallocate()
		
	}
	
}
