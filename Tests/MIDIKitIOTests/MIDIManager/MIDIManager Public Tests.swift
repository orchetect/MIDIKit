//
//  MIDIManager Public Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
import MIDIKitIO
import Testing

/// Note: this file does not contain any tests. It is a scratchpad.
@Suite struct MIDIManager_Public_Tests {
    let manager = MIDIManager(
        clientName: UUID().uuidString,
        model: "MIDIKit123",
        manufacturer: "MIDIKit"
    )
    
    @Test
    func manager_PublicMethods() {
        // skip starting manager
        
        // we just want to test the API
        
        _ = manager.clientName
        _ = manager.coreMIDIClientRef
        _ = manager.model
    }
    
    @Test
    func managedOutput_PublicMethods() {
        // this will be nil since no managed ports are set up, but that doesn't matter;
        // we just want to test the API
        let output = manager.managedOutputs.first?.value
        
        _ = output?.api
        _ = output?.midiProtocol
        _ = output?.coreMIDIOutputPortRef
        _ = output?.name
        _ = output?.uniqueID
        
        _ = output?.description
    }
    
    @Test
    func managedOutputConnection_PublicMethods() {
        // this will be nil since no managed ports are set up, but that doesn't matter;
        // we just want to test the API
        let output = manager.managedOutputConnections.first?.value
        
        _ = output?.api
        _ = output?.midiProtocol
        _ = output?.coreMIDIOutputPortRef
        _ = output?.inputsCriteria
        _ = output?.coreMIDIInputEndpointRefs
        
        _ = output?.description
    }
    
    @Test
    func managedInput_PublicMethods() {
        // this will be nil since no managed ports are set up, but that doesn't matter;
        // we just want to test the API
        let input = manager.managedInputs.first?.value
        
        _ = input?.api
        _ = input?.midiProtocol
        _ = input?.coreMIDIInputPortRef
        _ = input?.name
        _ = input?.uniqueID
        
        _ = input?.description
    }
    
    @Test
    func managedInputConnection_PublicMethods() {
        // this will be nil since no managed ports are set up, but that doesn't matter;
        // we just want to test the API
        let input = manager.managedInputConnections.first?.value
        
        _ = input?.api
        _ = input?.midiProtocol
        _ = input?.coreMIDIInputPortRef
        _ = input?.outputsCriteria
        _ = input?.coreMIDIOutputEndpointRefs
        
        _ = input?.description
    }
    
    @Test
    func managedThruConnection_PublicMethods() {
        // this will be nil since no managed ports are set up, but that doesn't matter;
        // we just want to test the API
        let thru = manager.managedThruConnections.first?.value
        
        _ = thru?.api
        _ = thru?.coreMIDIThruConnectionRef
        _ = thru?.inputs
        _ = thru?.outputs
        _ = thru?.lifecycle
        _ = thru?.parameters
        
        _ = thru?.description
    }
    
    @Test
    func midiManaged() {
        // we just want to test the API
        
        class Foo: MIDIManaged {
            var api: CoreMIDIAPIVersion = .legacyCoreMIDI
        }
        
        let foo = Foo()
        
        _ = foo.api
    }
}

#endif
