//
//  MIDIInput Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite(.serialized) struct MIDIInput_Tests {
    @TestActor private final class Receiver {
        var events: [MIDIEvent] = []
        func add(events: [MIDIEvent]) { self.events.append(contentsOf: events) }
        func reset() { events.removeAll() }
        
        nonisolated init() { }
    }
    
    private final actor ManagerWrapper {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    }
    
    // MARK: - Tests
    
    @Test
    func input() async throws {
        let isStable = isSystemTimingStable()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new endpoint
        
        let tag1 = UUID().uuidString
        
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: tag1,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .rawData { packets in
                _ = packets
            }
        )
        
        let id1 = try #require(mw.manager.managedInputs[tag1]?.uniqueID)
        
        // unique ID collision
        
        let tag2 = UUID().uuidString
        
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: tag2,
            uniqueID: .unmanaged(id1), // try to use existing ID
            receiver: .rawData { packet in
                _ = packet
            }
        )
        
        let id2 = try #require(mw.manager.managedInputs[tag2]?.uniqueID)
        
        // ensure ids are different
        try #require(id1 != id2)
        
        // remove endpoints
        
        mw.manager.remove(.input, .withTag(tag1))
        #expect(mw.manager.managedInputs[tag1] == nil)
        
        mw.manager.remove(.input, .withTag(tag2))
        #expect(mw.manager.managedInputs[tag2] == nil)
    }
    
    /// Test setting receive handler after initializing an Input.
    @Test
    func input_setReceiver() async throws {
        let isStable = isSystemTimingStable()
        
        let mw = ManagerWrapper()
        let receiverA = Receiver()
        let receiverB = Receiver()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new input
        let inputTag = "input"
        try mw.manager.addInput(
            name: UUID().uuidString,
            tag: inputTag,
            uniqueID: .adHoc,
            receiver: .events { [weak receiverA] events, _, _ in
                Task { @TestActor in
                    receiverA?.add(events: events)
                }
            }
        )
        let input = try #require(mw.manager.managedInputs[inputTag])
        let inputID = try #require(input.uniqueID)
        let inputRef = try #require(input.coreMIDIInputPortRef)
        #expect(inputID != 0)
        try await Task.sleep(seconds: 0.5)
        
        // set new receive handler
        input.setReceiver(.events { [weak receiverB] events, _, _ in
            Task { @TestActor in
                receiverB?.add(events: events)
            }
        })
        
        // create an output connection
        let connTag = UUID().uuidString
        try mw.manager.addOutputConnection(
            to: .inputs([input.endpoint]),
            tag: connTag,
            filter: .default()
        )
        
        let conn = try #require(mw.manager.managedOutputConnections[connTag])
        
        // assert that input was automatically added to the connection
        try await wait(require: { conn.inputsCriteria == [.uniqueID(inputID)] }, timeout: 2.0)
        try await wait(require: { conn.coreMIDIInputEndpointRefs == [inputRef] }, timeout: 2.0)
        try await wait(require: { conn.endpoints == [input.endpoint] }, timeout: 2.0)
        
        // send an event - it should be received by the new receive handler
        try conn.send(event: .start())
        await wait(expect: { await receiverB.events == [.start()] }, timeout: isStable ? 2.0 : 10.0)
        #expect(await receiverA.events == [])
        await receiverA.reset()
        await receiverB.reset()
    }
    
    @Test
    func setProperties() async throws {
        let isStable = isSystemTimingStable()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new endpoint
        
        let tag1 = UUID().uuidString
        let initialName = UUID().uuidString
        
        try mw.manager.addInput(
            name: initialName,
            tag: tag1,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .rawData { packets in
                _ = packets
            }
        )
        
        let managedInput = try #require(mw.manager.managedInputs[tag1])
        let id1 = try #require(managedInput.uniqueID); _ = id1
        let ref1 = try #require(managedInput.coreMIDIInputPortRef)
        
        // check initial conditions
        
        #expect(managedInput.name == initialName)
        #expect(managedInput.endpoint.displayName == initialName)
        
        // set `name` - Core MIDI will also update `displayName` at the same time
        
        let newName = UUID().uuidString
        managedInput.name = newName
        
        #expect(managedInput.name == newName)
        #expect(try getString(forProperty: kMIDIPropertyName, of: ref1) == newName)
        
        #expect(managedInput.endpoint.displayName == newName)
        #expect(try getString(forProperty: kMIDIPropertyDisplayName, of: ref1) == newName)
    }
}

#endif
