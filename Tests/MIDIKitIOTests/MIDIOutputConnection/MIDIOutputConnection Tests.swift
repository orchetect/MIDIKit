//
//  MIDIOutputConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitInternals
import MIDIKitIO
import Testing

@Suite(.serialized) struct MIDIOutputConnection_Tests {
    private final actor ManagerWrapper {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    }
    
    private final actor Receiver {
        var events: [MIDIEvent] = []
        func add(events: [MIDIEvent]) { self.events.append(contentsOf: events) }
        func reset() { events.removeAll() }
    }
    
    // called before each method
    init() async throws {
        try await Task.sleep(seconds: 0.2)
    }

    @Test
    func outputConnection() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver1 = Receiver()
        let receiver2 = Receiver()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual input
        let input1Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver1] events, _, _ in
                Task {
                    await receiver1?.add(events: events)
                }
            }
        )
        let input1 = try #require(mw.manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        #expect(input1ID != 0)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        // add new connection
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .inputs(matching: [.uniqueID(input1ID)]),
            tag: connTag
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        
        try await wait(require: { conn.inputsCriteria == [.uniqueID(input1ID)] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputPortRef != nil }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs == [input1Ref] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [input1.endpoint] }, timeout: isStable ? 1.0 : 10.0)
        
        // attempt to send a midi message
        try conn.send(event: .start())
        try await wait(require: { await receiver1.events == [.start()] }, timeout: isStable ? 1.0 : 10.0)
        await #expect(receiver2.events == [])
        await receiver1.reset()
        await receiver2.reset()
        
        // create a 2nd virtual input
        let input2Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input2Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver2] events, _, _ in
                Task {
                    await receiver2?.add(events: events)
                }
            }
        )
        let input2 = try #require(mw.manager.managedInputs[input2Tag])
        let input2ID = try #require(input2.uniqueID)
        let input2Ref = try #require(input2.coreMIDIInputPortRef)
        
        // add 2nd input to the connection
        conn.add(inputs: [.uniqueID(input2ID)])
        try await wait(require: { conn.inputsCriteria == [.uniqueID(input1ID), .uniqueID(input2ID)] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs == [input1Ref, input2Ref] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { Set(conn.endpoints) == [input1.endpoint, input2.endpoint] }, timeout: isStable ? 1.0 : 10.0)
        
        // attempt to send a midi message
        try conn.send(event: .stop())
        
        try await wait(require: { await receiver1.events == [.stop()] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { await receiver2.events == [.stop()] }, timeout: isStable ? 1.0 : 10.0)
        await receiver1.reset()
        await receiver2.reset()
        
        // remove 1st input from connection
        conn.remove(inputs: [.uniqueID(input1ID)])
        
        try await wait(require: { conn.inputsCriteria == [.uniqueID(input2ID)] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs == [input2Ref] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [input2.endpoint] }, timeout: isStable ? 1.0 : 10.0)
        
        // attempt to send a midi message
        try conn.send(event: .continue())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        try await wait(require: { await receiver2.events == [.continue()] }, timeout: isStable ? 1.0 : 10.0)
        await #expect(receiver1.events == [])
        await receiver1.reset()
        await receiver2.reset()
        
        // remove 2nd input from connection
        conn.remove(inputs: [.uniqueID(input2ID)])
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        try await wait(require: { conn.inputsCriteria == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [] }, timeout: isStable ? 1.0 : 10.0)
        
        // attempt to send a midi message
        try conn.send(event: .songSelect(number: 2))
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        await #expect(receiver1.events == [])
        await #expect(receiver2.events == [])
        await receiver1.reset()
        await receiver2.reset()
    }
    
    /// Test to ensure a new input appearing in the system gets added to the connection. (Allowing
    /// manager-owned virtual inputs to be added)
    @Test
    func outputConnection_allEndpoints() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver1 = Receiver()
        let receiver2 = Receiver()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(owned: false, criteria: .currentInputs())
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        #expect(conn.inputsCriteria == [])
        #expect(conn.coreMIDIInputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // create a virtual input
        let input1Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver1] events, _, _ in
                Task {
                    await receiver1?.add(events: events)
                }
            }
        )
        let input1 = try #require(mw.manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        // assert that input1 was automatically added to the connection
        try await wait(require: { conn.inputsCriteria == [.uniqueID(input1ID)] }, timeout: isStable ? 1.0 : 2.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs == [input1Ref] }, timeout: isStable ? 1.0 : 2.0)
        try await wait(require: { conn.endpoints == [input1.endpoint] }, timeout: isStable ? 1.0 : 2.0)
        
        // send an event - it should be received by the connection
        try conn.send(event: .start())
        try await wait(require: { await receiver1.events == [.start()] }, timeout: isStable ? 1.0 : 2.0)
        await #expect(receiver2.events == [])
        await receiver1.reset()
        await receiver2.reset()
    }
    
    /// Test to ensure creating a new manager-owned virtual input does not get added to the
    /// connection if `filter.owned == true`
    @Test
    func outputConnection_allEndpoints_filterOwned() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver1 = Receiver()
        let receiver2 = Receiver()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(owned: true, criteria: .currentInputs())
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        #expect(conn.inputsCriteria == [])
        #expect(conn.coreMIDIInputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // create a virtual input
        let input1Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver1] events, _, _ in
                Task {
                    await receiver1?.add(events: events)
                }
            }
        )
        let input1 = try #require(mw.manager.managedInputs[input1Tag]); _ = input1
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to be notified of new input
        
        // assert that input1 was not automatically added to the connection
        #expect(conn.inputsCriteria == [])
        #expect(conn.coreMIDIInputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        await #expect(receiver1.events == [])
        await #expect(receiver2.events == [])
        await receiver1.reset()
        await receiver2.reset()
    }
    
    /// Test to ensure virtual input(s) owned by the manager do not get added to the connection when
    /// creating the connection.
    @Test
    func outputConnection_filterOwned_onInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver1 = Receiver()
        let receiver2 = Receiver()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual input
        let input1Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver1] events, _, _ in
                Task {
                    await receiver1?.add(events: events)
                }
            }
        )
        let input1 = try #require(mw.manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(
                owned: true,
                criteria: mw.manager.endpoints.inputsUnowned
            )
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // attempt to add input1
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        await #expect(receiver1.events == [])
        await #expect(receiver2.events == [])
        await receiver1.reset()
        await receiver2.reset()
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
    
    /// Test to ensure virtual input(s) owned by the manager
    /// are removed from the connection when updating mode and filter.
    @Test
    func outputConnection_filterOwned_afterInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver1 = Receiver()
        let receiver2 = Receiver()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual input
        let input1Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver1] events, _, _ in
                Task {
                    await receiver1?.add(events: events)
                }
            }
        )
        let input1 = try #require(mw.manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // add new connection, attempting to connect to input1
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .inputs([input1.endpoint]),
            tag: connTag
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // set mode and filter
        conn.mode = .allInputs
        conn.filter = .init(
            owned: true,
            criteria: mw.manager.endpoints.inputsUnowned
        )
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to update
        
        // assert input1 is not present in connection targets
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        await #expect(receiver1.events == [])
        await #expect(receiver2.events == [])
        await receiver1.reset()
        await receiver2.reset()
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
    
    /// Test to ensure filter works.
    @Test
    func outputConnection_filterEndpoints_onInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver1 = Receiver()
        let receiver2 = Receiver()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual input
        let input1Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver1] events, _, _ in
                Task {
                    await receiver1?.add(events: events)
                }
            }
        )
        let input1 = try #require(mw.manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .allInputs,
            tag: connTag,
            filter: .init(
                owned: false,
                criteria: [.uniqueID(input1ID)]
            )
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // attempt to add input1
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        await #expect(!receiver1.events.contains(.start()))
        await #expect(!receiver2.events.contains(.start()))
        await receiver1.reset()
        await receiver2.reset()
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
    
    /// Test to ensure filter works after creating a connection.
    @Test
    func outputConnection_filterEndpoints_afterInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver1 = Receiver()
        let receiver2 = Receiver()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual input
        let input1Tag = UUID().uuidString
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc, // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver1] events, _, _ in
                Task {
                    await receiver1?.add(events: events)
                }
            }
        )
        let input1 = try #require(mw.manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // add new connection, attempting to connect to input1
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .inputs([input1.endpoint]),
            tag: connTag
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // double check that the input was connected
        try await wait(require: { conn.inputsCriteria.contains { $0 == .uniqueID(input1ID) } }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs.contains(input1Ref) }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints.contains(input1.endpoint) }, timeout: isStable ? 1.0 : 10.0)
        
        // set mode and filter
        conn.mode = .allInputs
        conn.filter = .init(
            owned: false,
            criteria: [.uniqueID(input1ID)]
        )
        
        // assert input1 was removed from the connection
        try await wait(require: { conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints.filter { $0 == input1.endpoint } == [] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event - it should not be received by the connection
        try conn.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        await #expect(!receiver1.events.contains(.start()))
        await #expect(!receiver2.events.contains(.start()))
        await receiver1.reset()
        await receiver2.reset()
        
        // check that manually adding input1 is also not allowed
        conn.add(inputs: [input1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert input1 was not added to the connection
        #expect(conn.inputsCriteria.filter { $0 == .uniqueID(input1ID) } == [])
        #expect(conn.coreMIDIInputEndpointRefs.filter { $0 == input1Ref } == [])
        #expect(conn.endpoints.filter { $0 == input1.endpoint } == [])
    }
}

#endif
