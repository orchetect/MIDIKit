//
//  Manager Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

#if !os(watchOS)

import XCTest
import OTCore
import OTCoreTestingXCTest
@testable import MIDIKitIO
import MIDIKitTestsCommon
import CoreMIDI

final class MIDIKitIO_MIDIIO_Manager_Tests: XCTestCase {
	
	var manager: MIDIIO.Manager! = nil
	
	override func setUp() {
		manager = .init(name: "MIDIKitIO_MIDIIO_Manager_Tests")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testMIDIO_Manager_defaults() {
		
		XCTAssertEqual(manager.clientName, "MIDIKitIO_MIDIIO_Manager_Tests")
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
