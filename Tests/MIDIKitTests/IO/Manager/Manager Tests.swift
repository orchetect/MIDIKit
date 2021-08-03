//
//  Manager Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import CoreMIDI

final class Manager_Tests: XCTestCase {
	
	var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_Manager_Tests",
						model: "",
						manufacturer: "")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testMIDIO_Manager_defaults() {
		
        // just check defaults without calling .start() on the manager
        
		XCTAssertEqual(manager.clientName, "MIDIKit_IO_Manager_Tests")
		XCTAssertEqual(manager.clientRef, MIDIClientRef())
		
		XCTAssert(manager.managedInputConnections.isEmpty)
		XCTAssert(manager.managedOutputConnections.isEmpty)
		XCTAssert(manager.managedInputs.isEmpty)
		XCTAssert(manager.managedOutputs.isEmpty)
		XCTAssert(manager.managedThruConnections.isEmpty)
		XCTAssert(try! manager
                    .unmanagedPersistentThruConnections(ownerID: Bundle.main.bundleIdentifier ?? "nil")
					.isEmpty)
		
	}
	
}

#endif
