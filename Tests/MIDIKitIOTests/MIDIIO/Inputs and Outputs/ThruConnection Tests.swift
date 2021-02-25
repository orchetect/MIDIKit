//
//  ThruConnection Tests.swift
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

final class MIDIKitIO_MIDIIO_SourcesAndDestinations_ThruConnection_Tests: XCTestCase {
	
	var manager: MIDIIO.Manager! = nil
	
	override func setUp() {
		manager = .init(name: "MIDIKitIO_MIDIIO_SourcesAndDestinations_ThruConnection_Tests")
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
			try manager.addThru(
				sources: [],
				destinations: [],
				tag: tag1,
				.nonPersistent,
				params: nil
			)
		} catch let err as MIDIIO.OSStatusResult {
			XCTFail("\(err)") ; return
		} catch let err as MIDIIO.GeneralError {
			XCTFail("\(err)") ; return
		} catch {
			XCTFail(error.localizedDescription) ; return
		}
		
		XCTAssertNotNil(manager.managedThruConnections[tag1])
		
	}

}

#endif

