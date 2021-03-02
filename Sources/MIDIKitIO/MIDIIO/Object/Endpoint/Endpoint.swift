//
//  Endpoint.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

import CoreMIDI

// MARK: - Endpoint

public protocol MIDIIOEndpoint: MIDIIO.Object, MIDIIO.ObjectRef {
	
}

extension MIDIIO {
	
	public typealias Endpoint = MIDIIOEndpoint
	
}

extension MIDIIO.Endpoint {
	
	/// List of entities within the device.
	public var entity: MIDIIO.Entity? {
		
		try? MIDIIO.getSystemEntity(for: ref)
		
	}
	
}
