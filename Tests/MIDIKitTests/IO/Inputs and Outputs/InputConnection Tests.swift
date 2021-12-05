//
//  InputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
import MIDIKit
import CoreMIDI

final class InputsAndOutputs_InputConnection_Tests: XCTestCase {
	
	var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_InputConnection_Tests",
                        model: "MIDIKit123",
                        manufacturer: "MIDIKit")
	}
	
	override func tearDown() {
		manager = nil
        XCTWait(sec: 0.3)
	}
	
	func testInputConnection() throws {
		
		// start midi client
		
		try manager.start()
		
		XCTWait(sec: 0.1)
		
		// add new connection
		
		let tag1 = "1"
		
		do {
			try manager.addInputConnection(
				toOutputs: [.name(UUID().uuidString)],
				tag: tag1,
				receiveHandler: .rawDataLogging()
			)
		} catch let err as MIDI.IO.MIDIError {
            XCTFail(err.localizedDescription) ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(manager.managedInputConnections[tag1])
		
	}

}

#endif
