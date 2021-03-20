//
//  Events Bridge (legacy).swift
//  MIDIKit (legacy)
//
//  Created by Steffan Andrews on 2021-03-04.
//  Copyright © 2021 orchetect. All rights reserved.
//

@_implementationOnly import OTCore

extension MIDIIOSendsMIDIMessages {
	
	/// Send a note-on event.
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func send(noteOn: Int,
			  velocity: Int,
			  channel: Int) {
		
		let bytes =
			OTMIDIEvent.eventWithNoteOn(
				note: noteOn.clamped(to: 0...127).uint8,
				velocity: velocity.clamped(to: 0...127).uint8,
				channel: channel.clamped(to: 0...15).uint8)
			.rawData
		
		_ = try? send(rawMessage: bytes)
		
	}
	
	/// Send a note-off event.
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func send(noteOff: Int,
			  velocity: Int,
			  channel: Int,
			  useNoteOnZero: Bool = true) {
		
		if useNoteOnZero {
			let bytes =
				OTMIDIEvent.eventWithNoteOn(
					note: noteOff.clamped(to: 0...127).uint8,
					velocity: 0,
					channel: channel.clamped(to: 0...15).uint8)
				.rawData
			
			_ = try? send(rawMessage: bytes)
		} else {
			let bytes =
				OTMIDIEvent.eventWithNoteOff(
					note: noteOff.clamped(to: 0...127).uint8,
					velocity: velocity.clamped(to: 0...127).uint8,
					channel: channel.clamped(to: 0...15).uint8)
				.rawData
			
			_ = try? send(rawMessage: bytes)
		}
		
	}
	
	/// Send a controller change (CC) event.
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func send(controllerChange: Int,
			  value: Int,
			  channel: Int) {
		
		let bytes =
			OTMIDIEvent.eventWithController(
				controller: controllerChange.clamped(to: 0...127).uint8,
				value: value.clamped(to: 0...127).uint8,
				channel: channel.clamped(to: 0...15).uint8
			)
			.rawData
		
		_ = try? send(rawMessage: bytes)
		
	}
	
	/// Send a program change event.
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func send(programChange: Int,
			  channel: Int) {
		
		let bytes =
			OTMIDIEvent.eventWithProgramChange(
				program: programChange.clamped(to: 0...127).uint8,
				channel: channel.clamped(to: 0...15).uint8)
			.rawData
		
		_ = try? send(rawMessage: bytes)
		
	}
	
	/// Send a channel pressure event.
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func send(channelPressure: Int,
			  channel: Int) {
		
		let bytes =
			OTMIDIEvent.eventWithPressure(
				pressure: channelPressure.clamped(to: 0...127).uint8,
				channel: channel.clamped(to: 0...15).uint8)
			.rawData
		
		_ = try? send(rawMessage: bytes)
		
	}
	
}
