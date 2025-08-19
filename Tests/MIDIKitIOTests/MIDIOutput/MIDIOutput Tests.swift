//
//  MIDIOutput Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite(.serialized) struct MIDIOutput_Tests {
    private final actor ManagerWrapper {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    }
    
    @Test
    func output() async throws {
        let isStable = isSystemTimingStable()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // add new endpoint
        
        let tag1 = UUID().uuidString
        
        try mw.manager.addOutput(
            name: UUID().uuidString,
            tag: tag1,
            uniqueID: .adHoc // allow system to generate random ID each time, no persistence
        )
        
        let output = try #require(mw.manager.managedOutputs[tag1])
        let id1 = try #require(output.uniqueID)
        
        // send a midi message
        
        #expect(throws: Never.self) {
            try output.send(event: .systemReset(group: 0))
        }
        #expect(throws: Never.self) {
            try output.send(events: [.systemReset(group: 0)])
        }
        
        // unique ID collision
        
        let tag2 = UUID().uuidString
        
        try mw.manager.addOutput(
            name: UUID().uuidString,
            tag: tag2,
            uniqueID: .unmanaged(id1) // try to use existing ID
        )
        
        let id2 = try #require(mw.manager.managedOutputs[tag2]?.uniqueID)
        
        // ensure ids are different
        #expect(id1 != id2)
        
        // remove endpoints
        
        mw.manager.remove(.output, .withTag(tag1))
        #expect(mw.manager.managedOutputs[tag1] == nil)
        
        mw.manager.remove(.output, .withTag(tag2))
        #expect(mw.manager.managedOutputs[tag2] == nil)
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
        
        try mw.manager.addOutput(
            name: initialName,
            tag: tag1,
            uniqueID: .adHoc // allow system to generate random ID each time, no persistence
        )
        
        let managedOutput = try #require(mw.manager.managedOutputs[tag1])
        let id1 = try #require(managedOutput.uniqueID); _ = id1
        let ref1 = try #require(managedOutput.coreMIDIOutputPortRef)
        
        // check initial conditions
        
        #expect(managedOutput.name == initialName)
        #expect(managedOutput.endpoint.displayName == initialName)
        
        // set `name` - Core MIDI will also update `displayName` at the same time
        
        let newName = UUID().uuidString
        managedOutput.name = newName
        
        #expect(managedOutput.name == newName)
        #expect(try getString(forProperty: kMIDIPropertyName, of: ref1) == newName)
        
        #expect(managedOutput.endpoint.displayName == newName)
        #expect(try getString(forProperty: kMIDIPropertyDisplayName, of: ref1) == newName)
    }
}

#endif
