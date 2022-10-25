//
//  MIDIOutput Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import MIDIKitIO
import CoreMIDI

final class MIDIOutput_Tests: XCTestCase {
    func testOutput() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
		
        // add new endpoint
		
        let tag1 = "1"
		
        do {
            try manager.addOutput(
                name: "MIDIKit IO Tests Source 1",
                tag: tag1,
                uniqueID: .adHoc // allow system to generate random ID each time, no persistence
            )
        } catch let err as MIDIIOError {
            XCTFail(err.localizedDescription); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
		
        XCTAssertNotNil(manager.managedOutputs[tag1])
        let id1 = manager.managedOutputs[tag1]?.uniqueID
        XCTAssertNotNil(id1)
    
        // send a midi message
		
        XCTAssertNoThrow(
            try manager.managedOutputs[tag1]?
                .send(event: .systemReset(group: 0))
        )
        XCTAssertNoThrow(
            try manager.managedOutputs[tag1]?
                .send(events: [.systemReset(group: 0)])
        )
    
        // unique ID collision
		
        let tag2 = "2"
		
        do {
            try manager.addOutput(
                name: "MIDIKit IO Tests Source 2",
                tag: tag2,
                uniqueID: .unmanaged(id1!) // try to use existing ID
            )
        } catch let err as MIDIIOError {
            XCTFail("\(err)"); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
		
        XCTAssertNotNil(manager.managedOutputs[tag2])
        let id2 = manager.managedOutputs[tag2]?.uniqueID
        XCTAssertNotNil(id2)
		
        // ensure ids are different
        XCTAssertNotEqual(id1, id2)
		
        // remove endpoints
		
        manager.remove(.output, .withTag(tag1))
        XCTAssertNil(manager.managedOutputs[tag1])
		
        manager.remove(.output, .withTag(tag2))
        XCTAssertNil(manager.managedOutputs[tag2])
    }
}

#endif
