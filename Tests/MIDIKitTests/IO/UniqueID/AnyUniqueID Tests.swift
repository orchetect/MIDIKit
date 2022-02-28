//
//  AnyUniqueID Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class AnyUniqueID_Tests: XCTestCase {
    
    func testAnyUniqueID() {
        
        let allUniqueIDTypes: [MIDIIOUniqueIDProtocol] = [
            MIDI.IO.Device.UniqueID(10000000),
            MIDI.IO.Entity.UniqueID(10000001),
            MIDI.IO.InputEndpoint.UniqueID(10000002),
            MIDI.IO.OutputEndpoint.UniqueID(10000003)
        ]
        
        let anyArray = allUniqueIDTypes.asAnyUniqueIDs
        
        XCTAssertEqual(anyArray.count, 4)
        XCTAssertEqual(anyArray[0].coreMIDIUniqueID, 10000000)
        XCTAssertEqual(anyArray[1].coreMIDIUniqueID, 10000001)
        XCTAssertEqual(anyArray[2].coreMIDIUniqueID, 10000002)
        XCTAssertEqual(anyArray[3].coreMIDIUniqueID, 10000003)
        
    }
    
}
#endif
