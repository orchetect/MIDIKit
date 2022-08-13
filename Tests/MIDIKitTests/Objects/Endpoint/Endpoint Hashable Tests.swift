//
//  Endpoint Hashable Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKit

final class Endpoint_Hashable_Tests: XCTestCase {
    func testInputEndpoint1() {
        let same: Set<MIDIInputEndpoint> = [
            .init(123),
            .init(123)
        ]
        
        XCTAssertEqual(same.count, 1)
    }
    
    func testInputEndpoint1B() {
        let same: Set<MIDIInputEndpoint> = [
            .init(123),
            .init(456)
        ]
        
        // even with different ref IDs, since these don't actually currently
        // exist in the system, their Unique IDs will both be 0 and thus equal
        XCTAssertEqual(same.count, 1)
    }
    
    func testInputEndpoint2() {
        let same: Set<MIDIInputEndpoint> = [
            MIDIInputEndpoint(
                ref: 123,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 12_345_678
            ),
            MIDIInputEndpoint(
                ref: 456,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 12_345_678
            )
        ]
        
        XCTAssertEqual(same.count, 1)
    }
    
    func testInputEndpoint2Diff() {
        let same: Set<MIDIInputEndpoint> = [
            MIDIInputEndpoint(
                ref: 123,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 12_345_678
            ),
            MIDIInputEndpoint(
                ref: 456,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 987_654_321
            )
        ]
        
        XCTAssertEqual(same.count, 2)
    }
    
    func testOutputEndpoint1() {
        let same: Set<MIDIOutputEndpoint> = [
            .init(123),
            .init(123)
        ]
        
        XCTAssertEqual(same.count, 1)
    }
    
    func testOutputEndpoint1B() {
        let same: Set<MIDIOutputEndpoint> = [
            .init(123),
            .init(456)
        ]
        
        // even with different ref IDs, since these don't actually currently
        // exist in the system, their Unique IDs will both be 0 and thus equal
        XCTAssertEqual(same.count, 1)
    }
    
    func testOutputEndpoint2() {
        let same: Set<MIDIOutputEndpoint> = [
            MIDIOutputEndpoint(
                ref: 123,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 12_345_678
            ),
            MIDIOutputEndpoint(
                ref: 456,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 12_345_678
            )
        ]
        
        XCTAssertEqual(same.count, 1)
    }
    
    func testOutputEndpoint2Diff() {
        let same: Set<MIDIOutputEndpoint> = [
            MIDIOutputEndpoint(
                ref: 123,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 12_345_678
            ),
            MIDIOutputEndpoint(
                ref: 456,
                name: "TestEndpoint",
                displayName: "Name",
                uniqueID: 987_654_321
            )
        ]
        
        XCTAssertEqual(same.count, 2)
    }
}

#endif
