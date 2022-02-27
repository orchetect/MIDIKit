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
	
    @MIDI.Atomic var input1Events: [MIDI.Event] = []
    @MIDI.Atomic var input2Events: [MIDI.Event] = []
    
	func testOutputConnection() throws {
		
		// start midi client
		
		try manager.start()
		XCTWait(sec: 0.1)
		
        input1Events = []
        input2Events = []
        
        // create a virtual input
        let input1Tag = "input1"
        try self.manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .none, // allow system to generate random ID
            receiveHandler: .events { events in
                self.input1Events.append(contentsOf: events)
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
        
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            toInputs: [.uniqueID(input1ID)],
            tag: connTag
        )
		
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        XCTWait(sec: 0.5) // some time for connection to setup
        
        XCTAssertEqual(conn.inputsCriteria, [.uniqueID(input1ID)])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [input1Ref])
        XCTAssertEqual(conn.endpoints, [input1.endpoint])
        
        // attempt to send a midi message
        try conn.send(event: .start())
        XCTWait(sec: 0.2)
        XCTAssertEqual(input1Events, [.start()])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
        
        // create a 2nd virtual input
        let input2Tag = "input2"
        try self.manager.addInput(
            name: "MIDIKit IO Tests Input 2",
            tag: input2Tag,
            uniqueID: .none, // allow system to generate random ID
            receiveHandler: .events { events in
                self.input2Events.append(contentsOf: events)
            }
        )
        let input2 = try XCTUnwrap(manager.managedInputs[input2Tag])
        let input2ID = try XCTUnwrap(input2.uniqueID)
        let input2Ref = try XCTUnwrap(input2.coreMIDIInputPortRef)
        
        // add 2nd input to the connection
        conn.add(inputs: [.uniqueID(input2ID)])
        XCTWait(sec: 0.3)
        XCTAssertEqual(conn.inputsCriteria, [.uniqueID(input1ID), .uniqueID(input2ID)])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [input1Ref, input2Ref])
        XCTAssertEqual(Set(conn.endpoints), [input1.endpoint, input2.endpoint])
        
        // attempt to send a midi message
        try conn.send(event: .stop())
        XCTWait(sec: 0.2)
        XCTAssertEqual(input1Events, [.stop()])
        XCTAssertEqual(input2Events, [.stop()])
        input1Events = []
        input2Events = []
        
        // remove 1st input from connection
        conn.remove(inputs: [.uniqueID(input1ID)])
        XCTWait(sec: 0.3)
        XCTAssertEqual(conn.inputsCriteria, [.uniqueID(input2ID)])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [input2Ref])
        XCTAssertEqual(conn.endpoints, [input2.endpoint])
        
        // attempt to send a midi message
        try conn.send(event: .continue())
        XCTWait(sec: 0.2)
        XCTAssertEqual(input1Events, [])
        XCTAssertEqual(input2Events, [.continue()])
        input1Events = []
        input2Events = []
        
        // remove 2nd input from connection
        conn.remove(inputs: [.uniqueID(input2ID)])
        XCTWait(sec: 0.3)
        XCTAssertEqual(conn.inputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
        
        // attempt to send a midi message
        try conn.send(event: .songSelect(number: 2))
        XCTWait(sec: 0.2)
        XCTAssertEqual(input1Events, [])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
        
    }
	
}

#endif
