//
//  MIDIThruConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitInternals
@testable import MIDIKitIO
import Testing

@Suite(.serialized) struct MIDIThruConnection_Tests {
    @TestActor private final class Receiver {
        var events: [MIDIEvent] = []
        func add(events: [MIDIEvent]) { self.events.append(contentsOf: events) }
        func reset() { events.removeAll() }
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        nonisolated init() { }
    }
    
    private final actor ProxyWrapper {
        var proxy: MIDIThruConnectionProxy
        
        init(
            outputs: [MIDIOutputEndpoint],
            inputs: [MIDIInputEndpoint],
            midiManager: MIDIManager,
            api: CoreMIDIAPIVersion
        ) throws {
            proxy = try MIDIThruConnectionProxy(
                outputs: outputs,
                inputs: inputs,
                midiManager: midiManager,
                api: api
            )
        }
    }
    
    // called before each method
    init() async throws {
        try await Task.sleep(seconds: 0.2)
    }
    
    @Test
    func monPersistentThruConnection() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        defer {
            // as a failsafe, clean up any persistent connections with an empty owner ID.
            // this is to account for the possible re-emergence of the Core MIDI thru bug
            
            if let num = try? receiver.manager.unmanagedPersistentThruConnections(ownerID: "").count,
               num > 0
            {
                print("Removing \(num) empty-ownerID persistent thru connections.")
                receiver.manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
            }
        }
        
