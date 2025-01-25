//
//  MIDIThruConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitInternals
@testable import MIDIKitIO
import Testing

@Suite(.serialized) @MainActor class MIDIThruConnection_Tests: Sendable {
    // called before each method
    init() async throws {
        try await Task.sleep(seconds: 0.200)
    }
    
    private var connEvents: [MIDIEvent] = []
}

// MARK: - Tests

extension MIDIThruConnection_Tests {
    @Test
    func monPersistentThruConnection() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        defer {
            // as a failsafe, clean up any persistent connections with an empty owner ID.
            // this is to account for the possible re-emergence of the Core MIDI thru bug
            
            if let num = try? manager.unmanagedPersistentThruConnections(ownerID: "").count,
               num > 0
            {
                print("Removing \(num) empty-ownerID persistent thru connections.")
            }
            
            manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
        }
        
        // initial state
        connEvents.removeAll()
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { events, _, _ in
                Task { @MainActor in
                    self.connEvents.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(manager.managedOutputs[output1Tag])
        // let output1ID = try #require(output1.uniqueID)
        // let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: 0.500) // needs to be long enough or test fails
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent
        )
        
        #expect(manager.managedThruConnections[connTag] != nil)
        #expect(manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        try await Task.sleep(seconds: 0.200)
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        try await wait(require: { await connEvents == [.start()] }, timeout: 1.0)
        connEvents = []
        
        manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        #expect(manager.managedThruConnections[connTag] == nil)
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(connEvents == [])
        connEvents = []
        
        // Due to a Swift Core MIDI bug, all thru connections are created as persistent.
        // - See ThruConnection.swift for details
        let conns = try manager.unmanagedPersistentThruConnections(ownerID: "")
        
        #expect(conns.isEmpty)
    }
    
    @Test
    func persistentThruConnection() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // initial state
        connEvents.removeAll()
        let ownerID = "com.orchetect.midikit.testNonPersistentThruConnection"
        manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { events, _, _ in
                Task { @MainActor in
                    self.connEvents.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        try await Task.sleep(seconds: 0.200)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(manager.managedOutputs[output1Tag])
        // let output1ID = try #require(output1.uniqueID)
        // let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: 0.500) // needs to be long enough or test fails
        
        // add new connection
        
        let connTag = "testThruConnection"
        func addThru() throws {
            try manager.addThruConnection(
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
        
        try await Task.sleep(seconds: 0.200)
        
        #expect(
            try manager.unmanagedPersistentThruConnections(ownerID: ownerID).count ==
                1
        )
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        try await wait(require: { await connEvents == [.start()] }, timeout: 1.0)
        connEvents = []
        
        manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)
        
        #expect(
            try manager.unmanagedPersistentThruConnections(ownerID: ownerID).isEmpty
        )
        
        #expect(manager.managedThruConnections.isEmpty)
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(connEvents == [])
        connEvents = []
    }
    
    /// Tests getting thru connection parameters from Core MIDI after creating the thru connection
    /// and verifying they are correct.
    @Test
    func getParams() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        defer {
            // as a failsafe, clean up any persistent connections with an empty owner ID.
            // this is to account for the possible re-emergence of the Core MIDI thru bug
            
            if let num = try? manager.unmanagedPersistentThruConnections(ownerID: "").count,
               num > 0
            {
                print("Removing \(num) empty-ownerID persistent thru connections.")
            }
            
            manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
        }
        
        // initial state
        connEvents.removeAll()
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { events, _, _ in
                Task { @MainActor in
                    self.connEvents.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        let input1ID = try #require(input1.uniqueID)
        let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(manager.managedOutputs[output1Tag])
        let output1ID = try #require(output1.uniqueID)
        let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: 0.200) // 0.2 seems enough here
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent
        )
        
        #expect(manager.managedThruConnections[connTag] != nil)
        #expect(manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        try await Task.sleep(seconds: 0.200)
        
        let connRef = manager.managedThruConnections[connTag]!.coreMIDIThruConnectionRef!
        let getParams = try #require(try getThruConnectionParameters(ref: connRef))
        
        #expect(getParams.numSources == 1)
        #expect(getParams.sources.0.endpointRef == output1Ref)
        #expect(getParams.sources.0.uniqueID == output1ID)
        #expect(getParams.numDestinations == 1)
        #expect(getParams.destinations.0.endpointRef == input1Ref)
        #expect(getParams.destinations.0.uniqueID == input1ID)
        
        manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        #expect(manager.managedThruConnections[connTag] == nil)
    }
    
    /// Test the thru connection proxy in isolation, so at least we can test its function in CI.
    /// `MIDIManager.addThruConnection` relies on platform to decide whether to use the proxy or
    /// not, and since affected macOS versions may not always be available to test on in a CI
    /// pipeline, this test allows testing of the proxy, albeit in isolation.
    @Test
    func proxy() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // initial state
        connEvents.removeAll()
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events { events, _, _ in
                Task { @MainActor in
                    self.connEvents.append(contentsOf: events)
                }
            }
        )
        let input1 = try #require(manager.managedInputs[input1Tag])
        // let input1ID = try #require(input1.uniqueID)
        // let input1Ref = try #require(input1.coreMIDIInputPortRef)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try #require(manager.managedOutputs[output1Tag])
        // let output1ID = try #require(output1.uniqueID)
        // let output1Ref = try #require(output1.coreMIDIOutputPortRef)
        
        try await Task.sleep(seconds: 0.500) // this needs to be long enough or test fails
        
        // create thru proxy (this internal only and is NOT added to the manager)
        
        var thruProxy: MIDIThruConnectionProxy? = try MIDIThruConnectionProxy(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            midiManager: manager,
            api: manager.preferredAPI
        )
        _ = thruProxy // silence warning
        
        try await Task.sleep(seconds: 0.200)
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        try await wait(require: { await connEvents == [.start()] }, timeout: 2.0)
        connEvents = []
        
        thruProxy = nil
        
        try await Task.sleep(seconds: 0.200)
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        try await Task.sleep(seconds: 0.200) // wait a bit in case an event is sent
        #expect(connEvents == [])
        connEvents = []
        
        // Due to a Swift Core MIDI bug, all thru connections are created as persistent.
        // - See ThruConnection.swift for details
        let conns = try manager.unmanagedPersistentThruConnections(ownerID: "")
        
        #expect(conns.isEmpty)
    }
}

#endif
