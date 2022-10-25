//
//  MIDIManager Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKitIO
import CoreMIDI

final class MIDIManager_Tests: XCTestCase {
    static let clientName = UUID().uuidString
    
    let manager = MIDIManager(
        clientName: clientName,
        model: "MIDIKit123",
        manufacturer: "MIDIKit"
    )
	
    func testMIDIO_Manager_defaults() throws {
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
        XCTAssert(
            try manager.unmanagedPersistentThruConnections(
                ownerID: Bundle.main
                    .bundleIdentifier ?? "nil"
            )
            .isEmpty
        )
    }
	
    func testMIDIIOManagedProtocol() {
        // we just want to test the API
    
        // public protocol
    
        class Foo: MIDIIOManagedProtocol {
            var api: CoreMIDIAPIVersion = .legacyCoreMIDI
        }
    
        let foo = Foo()
    
        _ = foo.api
    
        // internal protocol
    
        class Bar: _MIDIIOManagedProtocol {
            var midiManager: MIDIManager?
            var api: CoreMIDIAPIVersion = .legacyCoreMIDI
        }
    
        let bar = Bar()
    
        _ = bar.api
        _ = bar.midiManager
    }
}

#endif
