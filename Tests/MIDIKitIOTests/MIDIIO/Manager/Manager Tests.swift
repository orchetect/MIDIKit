//
//  Manager Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
import OTCore
import OTCoreTestingXCTest
@testable import MIDIKitIO
import MIDIKitTestsCommon
import CoreMIDI

final class Manager_Tests: XCTestCase {
	
	var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKitIO_Manager_Tests",
						model: "",
						manufacturer: "")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testMIDIO_Manager_defaults() {
		
		XCTAssertEqual(manager.clientName, "MIDIKitIO_Manager_Tests")
		XCTAssertEqual(manager.clientRef, MIDIClientRef())
		
		XCTAssert(manager.managedInputConnections.isEmpty)
		XCTAssert(manager.managedOutputConnections.isEmpty)
		XCTAssert(manager.managedInputs.isEmpty)
		XCTAssert(manager.managedOutputs.isEmpty)
		XCTAssert(manager.managedThruConnections.isEmpty)
		XCTAssert(try! manager
					.unmanagedPersistentThrus(ownerID: Globals.bundle.bundleID)
					.isEmpty)
		
	}
	
}

#endif
