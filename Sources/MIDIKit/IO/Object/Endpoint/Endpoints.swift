//
//  Endpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

public protocol MIDIIOEndpoints {
	
	/// List of MIDI output endpoints in the system
	var outputs: [MIDI.IO.OutputEndpoint] { get }
	
	/// List of MIDI input endpoints in the system
	var inputs: [MIDI.IO.InputEndpoint] { get }
	
	/// Manually update the locally cached contents from the system.
	/// This method does not need to be manually invoked, as it is handled internally when MIDI system endpoints change.
	mutating func update()
	
}

extension MIDI.IO {
	
	/// Manages system MIDI endpoints information cache.
	public class Endpoints: NSObject, MIDIIOEndpoints {
		
		public internal(set) dynamic var outputs: [OutputEndpoint] = []
		
		public internal(set) dynamic var inputs: [InputEndpoint] = []
		
		internal override init() {
			
			super.init()
			
		}
		
		public func update() {
			
			outputs = MIDI.IO.getSystemSourceEndpoints
			inputs = MIDI.IO.getSystemDestinationEndpoints
			
		}
		
	}
	
}
