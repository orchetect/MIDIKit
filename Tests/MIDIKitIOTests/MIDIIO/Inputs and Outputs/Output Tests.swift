//
//  Output Tests.swift
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

final class MIDIIO_InputsAndOutputs_Output_Tests: XCTestCase {
	
	var manager: MIDIIO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKitIO_MIDIIO_InputsAndOutputs_Output_Tests",
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
		
		var id1: MIDIIO.Endpoint.UniqueID? = nil
		
		do {
			id1 = try manager.addOutput(name: "MIDIKitIOTests Source 1", tag: tag1)
		} catch let err as MIDIIO.MIDIError {
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
		
		var id2: MIDIIO.Endpoint.UniqueID? = nil
		
		do {
			id2 = try manager.addOutput(name: "MIDIKitIOTests Source 2", tag: tag2)
		} catch let err as MIDIIO.MIDIError {
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
