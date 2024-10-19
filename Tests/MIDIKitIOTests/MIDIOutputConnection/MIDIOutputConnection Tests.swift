//
//  MIDIOutputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitInternals
import MIDIKitIO
import XCTest
import XCTestUtils

final class MIDIOutputConnection_Tests: XCTestCase {
    // called before each method
    override func setUpWithError() throws {
        wait(sec: 0.2)
        input1Events = []
        input2Events = []
    }
    
    private var input1Events: [MIDIEvent] = []
    private var input2Events: [MIDIEvent] = []
    
    func testOutputConnection() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
		
        input1Events = []
        input2Events = []
    
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
    
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .inputs(matching: [.uniqueID(input1ID)]),
            tag: connTag
        )
		
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
    
        XCTAssertEqual(conn.inputsCriteria, [.uniqueID(input1ID)])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [input1Ref])
        XCTAssertEqual(conn.endpoints, [input1.endpoint])
    
        // attempt to send a midi message
        try conn.send(event: .start())
        wait(sec: 0.2)
        XCTAssertEqual(input1Events, [.start()])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
    
        // create a 2nd virtual input
        let input2Tag = "input2"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 2",
            tag: input2Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input2Events.append(contentsOf: events)
                }
            }
        )
        let input2 = try XCTUnwrap(manager.managedInputs[input2Tag])
        let input2ID = try XCTUnwrap(input2.uniqueID)
        let input2Ref = try XCTUnwrap(input2.coreMIDIInputPortRef)
    
        // add 2nd input to the connection
        conn.add(inputs: [.uniqueID(input2ID)])
        wait(sec: 0.3)
        XCTAssertEqual(conn.inputsCriteria, [.uniqueID(input1ID), .uniqueID(input2ID)])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [input1Ref, input2Ref])
        XCTAssertEqual(Set(conn.endpoints), [input1.endpoint, input2.endpoint])
    
        // attempt to send a midi message
        try conn.send(event: .stop())
        wait(sec: 0.2)
        XCTAssertEqual(input1Events, [.stop()])
        XCTAssertEqual(input2Events, [.stop()])
        input1Events = []
        input2Events = []
    
        // remove 1st input from connection
        conn.remove(inputs: [.uniqueID(input1ID)])
        wait(sec: 0.3)
        XCTAssertEqual(conn.inputsCriteria, [.uniqueID(input2ID)])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [input2Ref])
        XCTAssertEqual(conn.endpoints, [input2.endpoint])
    
        // attempt to send a midi message
        try conn.send(event: .continue())
        wait(sec: 0.2)
        XCTAssertEqual(input1Events, [])
        XCTAssertEqual(input2Events, [.continue()])
        input1Events = []
        input2Events = []
    
        // remove 2nd input from connection
        conn.remove(inputs: [.uniqueID(input2ID)])
        wait(sec: 0.3)
        XCTAssertEqual(conn.inputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
    
        // attempt to send a midi message
        try conn.send(event: .songSelect(number: 2))
        wait(sec: 0.2)
        XCTAssertEqual(input1Events, [])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
    }
    
    /// Test to ensure a new input appearing in the system gets added to the connection. (Allowing
    /// manager-owned virtual inputs to be added)
    func testOutputConnection_allEndpoints() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
    
        input1Events = []
        input2Events = []
    
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(owned: false, criteria: .currentInputs())
        )
    
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
    
        XCTAssertEqual(conn.inputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
    
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
    
        wait(for: conn.coreMIDIInputEndpointRefs, equals: [input1Ref], timeout: 1.0)
    
        // assert that input1 was automatically added to the connection
        XCTAssertEqual(conn.inputsCriteria, [.uniqueID(input1ID)])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [input1Ref])
        XCTAssertEqual(conn.endpoints, [input1.endpoint])
    
        // send an event - it should be received by the connection
        try conn.send(event: .start())
        wait(for: input1Events, equals: [.start()], timeout: 0.5)
        XCTAssertEqual(input1Events, [.start()])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
    }
    
    /// Test to ensure creating a new manager-owned virtual input does not get added to the
    /// connection if `filter.owned == true`
    func testOutputConnection_allEndpoints_filterOwned() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
    
        input1Events = []
        input2Events = []
    
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(owned: true, criteria: .currentInputs())
        )
    
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
    
        XCTAssertEqual(conn.inputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
    
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag]); _ = input1
//        let input1ID = try XCTUnwrap(input1.uniqueID)
//        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
    
        wait(sec: 0.5) // some time for connection to be notified of new input
    
        // assert that input1 was automatically added to the connection
        XCTAssertEqual(conn.inputsCriteria, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs, [])
        XCTAssertEqual(conn.endpoints, [])
    
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(input1Events, [])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
    }
	
    /// Test to ensure virtual input(s) owned by the manager do not get added to the connection when
    /// creating the connection.
    func testOutputConnection_filterOwned_onInit() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
    
        input1Events = []
        input2Events = []
    
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
    
        wait(sec: 0.2)
    
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(
                owned: true,
                criteria: manager.endpoints.inputsUnowned
            )
        )
        
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
    
        // attempt to add input1
        conn.add(inputs: [input1.endpoint])
        wait(sec: 0.5)
        
        // assert input1 was not added to the connection
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(input1Events, [])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
    
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
    
        // assert input1 was not added to the connection
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    }
    
    /// Test to ensure virtual input(s) owned by the manager
    /// are removed from the connection when updating mode and filter.
    func testOutputConnection_filterOwned_afterInit() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
    
        input1Events = []
        input2Events = []
    
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
    
        wait(sec: 0.2)
    
        // add new connection, attempting to connect to input1
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .inputs([input1.endpoint]),
            tag: connTag
        )
    
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
    
        // set mode and filter
        conn.mode = .allInputs
        conn.filter = .init(
            owned: true,
            criteria: manager.endpoints.inputsUnowned
        )
        wait(sec: 0.5) // some time for connection to update
    
        // assert input1 is not present in connection targets
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(input1Events, [])
        XCTAssertEqual(input2Events, [])
        input1Events = []
        input2Events = []
    
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
    
        // assert input1 was not added to the connection
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    }
    
    /// Test to ensure filter works.
    func testOutputConnection_filterEndpoints_onInit() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
    
        input1Events = []
        input2Events = []
    
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
    
        wait(sec: 0.2)
    
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(
                owned: false,
                criteria: [.uniqueID(input1ID)]
            )
        )
    
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
        
        // attempt to add input1
        conn.add(inputs: [input1.endpoint])
        wait(sec: 0.5)
        
        // assert input1 was not added to the connection
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssert(!input1Events.contains(.start()))
        XCTAssert(!input2Events.contains(.start()))
        input1Events = []
        input2Events = []
    
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
    
        // assert input1 was not added to the connection
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    }
    
    /// Test to ensure filter works after creating a connection.
    func testOutputConnection_filterEndpoints_afterInit() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
    
        input1Events = []
        input2Events = []
    
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                DispatchQueue.main.async {
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
    
        wait(sec: 0.2)
    
        // add new connection, attempting to connect to input1
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .inputs([input1.endpoint]),
            tag: connTag
        )
    
        let conn = try XCTUnwrap(manager.managedOutputConnections[connTag])
        wait(sec: 0.5) // some time for connection to setup
    
        // set mode and filter
        conn.mode = .allInputs
        conn.filter = .init(
            owned: false,
            criteria: [.uniqueID(input1ID)]
        )
    
        // assert input1 was not added to the connection
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssert(!input1Events.contains(.start()))
        XCTAssert(!input2Events.contains(.start()))
        input1Events = []
        input2Events = []
    
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
    
        // assert input1 was not added to the connection
        XCTAssertEqual(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) }, [])
        XCTAssertEqual(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref }, [])
        XCTAssertEqual(conn.endpoints.filter { $0 == input1.endpoint }, [])
    }
}

#endif
