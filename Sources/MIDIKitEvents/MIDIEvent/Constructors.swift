//
//  Constructors.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-21.
//

extension MIDIEvent {
	
	/// Creates a new MIDI voice message event.
	public static func chanVoice(_ message: ChannelVoiceMessage) -> MIDIEvent {
		
		.init(message)
		
	}
	
	/// Creates a new MIDI system common event.
	public static func sysCommon(_ message: SystemCommon) -> MIDIEvent {
		
		.init(message)
		
	}
	
	/// Creates a new MIDI real time event.
	public static func sysRealTime(_ message: SystemRealTime) -> MIDIEvent {
		
		.init(message)
		
	}
	
	/// Creates a new MIDI real system exclusive event.
	public static func sysExclusive(manufacturer: Byte,
									message: [Byte]) -> MIDIEvent {
		
		.init(.sysEx(manufacturer: manufacturer,
					 message: message))
		
	}
	
	#warning("> this may need to change or may not be needed")
	/// Creates a new raw MIDI event.
	public static func raw(_ bytes: [Byte]) throws -> MIDIEvent {
		
		try .init(rawBytes: bytes)
		
	}
	
}
