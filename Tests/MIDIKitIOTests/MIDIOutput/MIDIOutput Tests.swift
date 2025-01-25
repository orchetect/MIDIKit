//
//  MIDIOutput Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite(.serialized) @MainActor struct MIDIOutput_Tests {
    @Test
    func output() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(for: .milliseconds(100))
        
        // add new endpoint
        
        let tag1 = "1"
        
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 1",
            tag: tag1,
            uniqueID: .adHoc // allow system to generate random ID each time, no persistence
        )
        
        let output = try #require(manager.managedOutputs[tag1])
        let id1 = try #require(output.uniqueID)
        
        // send a midi message
        
        #expect(throws: Never.self) {
            try output.send(event: .systemReset(group: 0))
        }
        #expect(throws: Never.self) {
            try output.send(events: [.systemReset(group: 0)])
        }
        
        // unique ID collision
        
        let tag2 = "2"
        
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 2",
            tag: tag2,
            uniqueID: .unmanaged(id1) // try to use existing ID
        )
        
        let id2 = try #require(manager.managedOutputs[tag2]?.uniqueID)
        
        // ensure ids are different
        #expect(id1 != id2)
        
        // remove endpoints
        
        manager.remove(.output, .withTag(tag1))
        #expect(manager.managedOutputs[tag1] == nil)
        
        manager.remove(.output, .withTag(tag2))
        #expect(manager.managedOutputs[tag2] == nil)
    }
    
    @Test
    func setProperties() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(for: .milliseconds(100))
        
        // add new endpoint
        
        let tag1 = "1"
        let initialName = "MIDIKit IO Properties Tests 1"
        
        try manager.addOutput(
            name: initialName,
            tag: tag1,
            uniqueID: .adHoc // allow system to generate random ID each time, no persistence
        )
        
        let managedOutput = try #require(manager.managedOutputs[tag1])
        let id1 = try #require(managedOutput.uniqueID) ; _ = id1
        let ref1 = try #require(managedOutput.coreMIDIOutputPortRef)
        
        // check initial conditions
        
        #expect(managedOutput.name == initialName)
        #expect(managedOutput.endpoint.displayName == initialName)
        
        // set `name` - Core MIDI will also update `displayName` at the same time
        
        let newName = "New Name"
        managedOutput.name = newName
        try await Task.sleep(for: .milliseconds(200))
        
        #expect(managedOutput.name == newName)
        #expect(try getString(forProperty: kMIDIPropertyName, of: ref1) == newName)
        
        #expect(managedOutput.endpoint.displayName == newName)
        #expect(try getString(forProperty: kMIDIPropertyDisplayName, of: ref1) == newName)
    }
}

#endif
