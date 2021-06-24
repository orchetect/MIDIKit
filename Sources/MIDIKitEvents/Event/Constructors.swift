//
//  Constructors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
	
	/// Creates a new MIDI voice message event.
	public static func chanVoice(_ message: ChannelVoiceMessage) -> MIDI.Event {
		
		.init(message)
		
	}
	
	/// Creates a new MIDI system common event.
	public static func sysCommon(_ message: SystemCommon) -> MIDI.Event {
		
		.init(message)
		
	}
	
	/// Creates a new MIDI real time event.
	public static func sysRealTime(_ message: SystemRealTime) -> MIDI.Event {
		
		.init(message)
		
	}
	
	/// Creates a new MIDI real system exclusive event.
	public static func sysExclusive(manufacturer: Byte,
									message: [Byte]) -> MIDI.Event {
		
		.init(.sysEx(manufacturer: manufacturer,
					 message: message))
		
	}
	
	#warning("> this may need to change or may not be needed")
	/// Creates a new raw MIDI event.
	public static func raw(_ bytes: [Byte]) throws -> MIDI.Event {
		
		try .init(rawBytes: bytes)
		
	}
	
}
