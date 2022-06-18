//
//  ThruConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
@testable import MIDIKit
import CoreMIDI

final class InputsAndOutputs_ThruConnection_Tests: XCTestCase {
    
    override func setUp() {
        wait(sec: 0.2)
    }
    
    @MIDI.Atomic private var connEvents: [MIDI.Event] = []
    
    func testNonPersistentThruConnection() throws {
        
        try XCTSkipIf(
            !MIDI.IO.isThruConnectionsSupportedOnCurrentPlatform,
            "MIDI Thru Connections only function on macOS Catalina or earlier due to Core MIDI bugs on later macOS releases. Skipping unit test since it will fail on the current platform."
        )
        
        let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                      model: "MIDIKit123",
                                      manufacturer: "MIDIKit")
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        // initial state
        connEvents.removeAll()
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .none, // allow system to generate random ID
            receiveHandler: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false) { events in
                self.connEvents.append(contentsOf: events)
            })
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        //let input1ID = try XCTUnwrap(input1.uniqueID)
        //let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        //let output1ID = try XCTUnwrap(output1.uniqueID)
        //let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.2)
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent
        )
        
        XCTAssertNotNil(manager.managedThruConnections[connTag])
        XCTAssert(manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        wait(sec: 0.2)
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        wait(for: connEvents, equals: [.start()], timeout: 1.0)
        connEvents = []

        manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        XCTAssertNil(manager.managedThruConnections[connTag])
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
        // Due to a Swift Core MIDI bug, all thru connections are created as persistent.
        // - See ThruConnection.swift for details
        let conns = try manager.unmanagedPersistentThruConnections(ownerID: "")

        XCTAssert(conns.isEmpty)
        
        // as a failsafe, clean up any persistent connections with an empty owner ID
        manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
        
    }
    
    func testPersistentThruConnection() throws {
        
        try XCTSkipIf(
            !MIDI.IO.isThruConnectionsSupportedOnCurrentPlatform,
            "MIDI Thru Connections only function on macOS Catalina or earlier due to Core MIDI bugs on later macOS releases. Skipping unit test since it will fail on the current platform."
        )
        
        let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                      model: "MIDIKit123",
                                      manufacturer: "MIDIKit")
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        // initial state
        connEvents.removeAll()
        let ownerID = "com.orchetect.midikit.testNonPersistentThruConnection"
        manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .none, // allow system to generate random ID
            receiveHandler: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false) { events in
                self.connEvents.append(contentsOf: events)
            })
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        //let input1ID = try XCTUnwrap(input1.uniqueID)
        //let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
        
        wait(sec: 0.2)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        //let output1ID = try XCTUnwrap(output1.uniqueID)
        //let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.2)
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .persistent(ownerID: ownerID)
        )
        
        wait(sec: 0.2)

        XCTAssertEqual(try manager.unmanagedPersistentThruConnections(ownerID: ownerID).count, 1)

        // send an event - it should be received by the input
        try output1.send(event: .start())
        wait(for: connEvents, equals: [.start()], timeout: 1.0)
        connEvents = []

        manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)

        XCTAssertEqual(try manager.unmanagedPersistentThruConnections(ownerID: ownerID).count, 0)
        
        XCTAssertEqual(manager.managedThruConnections.count, 0)
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
    }
    
    /// Tests getting thru connection parameters from Core MIDI after creating the thru connection and verifying they are correct.
    func testGetParams() throws {
        
        try XCTSkipIf(
            !MIDI.IO.isThruConnectionsSupportedOnCurrentPlatform,
            "MIDI Thru Connections only function on macOS Catalina or earlier due to Core MIDI bugs on later macOS releases. Skipping unit test since it will fail on the current platform."
        )
        
        let manager = MIDI.IO.Manager(clientName: UUID().uuidString,
                                      model: "MIDIKit123",
                                      manufacturer: "MIDIKit")
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        // initial state
        connEvents.removeAll()
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .none, // allow system to generate random ID
            receiveHandler: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false) { events in
                self.connEvents.append(contentsOf: events)
            })
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .none // allow system to generate random ID
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        let output1ID = try XCTUnwrap(output1.uniqueID)
        let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.2)
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent
        )
        
        XCTAssertNotNil(manager.managedThruConnections[connTag])
        XCTAssert(manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        wait(sec: 0.2)
        
        let connRef = manager.managedThruConnections[connTag]!.coreMIDIThruConnectionRef!
        let getParams = try XCTUnwrap(try MIDI.IO.getThruConnectionParameters(ref: connRef))
        
        XCTAssertEqual(getParams.numSources, 1)
        XCTAssertEqual(getParams.sources.0.endpointRef, output1Ref)
        XCTAssertEqual(getParams.sources.0.uniqueID, output1ID.coreMIDIUniqueID)
        XCTAssertEqual(getParams.numDestinations, 1)
        XCTAssertEqual(getParams.destinations.0.endpointRef, input1Ref)
        XCTAssertEqual(getParams.destinations.0.uniqueID, input1ID.coreMIDIUniqueID)
        
        manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        XCTAssertNil(manager.managedThruConnections[connTag])
        
        // as a failsafe, clean up any persistent connections with an empty owner ID
        manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
        
    }
    
}

#endif
