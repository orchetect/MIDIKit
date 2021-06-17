//
//  InputConnection Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
import OTCoreTestingXCTest
@testable import MIDIKitIO
import MIDIKitTestsCommon
import CoreMIDI

final class MIDIIO_InputsAndOutputs_InputConnection_Tests: XCTestCase {
	
	var manager: MIDIIO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKitIO_MIDIIO_InputsAndOutputs_InputConnection_Tests",
						model: "",
						manufacturer: "")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testInputConnection() {
		
		// start midi client
		
		try! manager.start()
		
		XCTWait(sec: 0.1)
		
		// add new connection
		
		let tag1 = "1"
		
		var caughtErr: Error? = nil
		
		do {
			try manager.addInputConnection(
				toOutput: .name(UUID().uuidString),
				tag: tag1,
				receiveHandler: .rawDataLogging()
			)
		} catch let err as MIDIIO.MIDIError {
			// log error - expect: endpoint not found
			caughtErr = err
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		if let caughtErr = caughtErr as? MIDIIO.MIDIError,
		   case .connectionError = caughtErr {
			// correct - expect error to be present
		}
		else {
			XCTFail("Expected error thrown; no error was thrown.")
		}
		
		XCTAssertNotNil(manager.managedInputConnections[tag1])
		
	}

}

#endif
