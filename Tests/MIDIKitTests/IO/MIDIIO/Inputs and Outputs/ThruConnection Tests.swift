//
//  ThruConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
@testable import MIDIKit
import OTCoreTestingXCTest
import MIDIKitTestsCommon
import CoreMIDI

final class InputsAndOutputs_ThruConnection_Tests: XCTestCase {
	
	var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_ThruConnection_Tests",
						model: "",
						manufacturer: "")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testThruConnection() {

		// start midi client

		try! manager.start()

		XCTWait(sec: 0.1)

		// add new connection

		let tag1 = "1"

		do {
			try manager.addThruConnection(
				outputs: [],
				inputs: [],
				tag: tag1,
				.nonPersistent,
				params: nil
			)
		} catch let err as MIDI.IO.MIDIError {
			XCTFail("\(err)") ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}

		XCTAssertNotNil(manager.managedThruConnections[tag1])
		
	}

}

#endif

