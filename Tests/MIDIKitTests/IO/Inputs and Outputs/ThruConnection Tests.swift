//
//  ThruConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import MIDIKit
import CoreMIDI

final class InputsAndOutputs_ThruConnection_Tests: XCTestCase {
	
    fileprivate var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_ThruConnection_Tests",
                        model: "MIDIKit123",
                        manufacturer: "MIDIKit")
	}
	
	override func tearDown() {
		manager = nil
        XCTWait(sec: 0.3)
	}
	
	func testThruConnection() throws {

		// start midi client

		try manager.start()

		XCTWait(sec: 0.1)

		// add new connection

		let tag1 = "1"

		do {
			try manager.addThruConnection(
				outputs: [],
				inputs: [],
				tag: tag1,
                lifecycle: .nonPersistent,
                params: .init()
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

