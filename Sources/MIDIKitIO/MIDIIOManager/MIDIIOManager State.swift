//
//  MIDIIOManager State.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI

extension MIDIIOManager {
	
	/// Starts the manager and registers itself with the CoreMIDI subsystem.
	/// Call this method once after initializing a new instance.
	public func setup() throws {
		
		let status = MIDIClientCreateWithBlock(clientName as CFString, &clientRef)
		{ [weak self] notificationPtr in
			guard let self = self else { return }
			_ = self
			#warning("> pass notification to handler")
		}
		
		if status != noErr {
			throw OSStatusResult(rawValue: status)
		}
		
	}
	
}
