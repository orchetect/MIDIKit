//
//  MIDIKitTests.swift
//  MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import MIDIKitTestsCommon
import CoreMIDI

final class MIDIKitTests: XCTestCase {
	
    // no tests in this file, this is the root test class
	
	func testNamespace() {
		
		// this test is here to diagnose Package.swift dependency tree issues
		// as long as this test passes, then package configuration should be correct
		
//		_ = MIDIUInt7.self
//		_ = MIDIKitCommon.MIDIUInt7.self
//
//		_ = AnyMIDIEventKind.self
//		_ = MIDIKit.AnyMIDIEventKind.self
//
//		_ = MIDIIOManager.self
//		_ = MIDIKitIO.MIDIIOManager.self
//
//		_ = MIDIEvent.self
//		_ = MIDIKitEvents.MIDIEvent.self
//
//		_ = MTC.Receiver.self
//		_ = MIDIKitSync.MTC.Receiver.self
//
//		_ = kMIDIPacket.emptyBytes256Length
		
	}
	
}

#endif
