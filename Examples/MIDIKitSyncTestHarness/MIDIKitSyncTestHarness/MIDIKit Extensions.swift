//
//  MIDIKit Extensions.swift
//  MIDIKitSyncTestHarness
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

import MIDIKit

extension MIDI.MTC.Encoder.FullFrameBehavior {
	
	public var nameForUI: String {
		
		switch self {
		case .always:
			return "Always"
		case .ifDifferent:
			return "If Different"
		case .never:
			return "Never"
		}
		
	}
	
}
