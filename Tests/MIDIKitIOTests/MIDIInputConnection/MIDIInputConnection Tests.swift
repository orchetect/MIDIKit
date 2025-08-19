//
//  MIDIInputConnection Tests.swift
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

@Suite(.serialized) struct MIDIInputConnection_Tests {
    private final actor Receiver {
        var events: [MIDIEvent] = []
        func add(events: [MIDIEvent]) { self.events.append(contentsOf: events) }
        func reset() { events.removeAll() }
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    }
    
    // called before each method
    init() async throws {
        try await Task.sleep(seconds: 0.2)
    }
    
    /// Test initializing an InputConnection, adding/removing outputs, and receiving MIDI events.
    @Test
    func inputConnection() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual output
        let output1Tag = "output1"
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(receiver.manager.managedOutputs[output1Tag])
        let output1ID = try #require(output1.uniqueID)
        let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        // add new connection, connecting to output1
        let connTag = UUID().uuidString
        try receiver.manager.addInputConnection(
            to: .outputs(matching: [.uniqueID(output1ID)]),
            tag: connTag,
            receiver: .events { [weak receiver] events, _, _ in
                Task {
                    // print(events)
                    await receiver?.add(events: events)
                }
            }
        )
        
        let conn = try #require(receiver.manager.managedInputConnections[connTag])
        try await wait(require: { conn.outputsCriteria == [.uniqueID(output1ID)] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputEndpointRefs == [output1Ref] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [output1.endpoint] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event - it should be received by the connection
        try output1.send(event: .start())
        try await wait(require: { await receiver.events == [.start()] }, timeout: isStable ? 2.0 : 10.0)
        await receiver.reset()
        
        // create a 2nd virtual output
        let output2Tag = UUID().uuidString
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output2Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output2 = try #require(receiver.manager.managedOutputs[output2Tag])
        let output2ID = try #require(output2.uniqueID)
        let output2Ref = try #require(output2.coreMIDIOutputPortRef)
        
        // connect to 2nd virtual output
        conn.add(outputs: [output2.endpoint])
        
        try await wait(require: { conn.outputsCriteria == [.uniqueID(output1ID), .uniqueID(output2ID)] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputEndpointRefs == [output1Ref, output2Ref] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { Set(conn.endpoints) == [output1.endpoint, output2.endpoint] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event from 1st - it should be received by the connection
        try output1.send(event: .stop())
        try await wait(require: { await receiver.events == [.stop()] }, timeout: isStable ? 1.0 : 2.0)
        await receiver.reset()
        
        // send an event from 2nd - it should be received by the connection
        try output2.send(event: .continue())
        try await wait(require: { await receiver.events == [.continue()] }, timeout: isStable ? 1.0 : 2.0)
        await receiver.reset()
        
        // remove 1st virtual output from connection
        conn.remove(outputs: [output1.endpoint])
        
        try await wait(require: { conn.outputsCriteria == [.uniqueID(output2ID)] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputEndpointRefs == [output2Ref] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [output2.endpoint] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event from 1st - it should not be received by the connection
        try output1.send(event: .songPositionPointer(midiBeat: 3))
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        try #require(await receiver.events == [])
        await receiver.reset()
        
        // send an event from 2nd - it should be received by the connection
        try output2.send(event: .songSelect(number: 2))
        try await wait(require: { await receiver.events == [.songSelect(number: 2)] }, timeout: isStable ? 1.0 : 2.0)
        await receiver.reset()
        
        // remove 2nd virtual output from connection
        conn.remove(outputs: [output2.endpoint])
        
        try await wait(require: { conn.outputsCriteria == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputEndpointRefs == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event from 2nd - it should not be received by the connection
        try output2.send(event: .songSelect(number: 8))
        try await Task.sleep(seconds: isStable ? 0.200 : 2.0) // wait a bit in case an event is sent
        #expect(await receiver.events == [])
    }
    
    /// Test to ensure a new output appearing in the system gets added to the connection. (Allowing manager-owned virtual outputs to be added)
    @Test
    func inputConnection_allEndpoints() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try receiver.manager.addInputConnection(
            to: .allOutputs,
            tag: connTag,
            filter: .init(owned: false, criteria: .currentOutputs()),
            receiver: .events { [weak receiver] events, _, _ in
                Task {
                    // print(events)
                    await receiver?.add(events: events)
                }
            }
        )
        
        let conn = try #require(receiver.manager.managedInputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.500 : 2.0) // some time for connection to setup
        
        #expect(conn.outputsCriteria == [])
        #expect(conn.coreMIDIOutputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // create a virtual output
        let output1Tag = UUID().uuidString
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(receiver.manager.managedOutputs[output1Tag])
        let output1ID = try #require(output1.uniqueID)
        let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await wait(require: { conn.outputsCriteria == [.uniqueID(output1ID)] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputEndpointRefs == [output1Ref] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [output1.endpoint] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event - it should be received by the connection
        try output1.send(event: .start())
        try await wait(require: { await receiver.events == [.start()] }, timeout: isStable ? 1.0 : 10.0)
    }
    
    /// Test to ensure creating a new manager-owned virtual output does not get added to the connection if `filter.owned == true`
    @Test
    func inputConnection_allEndpoints_filterOwned() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try receiver.manager.addInputConnection(
            to: .allOutputs,
            tag: connTag,
            filter: .init(owned: true, criteria: .currentOutputs()),
            receiver: .events { [weak receiver] events, _, _ in
                Task {
                    // print(events)
                    await receiver?.add(events: events)
                }
            }
        )
        
        let conn = try #require(receiver.manager.managedInputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        #expect(conn.outputsCriteria == [])
        #expect(conn.coreMIDIOutputEndpointRefs == [])
        #expect(conn.endpoints == [])
        
        // create a virtual output
        let output1Tag = UUID().uuidString
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(receiver.manager.managedOutputs[output1Tag])
        // let output1ID = try #require(output1.uniqueID)
        // let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await wait(require: { conn.outputsCriteria == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputEndpointRefs == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints == [] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event - it should not be received by the connection
        try output1.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.200 : 2.0) // wait a bit in case an event is sent
        #expect(await receiver.events == [])
    }
    
    /// Test to ensure virtual output(s) owned by the manager do not get added to the connection when creating the connection.
    @Test
    func inputConnection_filterOwned_onInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual output
        let output1Tag = UUID().uuidString
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(receiver.manager.managedOutputs[output1Tag])
        let output1ID = try #require(output1.uniqueID)
        let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try receiver.manager.addInputConnection(
            to: .allOutputs,
            tag: connTag,
            filter: .init(
                owned: true,
                criteria: receiver.manager.endpoints.outputsUnowned
            ),
            receiver: .events { [weak receiver] events, _, _ in
                Task {
                    // print(events)
                    await receiver?.add(events: events)
                }
            }
        )
        
        let conn = try #require(receiver.manager.managedInputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // attempt to add output1
        conn.add(outputs: [output1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert output1 was not added to the connection
        #expect(conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [])
        #expect(conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [])
        #expect(conn.endpoints.filter { $0 == output1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try output1.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        #expect(await receiver.events == [])
        await receiver.reset()
        
        // check that manually adding output1 is also not allowed
        conn.add(outputs: [output1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert output1 was not added to the connection
        #expect(conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [])
        #expect(conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [])
        #expect(conn.endpoints.filter { $0 == output1.endpoint } == [])
    }
    
    /// Test to ensure virtual output(s) owned by the manager
    /// are removed from the connection when updating mode and filter.
    @Test
    func inputConnection_filterOwned_afterInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual output
        let output1Tag = UUID().uuidString
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(receiver.manager.managedOutputs[output1Tag])
        let output1ID = try #require(output1.uniqueID)
        let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // add new connection, attempting to connect to output1
        let connTag = UUID().uuidString
        try receiver.manager.addInputConnection(
            to: .outputs([output1.endpoint]),
            tag: connTag,
            receiver: .events { [weak receiver] events, _, _ in
                Task {
                    // print(events)
                    await receiver?.add(events: events)
                }
            }
        )
        
        let conn = try #require(receiver.manager.managedInputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // set mode and filter
        conn.mode = .allOutputs
        conn.filter = .init(owned: true)
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to update
        
        // assert output1 is not present in connection targets
        #expect(conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [])
        #expect(conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [])
        #expect(conn.endpoints.filter { $0 == output1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try output1.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        #expect(await !receiver.events.contains(.start()))
        await receiver.reset()
        
        // check that manually adding output1 is also not allowed
        conn.add(outputs: [output1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert output1 was not added to the connection
        await wait(expect: { conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [] }, timeout: isStable ? 1.0 : 10.0)
        await wait(expect: { conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [] }, timeout: isStable ? 1.0 : 10.0)
        await wait(expect: { conn.endpoints.filter { $0 == output1.endpoint } == [] }, timeout: isStable ? 1.0 : 10.0)
    }
    
    /// Test to ensure filter works.
    @Test
    func inputConnection_filterEndpoints_onInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual output
        let output1Tag = UUID().uuidString
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(receiver.manager.managedOutputs[output1Tag])
        let output1ID = try #require(output1.uniqueID)
        let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // add new connection
        let connTag = UUID().uuidString
        try receiver.manager.addInputConnection(
            to: .allOutputs,
            tag: connTag,
            filter: .init(
                owned: false,
                criteria: [.uniqueID(output1ID)]
            ),
            receiver: .events { [weak receiver] events, _, _ in
                Task {
                    // print(events)
                    await receiver?.add(events: events)
                }
            }
        )
        
        let conn = try #require(receiver.manager.managedInputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // make sure output was not added upon connection creation
        #expect(conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [])
        #expect(conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [])
        #expect(conn.endpoints.filter { $0 == output1.endpoint } == [])
        
        // attempt to add output1
        conn.add(outputs: [output1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert output1 was not added to the connection
        #expect(conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [])
        #expect(conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [])
        #expect(conn.endpoints.filter { $0 == output1.endpoint } == [])
        
        // send an event - it should not be received by the connection
        try output1.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        #expect(await !receiver.events.contains(.start()))
        await receiver.reset()
        
        // check that manually adding output1 is also not allowed
        conn.add(outputs: [output1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // assert output1 was not added to the connection
        await wait(expect: { conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [] }, timeout: isStable ? 1.0 : 10.0)
        await wait(expect: { conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [] }, timeout: isStable ? 1.0 : 10.0)
        await wait(expect: { conn.endpoints.filter { $0 == output1.endpoint } == [] }, timeout: isStable ? 1.0 : 10.0)
    }
    
    /// Test to ensure filter works after creating a connection.
    @Test
    func inputConnection_filterEndpoints_afterInit() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create a virtual output
        let output1Tag = UUID().uuidString
        try receiver.manager.addOutput(
            name: UUID().uuidString,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(receiver.manager.managedOutputs[output1Tag])
        let output1ID = try #require(output1.uniqueID)
        let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // add new connection, attempting to connect to output1
        let connTag = UUID().uuidString
        try receiver.manager.addInputConnection(
            to: .outputs([output1.endpoint]),
            tag: connTag,
            receiver: .events { [weak receiver] events, _, _ in
                Task {
                    // print(events)
                    await receiver?.add(events: events)
                }
            }
        )
        
        let conn = try #require(receiver.manager.managedInputConnections[connTag])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to setup
        
        // set mode and filter
        conn.mode = .allOutputs
        conn.filter = .init(
            owned: false,
            criteria: [.uniqueID(output1ID)]
        )
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // some time for connection to update
        
        // assert output1 is not present in connection targets
        try await wait(require: { conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [] }, timeout: isStable ? 1.0 : 10.0)
        try await wait(require: { conn.endpoints.filter { $0 == output1.endpoint } == [] }, timeout: isStable ? 1.0 : 10.0)
        
        // send an event - it should not be received by the connection
        try output1.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // wait a bit in case an event is sent
        #expect(await !receiver.events.contains(.start()))
        await receiver.reset()
        
        // check that manually adding output1 is also not allowed
        conn.add(outputs: [output1.endpoint])
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        // assert output1 was not added to the connection
        await wait(expect: { conn.outputsCriteria.filter { $0 == .uniqueID(output1ID) } == [] }, timeout: isStable ? 1.0 : 10.0)
        await wait(expect: { conn.coreMIDIOutputEndpointRefs.filter { $0 == output1Ref } == [] }, timeout: isStable ? 1.0 : 10.0)
        await wait(expect: { conn.endpoints.filter { $0 == output1.endpoint } == [] }, timeout: isStable ? 1.0 : 10.0)
    }
}

#endif
