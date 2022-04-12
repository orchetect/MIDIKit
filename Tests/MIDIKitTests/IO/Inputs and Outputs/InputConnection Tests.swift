//
//  InputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import XCTestUtils
import MIDIKit
import CoreMIDI

final class InputsAndOutputs_InputConnection_Tests: XCTestCase {
	
    override func setUp() {
        wait(sec: 0.2)
    }
    
    @MIDI.Atomic var connEvents: [MIDI.Event] = []
    
    /// Test initializing an InputConnection, adding/removing outputs, and receiving MIDI events.
	func testInputConnection() throws {
		
        let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                      model: "MIDIKit123",
                                      manufacturer: "MIDIKit")
        
        // start midi client
        try manager.start()
		wait(sec: 0.1)
		
        connEvents = []
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
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
        wait(for: conn.coreMIDIOutputEndpointRefs, equals: [output1Ref], timeout: 1.0)
        
        XCTAssertEqual(conn.outputsCriteria, [.uniqueID(output1ID)])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [output1Ref])
        XCTAssertEqual(conn.endpoints, [output1.endpoint])
        
        // send an event - it should be received by the connection
        try output1.send(event: .start())
        wait(for: connEvents, equals: [.start()], timeout: 1.0)
        connEvents = []
        
        // create a 2nd virtual output
        let output2Tag = "output2"
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 2",
            tag: output2Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output2 = try XCTUnwrap(manager.managedOutputs[output2Tag])
        let output2ID = try XCTUnwrap(output2.uniqueID)
        let output2Ref = try XCTUnwrap(output2.coreMIDIOutputPortRef)
        
        // connect to 2nd virtual output
        conn.add(outputs: [output2.endpoint])
        wait(for: conn.coreMIDIOutputEndpointRefs, equals: [output1Ref, output2Ref], timeout: 1.0)
        XCTAssertEqual(conn.outputsCriteria, [.uniqueID(output1ID), .uniqueID(output2ID)])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [output1Ref, output2Ref])
        XCTAssertEqual(Set(conn.endpoints), [output1.endpoint, output2.endpoint])
        
        // send an event from 1st - it should be received by the connection
        try output1.send(event: .stop())
        wait(for: connEvents, equals: [.stop()], timeout: 0.5)
        connEvents = []
        
        // send an event from 2nd - it should be received by the connection
        try output2.send(event: .continue())
        wait(for: connEvents, equals: [.continue()], timeout: 0.5)
        connEvents = []
        
        // remove 1st virtual output from connection
        conn.remove(outputs: [output1.endpoint])
        wait(for: conn.coreMIDIOutputEndpointRefs, equals: [output2Ref], timeout: 1.0)
        XCTAssertEqual(conn.outputsCriteria, [.uniqueID(output2ID)])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [output2Ref])
        XCTAssertEqual(conn.endpoints, [output2.endpoint])
        
        // send an event from 1st - it should not be received by the connection
        try output1.send(event: .songPositionPointer(midiBeat: 3))
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
        // send an event from 2nd - it should be received by the connection
        try output2.send(event: .songSelect(number: 2))
        wait(for: connEvents, equals: [.songSelect(number: 2)], timeout: 0.5)
        connEvents = []
        
        // remove 2nd virtual output from connection
        conn.remove(outputs: [output2.endpoint])
        wait(for: conn.coreMIDIOutputEndpointRefs, equals: [], timeout: 1.0)
        XCTAssertEqual(conn.outputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
        
        // send an event from 2nd - it should not be received by the connection
        try output2.send(event: .songSelect(number: 8))
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
	}
    
    /// Test to ensure a new output appearing in the system gets added to the connection. (Allowing manager-owned virtual outputs to be added)
    func testInputConnection_automaticallyAddNewOutputs() throws {
        
        let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                      model: "MIDIKit123",
                                      manufacturer: "MIDIKit")
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        connEvents = []
        
        // add new connection
        let connTag = "testInputConnection"
        try manager.addInputConnection(
            toOutputs: [],
            tag: connTag,
            automaticallyAddNewOutputs: true,
            preventAddingManagedOutputs: false,
            receiveHandler: .events { events in
                print(events)
                self.connEvents.append(contentsOf: events)
            }
        )
        
        let conn = try XCTUnwrap(manager.managedInputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
        
        XCTAssertEqual(conn.outputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 1",
            tag: output1Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        let output1ID = try XCTUnwrap(output1.uniqueID)
        let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(for: conn.coreMIDIOutputEndpointRefs, equals: [output1Ref], timeout: 1.0)
        
        XCTAssertEqual(conn.outputsCriteria, [.uniqueID(output1ID)])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [output1Ref])
        XCTAssertEqual(conn.endpoints, [output1.endpoint])
        
        // send an event - it should be received by the connection
        try output1.send(event: .start())
        wait(for: connEvents, equals: [.start()], timeout: 0.5)
        connEvents = []
        
    }
    
    /// Test to ensure creating a new manager-owned virtual output does not get added to the connection if `preventAddingManagedOutputs == true`
    func testInputConnection_automaticallyAddNewOutputs_preventAddingManagedOutputs() throws {
        
        let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                      model: "MIDIKit123",
                                      manufacturer: "MIDIKit")
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        connEvents = []
        
        // add new connection
        let connTag = "testInputConnection"
        try manager.addInputConnection(
            toOutputs: [],
            tag: connTag,
            automaticallyAddNewOutputs: true,
            preventAddingManagedOutputs: true,
            receiveHandler: .events { events in
                print(events)
                self.connEvents.append(contentsOf: events)
            }
        )
        
        let conn = try XCTUnwrap(manager.managedInputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
        
        XCTAssertEqual(conn.outputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 1",
            tag: output1Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
//        let output1ID = try XCTUnwrap(output1.uniqueID)
//        let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.5) // some time for connection to be notified of new output
        
        XCTAssertEqual(conn.outputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
        
        // send an event - it should not be received by the connection
        try output1.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
    }
    
    /// Test to ensure virtual output(s) owned by the manager do not get added to the connection when creating the connection.
    func testInputConnection_preventAddingManagedOutputs_onInit() throws {
        
        let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                      model: "MIDIKit123",
                                      manufacturer: "MIDIKit")
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        connEvents = []
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 1",
            tag: output1Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
//        let output1ID = try XCTUnwrap(output1.uniqueID)
//        let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.2)
        
        // add new connection, attempting to connect to output1
        let connTag = "testInputConnection"
        try manager.addInputConnection(
            toOutputs: [output1.endpoint],
            tag: connTag,
            automaticallyAddNewOutputs: true,
            preventAddingManagedOutputs: true,
            receiveHandler: .events { events in
                print(events)
                self.connEvents.append(contentsOf: events)
            }
        )
        
        let conn = try XCTUnwrap(manager.managedInputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
        
        // assert output1 was not added to the connection
        XCTAssertEqual(conn.outputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
        
        // send an event - it should not be received by the connection
        try output1.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
        // check that manually adding output1 is also not allowed
        conn.add(outputs: [output1.endpoint])
        
        // assert output1 was not added to the connection
        XCTAssertEqual(conn.outputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIOutputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
        
    }

}

#endif
