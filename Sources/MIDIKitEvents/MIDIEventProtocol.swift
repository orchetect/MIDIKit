//
//  MIDIEventProtocol.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-22.
//

// MARK: - AnyMIDIEvent

public protocol MIDIEventProtocol {
	
	/// Raw bytes of the MIDI event message.
	var rawBytes: [Byte] { get }
	
	/// Construct from raw bytes.
	/// Throws an error of type `ParseError` in the event of failure.
	init(rawBytes: [Byte]) throws
	
	/// Constructs a `MIDIEvent` instance from this event case.
	func asEvent() -> MIDIEvent
	
}
