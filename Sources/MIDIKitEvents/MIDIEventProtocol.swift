//
//  MIDIEventProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - MIDIEventProtocol

public protocol MIDIEventProtocol {
	
	/// Raw bytes of the MIDI event message.
	var rawBytes: [Byte] { get }
	
	/// Construct from raw bytes.
	/// Throws an error of type `ParseError` in the event of failure.
	init(rawBytes: [Byte]) throws
	
	/// Constructs a `MIDI.Event` instance from this event case.
	func asEvent() -> MIDI.Event
	
}
