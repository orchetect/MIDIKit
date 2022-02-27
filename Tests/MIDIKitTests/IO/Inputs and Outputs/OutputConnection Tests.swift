//
//  OutputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import MIDIKit
import CoreMIDI

final class InputsAndOutputs_OutputConnection_Tests: XCTestCase {
	
    fileprivate var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_OutputConnection_Tests",
                        model: "MIDIKit123",
                        manufacturer: "MIDIKit")
	}
	
	override func tearDown() {
		manager = nil
        XCTWait(sec: 0.3)
	}
	
	func testOutputConnection() throws {
		
		// start midi client
		
		try manager.start()
		
		XCTWait(sec: 0.1)
		
		// add new connection
		
		let tag1 = "1"
		
		do {
			try manager.addOutputConnection(
				toInputs: [.name(UUID().uuidString)],
				tag: tag1
			)
		} catch let err as MIDI.IO.MIDIError {
            XCTFail(err.localizedDescription) ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(manager.managedOutputConnections[tag1])
        
        // attempt to send a midi message
        
        XCTAssertNoThrow(
            try manager.managedOutputConnections[tag1]?
                .send(event: .systemReset(group: 0))
        )
        XCTAssertNoThrow(
            try manager.managedOutputConnections[tag1]?
                .send(events: [.systemReset(group: 0)])
        )
        
	}
	
}

#endif
