//
//  Endpoints.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

import Foundation

public protocol MIDIIOEndpoints {
	
	/// List of MIDI output endpoints in the system
	var outputs: [MIDIIO.OutputEndpoint] { get }
	
	/// List of MIDI input endpoints in the system
	var inputs: [MIDIIO.InputEndpoint] { get }
	
	/// Manually update the locally cached contents from the system.
	/// This method does not need to be manually invoked, as it is handled internally when MIDI system endpoints change.
	mutating func update()
	
}

extension MIDIIO {
	
	/// Manages system MIDI endpoints information cache.
	public class Endpoints: NSObject, MIDIIOEndpoints {
		
		public internal(set) dynamic var outputs: [OutputEndpoint] = []
		
		public internal(set) dynamic var inputs: [InputEndpoint] = []
		
		internal override init() {
			
			super.init()
			
		}
		
		public func update() {
			
			outputs = MIDIIO.getSystemSourceEndpoints
			inputs = MIDIIO.getSystemDestinationEndpoints
			
		}
		
	}
	
}
