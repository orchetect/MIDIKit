//
//  Output Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
@testable import MIDIKit
import OTCoreTestingXCTest
import CoreMIDI

final class InputsAndOutputs_Output_Tests: XCTestCase {
	
	var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_Output_Tests",
						model: "",
						manufacturer: "")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testOutput() {
		
		// start midi client
		
		try! manager.start()
		
		XCTWait(sec: 0.1)
		
		// add new endpoint
		
		let tag1 = "1"
		
		var id1: MIDI.IO.Endpoint.UniqueID? = nil
		
		do {
			id1 = try manager.addOutput(name: "MIDIKit IO Tests Source 1", tag: tag1)
		} catch let err as MIDI.IO.MIDIError {
			XCTFail(err.localizedDescription) ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(id1)
		XCTAssertNotNil(manager.managedOutputs[tag1])
		
		// send a midi message
		
		XCTAssertNotNil(
			try? manager.managedOutputs[tag1]!.send(rawMessage: [0xFF])
		)
		
		// unique ID collision
		
		let tag2 = "2"
		
		var id2: MIDI.IO.Endpoint.UniqueID? = nil
		
		do {
			id2 = try manager.addOutput(name: "MIDIKit IO Tests Source 2", tag: tag2)
		} catch let err as MIDI.IO.MIDIError {
			XCTFail("\(err)") ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(id2)
		XCTAssertNotNil(manager.managedOutputs[tag2])
		
		// ensure ids are different
		XCTAssertNotEqual(id1, id2)
		
		// remove endpoints
		
		manager.remove(.output, .withTag(tag1))
		XCTAssertNil(manager.managedOutputs[tag1])
		
		manager.remove(.output, .withTag(tag2))
		XCTAssertNil(manager.managedOutputs[tag2])
		
	}

}

#endif
