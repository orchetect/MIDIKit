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
    private final actor ManagerWrapper {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    }
    
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
