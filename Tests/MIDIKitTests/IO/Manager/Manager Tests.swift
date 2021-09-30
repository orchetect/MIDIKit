//
//  Manager Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import CoreMIDI

final class Manager_Tests: XCTestCase {
	
	var manager: MIDI.IO.Manager! = nil
	
	override func setUp() {
		manager = .init(clientName: "MIDIKit_IO_Manager_Tests",
						model: "MIDIKit123",
						manufacturer: "MIDIKit")
	}
	
	override func tearDown() {
		manager = nil
	}
	
	func testMIDIO_Manager_defaults() {
		
        // just check defaults without calling .start() on the manager
        
		XCTAssertEqual(manager.clientName, "MIDIKit_IO_Manager_Tests")
        XCTAssertEqual(manager.model, "MIDIKit123")
        XCTAssertEqual(manager.manufacturer, "MIDIKit")
		XCTAssertEqual(manager.clientRef, MIDIClientRef())
		
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
        
        struct Foo: MIDIIOManagedProtocol {
            var api: MIDI.IO.APIVersion = .legacyCoreMIDI
        }
        
        let foo = Foo()
        
        _ = foo.api
        
        // internal protocol
        
        struct Bar: _MIDIIOManagedProtocol {
            var midiManager: MIDI.IO.Manager? = nil
            var api: MIDI.IO.APIVersion = .legacyCoreMIDI
        }
        
        let bar = Bar()
        
        _ = bar.api
        _ = bar.midiManager
        
    }
    
}

#endif
