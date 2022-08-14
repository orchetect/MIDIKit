//
//  MIDIInput Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import MIDIKit
import CoreMIDI

final class MIDIInput_Tests: XCTestCase {
    func testInput() throws {
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
            try manager.addInput(
                name: "MIDIKit IO Tests Destination 1",
                tag: tag1,
                uniqueID: .none,
                // allow system to generate random ID each time, without persistence
                receiveHandler: .rawData { packets in
                    _ = packets
                }
            )
        } catch let err as MIDIIOError {
            XCTFail(err.localizedDescription); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
		
        XCTAssertNotNil(manager.managedInputs[tag1])
        let id1 = manager.managedInputs[tag1]?.uniqueID
        XCTAssertNotNil(id1)
        
        // unique ID collision
		
        let tag2 = "2"
		
        do {
            try manager.addInput(
                name: "MIDIKit IO Tests Destination 2",
                tag: tag2,
                uniqueID: .unmanaged(id1!), // try to use existing ID
                receiveHandler: .rawData { packet in
                    _ = packet
                }
            )
        } catch let err as MIDIIOError {
            XCTFail("\(err)"); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
		
        XCTAssertNotNil(manager.managedInputs[tag2])
        let id2 = manager.managedInputs[tag2]?.uniqueID
        
        // ensure ids are different
        XCTAssertNotEqual(id1, id2)
		
        // remove endpoints
		
        manager.remove(.input, .withTag(tag1))
        XCTAssertNil(manager.managedInputs[tag1])
		
        manager.remove(.input, .withTag(tag2))
        XCTAssertNil(manager.managedInputs[tag2])
    }
}

#endif
