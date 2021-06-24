//
//  Endpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - Endpoint

public protocol MIDIIOEndpointProtocol: MIDI.IO.Object, MIDI.IO.ObjectRef {
	
	// nothing here; just conformances
	
}

extension MIDI.IO {
	
	public typealias Endpoint = MIDIIOEndpointProtocol
	
}

extension MIDI.IO.Endpoint {
	
	/// List of entities within the device.
	public var entity: MIDI.IO.Entity? {
		
		try? MIDI.IO.getSystemEntity(for: ref)
		
	}
	
}
