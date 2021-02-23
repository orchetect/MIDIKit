//
//  Manager Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

#if !os(watchOS)

import XCTest
import OTCoreTestingXCTest
@testable import MIDIKitIO
import MIDIKitTestsCommon
import CoreMIDI

final class MIDIKitIO_MIDIIO_Manager_Tests: XCTestCase {
	
	var manager: MIDIIO.Manager! = nil
	
	override func setUp() {
		print("🔌 Manager instanced.")
		manager = .init(name: "MIDIKitIOTests")
	}
	
	func testMIDIO_Manager_defaults() {
		
		XCTAssertEqual(manager.clientName, "MIDIKitIOTests")
		XCTAssert(!manager.persistentDomain.isEmpty)
		XCTAssertEqual(manager.clientRef, MIDIClientRef())
		
		XCTAssert(manager.connectedDestinations.isEmpty)
		XCTAssert(manager.connectedSources.isEmpty)
		XCTAssert(manager.virtualDestinations.isEmpty)
		XCTAssert(manager.virtualSources.isEmpty)
		XCTAssert(manager.connectedThrusNonPersistent.isEmpty)
		XCTAssert(manager.connectedThrusPersistent.isEmpty)
		
	}
	
	func testMIDIO_Manager_VirtualSource() {
		
		// start midi client
		
		try! manager.start()
		
		XCTWait(sec: 0.1)
		
		let tag = "1"
		
		var id: MIDIEndpointUniqueID? = nil
		
		// add new endpoint
		
		do {
			id = try manager.addVirtualSource(name: "MIDIKitIOTests Source 1", tag: tag)
		} catch let err as MIDIIO.OSStatusResult {
			XCTFail(err.description) ; return
		} catch let err as MIDIIO.GeneralError {
			XCTFail(err.localizedDescription) ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(id)
		
		XCTAssertNotNil(manager.virtualSources[tag])
		
		// sent a midi message
		
		XCTAssertNotNil(
			try? manager.virtualSources[tag]!.send(rawMessage: [0xFF])
		)
		
		// remove endpoint
		
		manager.removeVirtualSource(tag: tag)
		
		XCTAssertNil(manager.virtualSources[tag])
		
	}
	
	func testMIDIO_Manager_VirtualDestination() {
		
		// start midi client
		
		try! manager.start()
		
		XCTWait(sec: 0.1)
		
		let tag = "1"
		
		var id: MIDIEndpointUniqueID? = nil
		
		// add new endpoint
		
		do {
			id = try manager.addVirtualDestination(name: "MIDIKitIOTests Destination 1", tag: tag)
			{ _,_ in
				// empty receiver
			}
		} catch let err as MIDIIO.OSStatusResult {
			XCTFail(err.description) ; return
		} catch let err as MIDIIO.GeneralError {
			XCTFail(err.localizedDescription) ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(id)
		
		XCTAssertNotNil(manager.virtualDestinations[tag])
		
		// remove endpoint
		
		manager.removeVirtualDestination(tag: tag)
		
		XCTAssertNil(manager.virtualDestinations[tag])
		
	}
	
}

#endif
