//
//  Devices.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-27.
//

import Foundation

public protocol MIDIIODevices {
	
	/// List of MIDI devices in the system
	var devices: [MIDIIO.Device] { get }
	
	/// Manually update the locally cached contents from the system.
	/// This method does not need to be manually invoked, as it is handled internally when MIDI system endpoints change.
	func update()
	
}

extension MIDIIO {
	
	/// Manages system MIDI devices information cache.
	public class Devices: NSObject, MIDIIODevices {
		
		public internal(set) dynamic var devices: [Device] = []
		
		internal override init() {
			
			super.init()
			
		}
		
		/// Manually update the locally cached contents from the system.
		public func update() {
			
			devices = MIDIIO.getSystemDevices
			
		}
		
	}
	
}
