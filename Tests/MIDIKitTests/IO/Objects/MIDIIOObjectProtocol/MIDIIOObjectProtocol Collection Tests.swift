//
//  MIDIIOObjectProtocol Collection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class MIDIIOObjectProtocolCollectionTests: XCTestCase {
    
    // MARK: - sorted
    
    func testSortedByName() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
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
            ])
        
    }
    
    func testSortedByDisplayName() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000),
            .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002)
        ]
        
        XCTAssertEqual(
            elements.sortedByDisplayName(),
            [
                .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
                .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002),
                .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000)
            ])
        
    }
    
    // MARK: - first
    
    func testFirstWithName() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.first(withName: "Port A"),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003)
        )
        
        XCTAssertNil(
            elements.first(withName: "Port E")
        )
        
    }
    
    func testFirstWithNameIgnoringEmpty() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.first(withName: "", ignoringEmpty: false),
            .init(ref: 1004, name: "", displayName: "", uniqueID: -1004)
        )
        
        XCTAssertNil(
            elements.first(withName: "", ignoringEmpty: true)
        )
        
    }
    
    func testFirstWithDisplayName() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.first(withDisplayName: "A"),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003)
        )
        
        XCTAssertEqual(
            elements.first(withDisplayName: ""),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        )
        
        XCTAssertNil(
            elements.first(withDisplayName: "E")
        )
        
    }
    
    func testFirstWithDisplayNameIgnoringEmpty() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.first(withDisplayName: "", ignoringEmpty: false),
            .init(ref: 1004, name: "Port D", displayName: "", uniqueID: -1004)
        )
        
        XCTAssertNil(
            elements.first(withDisplayName: "", ignoringEmpty: true)
        )
        
    }
    
    func testFirstWhereUniqueID() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
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
    
    func testFirstWhereUniqueID_fallbackDisplayName() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
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
            elements.first(whereUniqueID: -2000,
                           fallbackDisplayName: "",
                           ignoringEmpty: true)
        )
        
    }
    
    // MARK: - filter
    
    func testFilterName() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.filter(name: "Port A"),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(name: ""),
            [
                .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(name: "Port D"),
            []
        )
        
    }
    
    func testFilterNameIgnoringEmpty() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.filter(name: "Port A", ignoringEmpty: true),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(name: "", ignoringEmpty: false),
            [
                .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(name: "", ignoringEmpty: true),
            []
        )
        
    }
    
    func testFilterDisplayName() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.filter(displayName: "2"),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(displayName: ""),
            [
                .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(displayName: "5"),
            []
        )
        
    }
    
    func testFilterDisplayNameIgnoringEmpty() {
        
        let elements: [MIDI.IO.InputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        XCTAssertEqual(
            elements.filter(displayName: "2", ignoringEmpty: true),
            [
                .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(displayName: "", ignoringEmpty: false),
            [
                .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
            ]
        )
        
        XCTAssertEqual(
            elements.filter(displayName: "", ignoringEmpty: true),
            []
        )
        
    }
    
}


// MARK: - Utility

extension MIDI.IO.InputEndpoint {
    
    /// Unit testing only: manually mock an endpoint with custom name, display name, and unique ID.
    internal init(ref: MIDI.IO.CoreMIDIEndpointRef,
                  name: String,
                  displayName: String,
                  uniqueID: UniqueID) {
        
        self.init(ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
        
    }
    
}

#endif
