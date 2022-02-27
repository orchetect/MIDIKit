//
//  InputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import MIDIKit
import CoreMIDI

final class InputsAndOutputs_InputConnection_Tests: XCTestCase {
	
    fileprivate var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_InputsAndOutputs_InputConnection_Tests",
                        model: "MIDIKit123",
                        manufacturer: "MIDIKit")
	}
	
	override func tearDown() {
		manager = nil
        XCTWait(sec: 0.3)
	}
	
    @MIDI.Atomic var connEvents: [MIDI.Event] = []
    
	func testInputConnection() throws {
		
		// start midi client
		try manager.start()
		XCTWait(sec: 0.1)
		
        connEvents = []
        
        // create a virtual output
        let output1Tag = "output1"
        try self.manager.addOutput(
            name: "MIDIKit IO Tests Source 1",
            tag: output1Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        let output1ID = try XCTUnwrap(output1.uniqueID)
        let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        // add new connection, connecting to output1
        let connTag = "testInputConnection"
        try manager.addInputConnection(
            toOutputs: [.uniqueID(output1ID)],
            tag: connTag,
            receiveHandler: .events { events in
                print(events)
                self.connEvents.append(contentsOf: events)
            }
        )
        
        let conn = try XCTUnwrap(manager.managedInputConnections[connTag])
        XCTWait(sec: 0.5) // some time for connection to setup
        
        XCTAssertEqual(conn.outputsCriteria, [.uniqueID(output1ID)])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [output1Ref])
        
        // send an event - it should be received by the connection
        try output1.send(event: .start())
        XCTWait(sec: 0.2)
        XCTAssertEqual(connEvents, [.start()])
        connEvents = []
        
        // create a 2nd virtual output
        let output2Tag = "output2"
        try self.manager.addOutput(
            name: "MIDIKit IO Tests Source 2",
            tag: output2Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output2 = try XCTUnwrap(manager.managedOutputs[output2Tag])
        let output2ID = try XCTUnwrap(output2.uniqueID)
        let output2Ref = try XCTUnwrap(output2.coreMIDIOutputPortRef)
        
        // connect to 2nd virtual output
        conn.add(outputs: [.uniqueID(output2ID)])
        XCTWait(sec: 0.5) // some time for endpoint to be added to the connection
        XCTAssertEqual(conn.outputsCriteria, [.uniqueID(output1ID), .uniqueID(output2ID)])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [output1Ref, output2Ref])
        
        // send an event from 1st - it should be received by the connection
        try output1.send(event: .stop())
        XCTWait(sec: 0.2)
        XCTAssertEqual(connEvents, [.stop()])
        connEvents = []
        
        // send an event from 2nd - it should be received by the connection
        try output2.send(event: .continue())
        XCTWait(sec: 0.2)
        XCTAssertEqual(connEvents, [.continue()])
        connEvents = []
        
        // remove 1st virtual output from connection
        conn.remove(outputs: [.uniqueID(output1ID)])
        XCTWait(sec: 0.5) // some time for endpoint to be removed from the connection
        XCTAssertEqual(conn.outputsCriteria, [.uniqueID(output2ID)])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [output2Ref])
        
        // send an event from 1st - it should not be received by the connection
        try output1.send(event: .songPositionPointer(midiBeat: 3))
        XCTWait(sec: 0.2)
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
        // send an event from 2nd - it should be received by the connection
        try output2.send(event: .songSelect(number: 2))
        XCTWait(sec: 0.2)
        XCTAssertEqual(connEvents, [.songSelect(number: 2)])
        connEvents = []
        
        // remove 2nd virtual output from connection
        conn.remove(outputs: [.uniqueID(output2ID)])
        XCTWait(sec: 0.5) // some time for endpoint to be removed from the connection
        XCTAssertEqual(conn.outputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [])
        
        // send an event from 2nd - it should not be received by the connection
        try output2.send(event: .songSelect(number: 8))
        XCTWait(sec: 0.2)
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
	}

}

#endif
