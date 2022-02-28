//
//  Manager Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit
import CoreMIDI

final class Manager_Tests: XCTestCase {
	
    static let clientName = UUID().uuidString
    
    let manager = MIDI.IO.Manager(clientName: clientName,
                                  model: "MIDIKit123",
                                  manufacturer: "MIDIKit")
	
	func testMIDIO_Manager_defaults() {
		
        // just check defaults without calling .start() on the manager
        
		XCTAssertEqual(manager.clientName, Self.clientName)
        XCTAssertEqual(manager.model, "MIDIKit123")
        XCTAssertEqual(manager.manufacturer, "MIDIKit")
		XCTAssertEqual(manager.coreMIDIClientRef, MIDIClientRef())
		
		XCTAssert(manager.managedInputConnections.isEmpty)
		XCTAssert(manager.managedOutputConnections.isEmpty)
		XCTAssert(manager.managedInputs.isEmpty)
		XCTAssert(manager.managedOutputs.isEmpty)
		XCTAssert(manager.managedThruConnections.isEmpty)
		XCTAssert(try! manager
                    .unmanagedPersistentThruConnections(ownerID: Bundle.main.bundleIdentifier ?? "nil")
					.isEmpty)
		
	}
	
    func testMIDIIOManagedProtocol() {
        
        // we just want to test the API
        
        // public protocol
        
        class Foo: MIDIIOManagedProtocol {
            var api: MIDI.IO.APIVersion = .legacyCoreMIDI
        }
        
        let foo = Foo()
        
        _ = foo.api
        
        // internal protocol
        
        class Bar: _MIDIIOManagedProtocol {
            var midiManager: MIDI.IO.Manager? = nil
            var api: MIDI.IO.APIVersion = .legacyCoreMIDI
        }
        
        let bar = Bar()
        
        _ = bar.api
        _ = bar.midiManager
        
    }
    
}

#endif
