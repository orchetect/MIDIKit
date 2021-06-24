//
//  MIDIKitTests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import MIDIKitTestsCommon
import CoreMIDI

final class MIDIKitTests: XCTestCase {
	
	// no tests in this file, this is the module root test file
	
	func testNamespace() {
		
		// this test is here to diagnose Package.swift dependency tree issues
		// as long as this test passes, then package configuration should be correct
		
//		_ = MIDI.UInt7.self
//		_ = MIDIKitCommon.MIDI.UInt7.self
//
//		_ = AnyMIDIEventKind.self
//		_ = MIDIKit.AnyMIDIEventKind.self
//
//		_ = MIDI.IO.Manager.self
//		_ = MIDIKitIO.MIDI.IO.Manager.self
//
//		_ = MIDI.Event.self
//		_ = MIDIKitEvents.MIDI.Event.self
//
//		_ = MIDI.MTC.Receiver.self
//		_ = MIDIKitSync.MIDI.MTC.Receiver.self
//
//		_ = kMIDIPacket.emptyBytes256Length
		
	}
	
}

#endif
