//
//  MIDIManager Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite struct MIDIManager_Tests {
    static let clientName = UUID().uuidString
    
    let manager = MIDIManager(
        clientName: clientName,
        model: "MIDIKit123",
        manufacturer: "MIDIKit"
    )
    
    @Test
    func midiIO_Manager_defaults() throws {
        // just check defaults without calling .start() on the manager
        
        #expect(manager.clientName == Self.clientName)
        #expect(manager.model == "MIDIKit123")
        #expect(manager.manufacturer == "MIDIKit")
        #expect(manager.coreMIDIClientRef == MIDIClientRef())
        
        #expect(manager.managedInputConnections.isEmpty)
        #expect(manager.managedOutputConnections.isEmpty)
        #expect(manager.managedInputs.isEmpty)
        #expect(manager.managedOutputs.isEmpty)
        #expect(manager.managedThruConnections.isEmpty)
        #expect(
            try manager.unmanagedPersistentThruConnections(
                ownerID: Bundle.main
                    .bundleIdentifier ?? "nil"
            )
            .isEmpty
        )
    }
    
    @Test
    func midiManaged() {
        // we just want to test the API
        
        // public protocol
        
        class Foo: MIDIManaged {
            var api: CoreMIDIAPIVersion = .legacyCoreMIDI
        }
        
        let foo = Foo()
        
        _ = foo.api
        
        // internal protocol
        
        class Bar: MIDIManaged {
            var midiManager: MIDIManager?
            var api: CoreMIDIAPIVersion = .legacyCoreMIDI
        }
        
        let bar = Bar()
        
        _ = bar.api
        _ = bar.midiManager
    }
}

#endif
