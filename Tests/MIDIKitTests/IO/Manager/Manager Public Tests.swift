//
//  Manager Public Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import XCTestUtils
import MIDIKit
import CoreMIDI

final class Manager_Public_Tests: XCTestCase {
    
    let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                  model: "MIDIKit123",
                                  manufacturer: "MIDIKit")
    
    func testManager_PublicMethods() {
        
        // skip starting manager
        
        // we just want to test the API
        
        _ = manager.clientName
        _ = manager.coreMIDIClientRef
        _ = manager.model
        
    }
    
    func testManagedOutput_PublicMethods() {
        
        // this will be nil since no managed ports are set up, but that doesn't matter;
        // we just want to test the API
        let output = manager.managedOutputs.first?.value
        
        _ = output?.api
        _ = output?.midiProtocol
        _ = output?.coreMIDIOutputPortRef
        _ = output?.endpointName
        _ = output?.uniqueID
        
        _ = output?.description
        
    }
    
    func testManagedOutputConnection_PublicMethods() {
        
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
    
    func testManagedInput_PublicMethods() {
        
        // this will be nil since no managed ports are set up, but that doesn't matter;
        // we just want to test the API
        let input = manager.managedInputs.first?.value
        
        _ = input?.api
        _ = input?.midiProtocol
        _ = input?.coreMIDIInputPortRef
        _ = input?.endpointName
        _ = input?.uniqueID
        
        _ = input?.description
        
    }
    
    func testManagedInputConnection_PublicMethods() {
        
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
    
    func testManagedThruConnection_PublicMethods() {
        
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
    
    func testMIDIIOManagedProtocol() {
        
        // we just want to test the API
        
        class Foo: MIDIIOManagedProtocol {
            var api: MIDI.IO.APIVersion = .legacyCoreMIDI
        }
        
        let foo = Foo()
        
        _ = foo.api
        
    }
    
}

#endif
