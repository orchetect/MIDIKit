//
//  MIDIIOEndpointProtocol Collection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKit

final class MIDIIOEndpointProtocol_Collection_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    // MARK: - sorted
    
    func testSortedByDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000),
            .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002)
        ]
        
        XCTAssertEqual(
            elements.sortedByName(),
            [
                .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002),
                .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000),
                .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001)
            ]
        )
        
        XCTAssertEqual(
            elements.sortedByDisplayName(),
            [
                .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
                .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002),
                .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000)
            ]
        )
    }
    
    // MARK: - first
    
    func testFirstWhereDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.first(whereDisplayName: "A"),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003)
        )
        
        XCTAssertEqual(
            elements.first(whereDisplayName: ""),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        )
        
        XCTAssertNil(
            elements.first(whereDisplayName: "E")
        )
    }
    
    func testFirstWhereDisplayNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.first(whereDisplayName: "", ignoringEmpty: false),
            .init(ref: 1004, name: "Port D", displayName: "", uniqueID: -1004)
        )
        
        XCTAssertNil(
            elements.first(whereDisplayName: "", ignoringEmpty: true)
        )
    }
    
    func testFirstWhereUniqueID_fallbackDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        // prioritize unique ID
        XCTAssertEqual(
            elements.first(whereUniqueID: -1002, fallbackDisplayName: "2"),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        XCTAssertEqual(
            elements.first(whereUniqueID: -1002, fallbackDisplayName: "4"),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        XCTAssertEqual(
            elements.first(whereUniqueID: -1002, fallbackDisplayName: ""),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        // ID not found, fall back to display name
        XCTAssertEqual(
            elements.first(whereUniqueID: -2000, fallbackDisplayName: "4"),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        // ID not found, fall back to display name
        XCTAssertEqual(
            elements.first(whereUniqueID: -2000, fallbackDisplayName: ""),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        )
        
        // ID not found, display name not found
        XCTAssertNil(
            elements.first(whereUniqueID: -2000, fallbackDisplayName: "6")
        )
        
        // ID not found, fall back to display name. but ignore empty strings.
        XCTAssertNil(
            elements.first(
                whereUniqueID: -2000,
                fallbackDisplayName: "",
                ignoringEmpty: true
            )
        )
    }
    
    // MARK: - first
    
    func testContainsWhereDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertTrue(
            elements.contains(whereDisplayName: "A")
        )
        
        XCTAssertTrue(
            elements.contains(whereDisplayName: "")
        )
        
        XCTAssertFalse(
            elements.contains(whereDisplayName: "E")
        )
    }
    
    func testContainsWhereDisplayNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertTrue(
            elements.contains(whereDisplayName: "", ignoringEmpty: false)
        )
        
        XCTAssertFalse(
            elements.contains(whereDisplayName: "", ignoringEmpty: true)
        )
    }
    
    func testContainsWhereUniqueID_fallbackDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        // prioritize unique ID
        XCTAssertTrue(
            elements.contains(whereUniqueID: -1002, fallbackDisplayName: "2")
        )
        
        XCTAssertTrue(
            elements.contains(whereUniqueID: -1002, fallbackDisplayName: "4")
        )
        
        XCTAssertTrue(
            elements.contains(whereUniqueID: -1002, fallbackDisplayName: "")
        )
        
        // ID not found, fall back to display name
        XCTAssertTrue(
            elements.contains(whereUniqueID: -2000, fallbackDisplayName: "4")
        )
        
        // ID not found, fall back to display name
        XCTAssertTrue(
            elements.contains(whereUniqueID: -2000, fallbackDisplayName: "")
        )
        
        // ID not found, display name not found
        XCTAssertFalse(
            elements.contains(whereUniqueID: -2000, fallbackDisplayName: "6")
        )
        
        // ID not found, fall back to display name. but ignore empty strings.
        XCTAssertFalse(
            elements.contains(
                whereUniqueID: -2000,
                fallbackDisplayName: "",
                ignoringEmpty: true
            )
        )
    }
    
    // MARK: - filter
    
    func testFilterDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.filter(whereDisplayName: "2"),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(whereDisplayName: ""),
            [
                .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(whereDisplayName: "5"),
            []
        )
    }
    
    func testFilterWhereDisplayNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.filter(whereDisplayName: "2", ignoringEmpty: true),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(whereDisplayName: "", ignoringEmpty: false),
            [
                .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(whereDisplayName: "", ignoringEmpty: true),
            []
        )
    }
}

#endif
