//
//  OutputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
@testable import MIDIKit
import OTCoreTestingXCTest
import CoreMIDI

final class InputsAndOutputs_OutputConnection_Tests: XCTestCase {
	
	var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_OutputConnection_Tests",
						model: "",
						manufacturer: "")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testOutputConnection() {
		
		// start midi client
		
		try! manager.start()
		
		XCTWait(sec: 0.1)
		
		// add new connection
		
		let tag1 = "1"
		
		var caughtErr: Error? = nil
		
		do {
			try manager.addOutputConnection(
				toInput: .name(UUID().uuidString),
				tag: tag1
			)
		} catch let err as MIDI.IO.MIDIError {
			// log error - expect: endpoint not found
			caughtErr = err
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		if let caughtErr = caughtErr as? MIDI.IO.MIDIError,
		   case .connectionError = caughtErr {
			// correct - expect error to be present
		}
		else {
			XCTFail("Expected error thrown; no error was thrown.")
		}
		
		XCTAssertNotNil(manager.managedOutputConnections[tag1])
		
	}
	
}

#endif
