//
//  ObjectType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

// MARK: - MIDI.IO.ObjectType

extension MIDI.IO {
	
	/// Enum defining a `MIDIIOObjectRefProtocol`'s MIDI object type.
	public enum ObjectType: CaseIterable, Hashable {
		
		case device
		case entity
		case endpoint
		
	}
	
}
