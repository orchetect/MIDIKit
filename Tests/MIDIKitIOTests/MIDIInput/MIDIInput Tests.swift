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

@Suite(.serialized) @MainActor struct MIDIInput_Tests {
    @Test
    func input() async throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        try await Task.sleep(seconds: 0.100)
        
        // add new endpoint
        
        let tag1 = "1"
        
        try manager.addInput(
            name: "MIDIKit IO Tests Destination 1",
            tag: tag1,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .rawData { packets in
                _ = packets
            }
        )
        
        let id1 = try #require(manager.managedInputs[tag1]?.uniqueID)
        
        // unique ID collision
        
        let tag2 = "2"
        
        try manager.addInput(
            name: "MIDIKit IO Tests Destination 2",
            tag: tag2,
            uniqueID: .unmanaged(id1), // try to use existing ID
            receiver: .rawData { packet in
                _ = packet
            }
        )
        
        let id2 = try #require(manager.managedInputs[tag2]?.uniqueID)
        
        // ensure ids are different
        try #require(id1 != id2)
        
        // remove endpoints
        
        manager.remove(.input, .withTag(tag1))
        #expect(manager.managedInputs[tag1] == nil)
        
        manager.remove(.input, .withTag(tag2))
        #expect(manager.managedInputs[tag2] == nil)
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
        try await Task.sleep(seconds: 0.100)
        
        // add new endpoint
        
        let tag1 = "1"
        let initialName = "MIDIKit IO Properties Tests 1"
        
        try manager.addInput(
            name: initialName,
            tag: tag1,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .rawData { packets in
                _ = packets
            }
        )
        
        let managedInput = try #require(manager.managedInputs[tag1])
        let id1 = try #require(managedInput.uniqueID); _ = id1
        let ref1 = try #require(managedInput.coreMIDIInputPortRef)
        
        // check initial conditions
        
        #expect(managedInput.name == initialName)
        #expect(managedInput.endpoint.displayName == initialName)
        
        // set `name` - Core MIDI will also update `displayName` at the same time
        
        let newName = "New Name"
        managedInput.name = newName
        try await Task.sleep(seconds: 0.200)
        
        #expect(managedInput.name == newName)
        #expect(try getString(forProperty: kMIDIPropertyName, of: ref1) == newName)
        
        #expect(managedInput.endpoint.displayName == newName)
        #expect(try getString(forProperty: kMIDIPropertyDisplayName, of: ref1) == newName)
    }
}

#endif
