//
//  MIDIIOObject Collection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import XCTest

final class MIDIIOObject_Collection_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    // MARK: - sorted
    
    func testSortedByName() {
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
            elements.sortedByDisplayName(), // this works because it's an array of endpoints
            [
                .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
                .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002),
                .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000)
            ]
        )
    }
    
    // MARK: - first
    
    func testFirstWhereName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
    
        XCTAssertEqual(
            elements.first(whereName: "Port A"),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003)
        )
    
        XCTAssertNil(
            elements.first(whereName: "Port E")
        )
    }
    
    func testFirstWhereNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
    
        XCTAssertEqual(
            elements.first(whereName: "", ignoringEmpty: false),
            .init(ref: 1004, name: "", displayName: "", uniqueID: -1004)
        )
    
        XCTAssertNil(
            elements.first(whereName: "", ignoringEmpty: true)
        )
    }
    
    func testFirstWhereUniqueID() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
    
        XCTAssertEqual(
            elements.first(whereUniqueID: -1002),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
    
        XCTAssertNil(
            elements.first(whereUniqueID: -2000)
        )
    }
    
    // MARK: - contains
    
    func testContainsWhereName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
    
        XCTAssertTrue(
            elements.contains(whereName: "Port A")
        )
    
        XCTAssertFalse(
            elements.contains(whereName: "Port E")
        )
    }
    
    func testContainsWhereNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
    
        XCTAssertTrue(
            elements.contains(whereName: "", ignoringEmpty: false)
        )
    
        XCTAssertFalse(
            elements.contains(whereName: "", ignoringEmpty: true)
        )
    }
    
    func testContainsWhereUniqueID() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
    
        XCTAssertTrue(
            elements.contains(whereUniqueID: -1002)
        )
    
        XCTAssertFalse(
            elements.contains(whereUniqueID: -2000)
        )
    }
    
    // MARK: - filter
    
    func testFilterWhereName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
        ]
    
        XCTAssertEqual(
            elements.filter(whereName: "Port A"),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002)
            ]
        )
    
        XCTAssertEqual(
            elements.filter(whereName: ""),
            [
                .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
            ]
        )
    
        XCTAssertEqual(
            elements.filter(whereName: "Port D"),
            []
        )
    }
    
    func testFilterWhereNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
        ]
    
        XCTAssertEqual(
            elements.filter(whereName: "Port A", ignoringEmpty: true),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002)
            ]
        )
    
        XCTAssertEqual(
            elements.filter(whereName: "", ignoringEmpty: false),
            [
                .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
            ]
        )
    
        XCTAssertEqual(
            elements.filter(whereName: "", ignoringEmpty: true),
            []
        )
    }
}

#endif
