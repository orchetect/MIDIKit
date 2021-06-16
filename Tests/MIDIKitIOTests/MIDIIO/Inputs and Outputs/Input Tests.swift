//
//  Input Tests.swift
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

final class MIDIIO_InputsAndOutputs_Input_Tests: XCTestCase {
	
	var manager: MIDIIO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKitIO_MIDIIO_InputsAndOutputs_Input_Tests",
						model: "",
						manufacturer: "")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testInput() {
		
		// start midi client
		
		try! manager.start()
		
		XCTWait(sec: 0.1)
		
		// add new endpoint
		
		let tag1 = "1"
		
		var id1: MIDIIO.Endpoint.UniqueID? = nil
		
		do {
			id1 = try manager.addInput(
				name: "MIDIKitIOTests Destination 1",
				tag: tag1,
				receiveHandler: .rawData({ packets in
					_ = packets
				})
			)
		} catch let err as MIDIIO.MIDIError {
			XCTFail(err.localizedDescription) ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(id1)
		XCTAssertNotNil(manager.managedInputs[tag1])
		
		// unique ID collision
		
		let tag2 = "2"
		
		var id2: MIDIIO.Endpoint.UniqueID? = nil
		
		do {
			id2 = try manager.addInput(
				name: "MIDIKitIOTests Destination 2",
				tag: tag2,
				uniqueID: id1!, // try to use existing ID
				receiveHandler: .rawData({ packet in
					_ = packet
				})
			)
		} catch let err as MIDIIO.MIDIError {
			XCTFail("\(err)") ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(id2)
		XCTAssertNotNil(manager.managedInputs[tag2])
		
		// ensure ids are different
		XCTAssertNotEqual(id1, id2)
		
		// remove endpoints
		
		manager.remove(.input, .withTag(tag1))
		XCTAssertNil(manager.managedInputs[tag1])
		
		manager.remove(.input, .withTag(tag2))
		XCTAssertNil(manager.managedInputs[tag2])
		
	}

}

#endif

