//
//  Endpoint Hashable Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class EndpointHashableTests: XCTestCase {
    
    func testInputEndpoint1() {
        
        let same: Set<MIDI.IO.InputEndpoint> = [
            .init(123),
            .init(123)
        ]
        
        XCTAssertEqual(same.count, 1)
        
    }
    
    func testInputEndpoint1B() {
        
        let same: Set<MIDI.IO.InputEndpoint> = [
            .init(123),
            .init(456)
        ]
        
        // even with different ref IDs, since these don't actually currently
        // exist in the system, their Unique IDs will both be 0 and thus equal
        XCTAssertEqual(same.count, 1)
        
    }
    
    func testInputEndpoint2() {
        
        let same: Set<MIDI.IO.InputEndpoint> = [
            MIDI.IO.InputEndpoint(ref: 123,
                                  name: "TestEndpoint",
                                  displayName: "Name",
                                  uniqueID: 12345678),
            MIDI.IO.InputEndpoint(ref: 456,
                                  name: "TestEndpoint",
                                  displayName: "Name",
                                  uniqueID: 12345678)
            ]
        
        XCTAssertEqual(same.count, 1)
        
    }
    
    func testInputEndpoint2Diff() {
        
        let same: Set<MIDI.IO.InputEndpoint> = [
            MIDI.IO.InputEndpoint(ref: 123,
                                  name: "TestEndpoint",
                                  displayName: "Name",
                                  uniqueID: 12345678),
            MIDI.IO.InputEndpoint(ref: 456,
                                  name: "TestEndpoint",
                                  displayName: "Name",
                                  uniqueID: 987654321)
        ]
        
        XCTAssertEqual(same.count, 2)
        
    }
    
    func testOutputEndpoint1() {
        
        let same: Set<MIDI.IO.OutputEndpoint> = [
            .init(123),
            .init(123)
        ]
        
        XCTAssertEqual(same.count, 1)
        
    }
    
    func testOutputEndpoint1B() {
        
        let same: Set<MIDI.IO.OutputEndpoint> = [
            .init(123),
            .init(456)
        ]
        
        // even with different ref IDs, since these don't actually currently
        // exist in the system, their Unique IDs will both be 0 and thus equal
        XCTAssertEqual(same.count, 1)
        
    }
    
    func testOutputEndpoint2() {
        
        let same: Set<MIDI.IO.OutputEndpoint> = [
            MIDI.IO.OutputEndpoint(ref: 123,
                                   name: "TestEndpoint",
                                   displayName: "Name",
                                   uniqueID: 12345678),
            MIDI.IO.OutputEndpoint(ref: 456,
                                   name: "TestEndpoint",
                                   displayName: "Name",
                                   uniqueID: 12345678)
        ]
        
        XCTAssertEqual(same.count, 1)
        
    }
    
    func testOutputEndpoint2Diff() {
        
        let same: Set<MIDI.IO.OutputEndpoint> = [
            MIDI.IO.OutputEndpoint(ref: 123,
                                   name: "TestEndpoint",
                                   displayName: "Name",
                                   uniqueID: 12345678),
            MIDI.IO.OutputEndpoint(ref: 456,
                                   name: "TestEndpoint",
                                   displayName: "Name",
                                   uniqueID: 987654321)
        ]
        
        XCTAssertEqual(same.count, 2)
        
    }
    
}

#endif
