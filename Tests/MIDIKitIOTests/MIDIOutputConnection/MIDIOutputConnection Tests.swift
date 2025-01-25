//
//  MIDIOutputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitInternals
import MIDIKitIO
import Testing

@Suite(.serialized) @MainActor class MIDIOutputConnection_Tests: Sendable {
    // called before each method
    init() async throws {
        try await Task.sleep(seconds: 0.200)
    }
    
    private var input1Events: [MIDIEvent] = []
    private var input2Events: [MIDIEvent] = []
}

// MARK: - Tests

extension MIDIOutputConnection_Tests {
    @Test
    func outputConnection() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .inputs(matching: [.uniqueID(input1ID)]),
            tag: connTag
        )
        
        let conn = try #require(manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: 0.500) // some time for connection to setup
        
        #expect(conn.inputsCriteria == [.uniqueID(input1ID)])
        #expect(conn.coreMIDIInputEndpointRefs == [input1Ref])
        #expect(conn.endpoints == [input1.endpoint])
        
        // attempt to send a midi message
        try conn.send(event: .start())
        try await Task.sleep(seconds: 0.200)
        #expect(input1Events == [.start()])
        #expect(input2Events == [])
        input1Events = []
        input2Events = []
        
        // create a 2nd virtual input
        let input2Tag = "input2"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 2",
            tag: input2Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input2Events.append(contentsOf: events)
                }
            }
        )
        let input2 = try #require(manager.managedInputs[input2Tag])
        let input2ID = try #require(input2.uniqueID)
        let input2Ref = try #require(input2.coreMIDIInputPortRef)
        
        // add 2nd input to the connection
        conn.add(inputs: [.uniqueID(input2ID)])
        try await Task.sleep(seconds: 0.300)
        #expect(conn.inputsCriteria == [.uniqueID(input1ID), .uniqueID(input2ID)])
        #expect(conn.coreMIDIInputEndpointRefs == [input1Ref, input2Ref])
        #expect(Set(conn.endpoints) == [input1.endpoint, input2.endpoint])
        
        // attempt to send a midi message
        try conn.send(event: .stop())
        try await Task.sleep(seconds: 0.200)
        #expect(input1Events == [.stop()])
        #expect(input2Events == [.stop()])
        input1Events = []
        input2Events = []
        
        // remove 1st input from connection
        conn.remove(inputs: [.uniqueID(input1ID)])
        try await Task.sleep(seconds: 0.300)
        #expect(conn.inputsCriteria == [.uniqueID(input2ID)])
        #expect(conn.coreMIDIInputEndpointRefs == [input2Ref])
        #expect(conn.endpoints == [input2.endpoint])
        
        // attempt to send a midi message
        try conn.send(event: .continue())
        try await Task.sleep(seconds: 0.200)
        #expect(input1Events == [])
        #expect(input2Events == [.continue()])
        input1Events = []
        input2Events = []
        
        // remove 2nd input from connection
        conn.remove(inputs: [.uniqueID(input2ID)])
        try await Task.sleep(seconds: 0.300)
        #expect(conn.inputsCriteria == [])
        #expect(conn.coreMIDIInputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // attempt to send a midi message
        try conn.send(event: .songSelect(number: 2))
        try await Task.sleep(seconds: 0.200)
        #expect(input1Events == [])
        #expect(input2Events == [])
        input1Events = []
        input2Events = []
    }
    
    /// Test to ensure a new input appearing in the system gets added to the connection. (Allowing
    /// manager-owned virtual inputs to be added)
    @Test
    func outputConnection_allEndpoints() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(owned: false, criteria: .currentInputs())
        )
        
        let conn = try #require(manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: 0.500) // some time for connection to setup
        
        #expect(conn.inputsCriteria == [])
        #expect(conn.coreMIDIInputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await wait(require: { conn.coreMIDIInputEndpointRefs == [input1Ref] }, timeout: 2.0) // TODO: fix TSAN issue
        
        // assert that input1 was automatically added to the connection
        #expect(conn.inputsCriteria == [.uniqueID(input1ID)])
        #expect(conn.coreMIDIInputEndpointRefs == [input1Ref])
        #expect(conn.endpoints == [input1.endpoint])
        
        // send an event - it should be received by the connection
        try conn.send(event: .start())
        try await wait(require: { await input1Events == [.start()] }, timeout: 1.0)
        #expect(input1Events == [.start()])
        #expect(input2Events == [])
        input1Events = []
        input2Events = []
    }
    
    /// Test to ensure creating a new manager-owned virtual input does not get added to the
    /// connection if `filter.owned == true`
    @Test
    func outputConnection_allEndpoints_filterOwned() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // add new connection
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(owned: true, criteria: .currentInputs())
        )
        
        let conn = try #require(manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: 0.500) // some time for connection to setup
        
        #expect(conn.inputsCriteria == [])
        #expect(conn.coreMIDIInputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag]); _ = input1
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: 0.500) // some time for connection to be notified of new input
        
        // assert that input1 was automatically added to the connection
        #expect(conn.inputsCriteria == [])
        #expect(conn.coreMIDIInputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(input1Events == [])
        #expect(input2Events == [])
        input1Events = []
        input2Events = []
    }
    
    /// Test to ensure virtual input(s) owned by the manager do not get added to the connection when
    /// creating the connection.
    @Test
    func outputConnection_filterOwned_onInit() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: 0.200)
        
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
        
        let conn = try #require(manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: 0.500) // some time for connection to setup
        
        // attempt to add input1
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: 0.500)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(input1Events == [])
        #expect(input2Events == [])
        input1Events = []
        input2Events = []
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
    
    /// Test to ensure virtual input(s) owned by the manager
    /// are removed from the connection when updating mode and filter.
    @Test
    func outputConnection_filterOwned_afterInit() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: 0.200)
        
        // add new connection, attempting to connect to input1
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .inputs([input1.endpoint]),
            tag: connTag
        )
        
        let conn = try #require(manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: 0.500) // some time for connection to setup
        
        // set mode and filter
        conn.mode = .allInputs
        conn.filter = .init(
            owned: true,
            criteria: manager.endpoints.inputsUnowned
        )
        try await Task.sleep(seconds: 0.500) // some time for connection to update
        
        // assert input1 is not present in connection targets
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(input1Events == [])
        #expect(input2Events == [])
        input1Events = []
        input2Events = []
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
    
    /// Test to ensure filter works.
    @Test
    func outputConnection_filterEndpoints_onInit() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: 0.200)
        
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
        
        let conn = try #require(manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: 0.500) // some time for connection to setup
        
        // attempt to add input1
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: 0.500)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(!input1Events.contains(.start()))
        #expect(!input2Events.contains(.start()))
        input1Events = []
        input2Events = []
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
    
    /// Test to ensure filter works after creating a connection.
    @Test
    func outputConnection_filterEndpoints_afterInit() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // create a virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests Input 1",
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak self] events, _, _ in
                Task { @MainActor in
                    self?.input1Events.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: 0.200)
        
        // add new connection, attempting to connect to input1
        let connTag = "testOutputConnection"
        try manager.addOutputConnection(
            to: .inputs([input1.endpoint]),
            tag: connTag
        )
        
        let conn = try #require(manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: 0.500) // some time for connection to setup
        
        // set mode and filter
        conn.mode = .allInputs
        conn.filter = .init(
            owned: false,
            criteria: [.uniqueID(input1ID)]
        )
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(!input1Events.contains(.start()))
        #expect(!input2Events.contains(.start()))
        input1Events = []
        input2Events = []
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
}

#endif
