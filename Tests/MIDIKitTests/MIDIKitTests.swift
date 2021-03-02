//
//  MIDIKitTests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import MIDIKitTestsCommon
import CoreMIDI

final class MIDIKitTests: XCTestCase {
	
    // no tests in this file
	
	func testNamespace() {
		
		// this test is here to diagnose Package.swift dependency tree issues
		// as long as this test passes, then package configuration should be correct
		
//		_ = MIDIUInt7.self
//		_ = MIDIKitCommon.MIDIUInt7.self
//
//		_ = AnyMIDIEventKind.self
//		_ = MIDIKit.AnyMIDIEventKind.self
//
//		_ = MIDIIO.Manager.self
//		_ = MIDIKitIO.MIDIIO.Manager.self
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
