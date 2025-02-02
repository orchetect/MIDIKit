//
//  MIDIEndpoint Collection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import Testing

@Suite struct MIDIEndpoint_Collection_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    // MARK: - sorted
    
    @Test
    func sortedByDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000),
            .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002)
        ]
        
        #expect(
            elements.sortedByName() ==
                [
                    .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002),
                    .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000),
                    .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001)
                ]
        )
        
        #expect(
            elements.sortedByDisplayName() ==
                [
                    .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
                    .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002),
                    .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000)
                ]
        )
    }
    
    // MARK: - first
    
    @Test
    func firstWhereDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.first(whereDisplayName: "A") ==
                .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003)
        )
        
        #expect(
            elements.first(whereDisplayName: "") ==
                .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        )
        
        #expect(
            elements.first(whereDisplayName: "E") == nil
        )
    }
    
    @Test
    func firstWhereDisplayNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.first(whereDisplayName: "", ignoringEmpty: false) ==
                .init(ref: 1004, name: "Port D", displayName: "", uniqueID: -1004)
        )
        
        #expect(
            elements.first(whereDisplayName: "", ignoringEmpty: true) == nil
        )
    }
    
    @Test
    func firstWhereUniqueID_fallbackDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        // prioritize unique ID
        #expect(
            elements.first(whereUniqueID: -1002, fallbackDisplayName: "2") ==
                .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        #expect(
            elements.first(whereUniqueID: -1002, fallbackDisplayName: "4") ==
                .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        #expect(
            elements.first(whereUniqueID: -1002, fallbackDisplayName: "") ==
                .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        // ID not found, fall back to display name
        #expect(
            elements.first(whereUniqueID: -2000, fallbackDisplayName: "4") ==
                .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        // ID not found, fall back to display name
        #expect(
            elements.first(whereUniqueID: -2000, fallbackDisplayName: "") ==
                .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        )
        
        // ID not found, display name not found
        #expect(
            elements.first(whereUniqueID: -2000, fallbackDisplayName: "6") == nil
        )
        
        // ID not found, fall back to display name. but ignore empty strings.
        #expect(
            elements.first(
                whereUniqueID: -2000,
                fallbackDisplayName: "",
                ignoringEmpty: true
            ) == nil
        )
    }
    
    // MARK: - first
    
    @Test
    func containsWhereDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.contains(whereDisplayName: "A")
        )
        
        #expect(
            elements.contains(whereDisplayName: "")
        )
        
        #expect(
            !elements.contains(whereDisplayName: "E")
        )
    }
    
    @Test
    func containsWhereDisplayNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.contains(whereDisplayName: "", ignoringEmpty: false)
        )
        
        #expect(
            !elements.contains(whereDisplayName: "", ignoringEmpty: true)
        )
    }
    
    @Test
    func containsWhereUniqueID_fallbackDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        // prioritize unique ID
        #expect(
            elements.contains(whereUniqueID: -1002, fallbackDisplayName: "2")
        )
        
        #expect(
            elements.contains(whereUniqueID: -1002, fallbackDisplayName: "4")
        )
        
        #expect(
            elements.contains(whereUniqueID: -1002, fallbackDisplayName: "")
        )
        
        // ID not found, fall back to display name
        #expect(
            elements.contains(whereUniqueID: -2000, fallbackDisplayName: "4")
        )
        
        // ID not found, fall back to display name
        #expect(
            elements.contains(whereUniqueID: -2000, fallbackDisplayName: "")
        )
        
        // ID not found, display name not found
        #expect(
            !elements.contains(whereUniqueID: -2000, fallbackDisplayName: "6")
        )
        
        // ID not found, fall back to display name. but ignore empty strings.
        #expect(
            !elements.contains(
                whereUniqueID: -2000,
                fallbackDisplayName: "",
                ignoringEmpty: true
            )
        )
    }
    
    // MARK: - filter
    
    @Test
    func filterDisplayName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.filter(whereDisplayName: "2") ==
                [
                    .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                    .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002)
                ]
        )
        
        #expect(
            elements.filter(whereDisplayName: "") ==
                [
                    .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
                ]
        )
        
        #expect(
            elements.filter(whereDisplayName: "5") ==
                []
        )
    }
    
    @Test
    func filterWhereDisplayNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002),
            .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.filter(whereDisplayName: "2", ignoringEmpty: true) ==
                [
                    .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                    .init(ref: 1002, name: "Port A", displayName: "2", uniqueID: -1002)
                ]
        )
        
        #expect(
            elements.filter(whereDisplayName: "", ignoringEmpty: false) ==
                [
                    .init(ref: 1004, name: "Port D", displayName: "",  uniqueID: -1004)
                ]
        )
        
        #expect(
            elements.filter(whereDisplayName: "", ignoringEmpty: true) ==
                []
        )
    }
}

#endif