        // create virtual input
        let input1Tag = UUID().uuidString
        try receiver.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver] events, _, _ in
                Task { @TestActor in
                    receiver?.add(events: events)
                }
            }
        )
        let input1 = try #require(receiver.manager.managedInputs[input1Tag])
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
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
        
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // needs to be long enough or test fails
        
        // add new connection
        
        let connTag = UUID().uuidString
        try receiver.manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent
        )
        
        #expect(receiver.manager.managedThruConnections[connTag] != nil)
        #expect(receiver.manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        try await wait(require: { await receiver.events == [.start()] }, timeout: 5.0)
        await receiver.reset()
        
        receiver.manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        #expect(receiver.manager.managedThruConnections[connTag] == nil)
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 3.0) // wait a bit in case an event is sent
        #expect(await receiver.events == [])
        await receiver.reset()
        
        // Due to a Swift Core MIDI bug, all thru connections are created as persistent.
        // - See ThruConnection.swift for details
        let conns = try receiver.manager.unmanagedPersistentThruConnections(ownerID: "")
        
        #expect(conns.isEmpty)
    }
    
    @Test
    func persistentThruConnection() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // initial state
        let ownerID = "com.orchetect.midikit.testNonPersistentThruConnection"
        receiver.manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)
        
        // create virtual input
        let input1Tag = UUID().uuidString
        try receiver.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver] events, _, _ in
                Task { @TestActor in
                    receiver?.add(events: events)
                }
            }
        )
        let input1 = try #require(receiver.manager.managedInputs[input1Tag])
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
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
        
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // needs to be long enough or test fails
        
        // add new connection
        
        let connTag = UUID().uuidString
        func addThru() throws {
            try receiver.manager.addThruConnection(
                outputs: [output1.endpoint],
                inputs: [input1.endpoint],
                tag: connTag,
                lifecycle: .persistent(ownerID: ownerID)
            )
        }
        
        // continue test unless current platform can't support persistent thru connections
        if #available(macOS 13, iOS 16, *) {
            try addThru()
        } else if #available(macOS 11, iOS 14, *) {
            withKnownIssue("Can't test persistent thru connections on macOS 11 & 12 and iOS 14 & 15.") {
                try addThru() // will throw
            }
            return
        } else { // macOS 10.15.x and earlier, or iOS 13.x and earlier
            try addThru()
        }
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        #expect(try receiver.manager.unmanagedPersistentThruConnections(ownerID: ownerID).count == 1)
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        try await wait(require: { await receiver.events == [.start()] }, timeout: 1.0)
        await receiver.reset()
        
        receiver.manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)
        
        #expect(try receiver.manager.unmanagedPersistentThruConnections(ownerID: ownerID).isEmpty)
        
        #expect(receiver.manager.managedThruConnections.isEmpty)
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        try await Task.sleep(seconds: isStable ? 0.2 : 3.0) // wait a bit in case an event is sent
        #expect(await receiver.events == [])
    }
    
    /// Tests getting thru connection parameters from Core MIDI after creating the thru connection
    /// and verifying they are correct.
    @Test
    func getParams() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        defer {
            // as a failsafe, clean up any persistent connections with an empty owner ID.
            // this is to account for the possible re-emergence of the Core MIDI thru bug
            
            if let num = try? receiver.manager.unmanagedPersistentThruConnections(ownerID: "").count,
               num > 0
            {
                print("Removing \(num) empty-ownerID persistent thru connections.")
                receiver.manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
            }
        }
        
        // initial state
        await receiver.reset()
        
        // create virtual input
        let input1Tag = UUID().uuidString
        try receiver.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver] events, _, _ in
                Task { @TestActor in
                    receiver?.add(events: events)
                }
            }
        )
        let input1 = try #require(receiver.manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
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
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0) // 0.2 seems enough here
        
        // add new connection
        
        let connTag = UUID().uuidString
        try receiver.manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent
        )
        
        #expect(receiver.manager.managedThruConnections[connTag] != nil)
        #expect(receiver.manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        let connRef = receiver.manager.managedThruConnections[connTag]!.coreMIDIThruConnectionRef!
        let getParams = try #require(try getThruConnectionParameters(ref: connRef))
        
        #expect(getParams.numSources == 1)
        #expect(getParams.sources.0.endpointRef == output1Ref)
        #expect(getParams.sources.0.uniqueID == output1ID)
        #expect(getParams.numDestinations == 1)
        #expect(getParams.destinations.0.endpointRef == input1Ref)
        #expect(getParams.destinations.0.uniqueID == input1ID)
        
        receiver.manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        #expect(receiver.manager.managedThruConnections[connTag] == nil)
    }
    
    /// Test the thru connection proxy in isolation, so at least we can test its function in CI.
    /// `MIDIManager.addThruConnection` relies on platform to decide whether to use the proxy or
    /// not, and since affected macOS versions may not always be available to test on in a CI
    /// pipeline, this test allows testing of the proxy, albeit in isolation.
    @Test
    func proxy() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // create virtual input
        let input1Tag = UUID().uuidString
        try receiver.manager.addInput(
            name: UUID().uuidString,
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { [weak receiver] events, _, _ in
                Task { @TestActor in
                    receiver?.add(events: events)
                }
            }
        )
        let input1 = try #require(receiver.manager.managedInputs[input1Tag])
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
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
        
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0) // this needs to be long enough or test fails
        
        // create thru proxy (this internal only and is NOT added to the manager)
        
        var pw: ProxyWrapper? = try ProxyWrapper(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            midiManager: receiver.manager,
            api: receiver.manager.preferredAPI
        )
        _ = pw // silence warning
        
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        
        // send a test event until one is received.
        
        try await wait(
            require: {
                print("Sending test event")
                try output1.send(event: .start())
                try await Task.sleep(seconds: 0.5)
                return await receiver.events.contains(.start())
            },
            timeout: 5.0,
            pollingInterval: 0.0
        )
        
        pw = nil
        
        // allow potential additional events to arrive, give time for proxy deinit cleanup
        try await Task.sleep(seconds: isStable ? 0.2 : 2.0)
        await receiver.reset()
        
        // send an event - it should not be received by the input
        try output1.send(event: .stop())
        try await Task.sleep(seconds: isStable ? 0.2 : 3.0) // wait a bit in case an event is sent
        #expect(await receiver.events == [])
        await receiver.reset()
        
        // Due to a Swift Core MIDI bug, all thru connections are created as persistent.
        // - See ThruConnection.swift for details
        let conns = try receiver.manager.unmanagedPersistentThruConnections(ownerID: "")
        
        #expect(conns.isEmpty)
    }
}

#endif
