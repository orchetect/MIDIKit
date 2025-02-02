//
//  MIDIIOObject Collection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import Testing

@Suite struct MIDIIOObject_Collection_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    // MARK: - sorted
    
    @Test
    func sortedByName() {
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
            elements.sortedByDisplayName() == // this works because it's an array of endpoints
                [
                    .init(ref: 1001, name: "C", displayName: "A", uniqueID: -1001),
                    .init(ref: 1002, name: "A", displayName: "B", uniqueID: -1002),
                    .init(ref: 1000, name: "B", displayName: "C", uniqueID: -1000)
                ]
        )
    }
    
    // MARK: - first
    
    @Test
    func firstWhereName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.first(whereName: "Port A") ==
                .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003)
        )
        
        #expect(
            elements.first(whereName: "Port E") == nil
        )
    }
    
    @Test
    func firstWhereNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.first(whereName: "", ignoringEmpty: false) ==
                .init(ref: 1004, name: "", displayName: "", uniqueID: -1004)
        )
        
        #expect(
            elements.first(whereName: "", ignoringEmpty: true) == nil
        )
    }
    
    @Test
    func firstWhereUniqueID() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.first(whereUniqueID: -1002) ==
                .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002)
        )
        
        #expect(
            elements.first(whereUniqueID: -2000) == nil
        )
    }
    
    // MARK: - contains
    
    @Test
    func containsWhereName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.contains(whereName: "Port A")
        )
        
        #expect(
            !elements.contains(whereName: "Port E")
        )
    }
    
    @Test
    func containsWhereNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.contains(whereName: "", ignoringEmpty: false)
        )
        
        #expect(
            !elements.contains(whereName: "", ignoringEmpty: true)
        )
    }
    
    @Test
    func containsWhereUniqueID() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "C", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "A", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "A", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "B", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "",  uniqueID: -1004)
        ]
        
        #expect(
            elements.contains(whereUniqueID: -1002)
        )
        
        #expect(
            !elements.contains(whereUniqueID: -2000)
        )
    }
    
    // MARK: - filter
    
    @Test
    func filterWhereName() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
        ]
        
        #expect(
            elements.filter(whereName: "Port A") ==
                [
                    .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                    .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002)
                ]
        )
        
        #expect(
            elements.filter(whereName: "") ==
                [
                    .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
                ]
        )
        
        #expect(
            elements.filter(whereName: "Port D") ==
                []
        )
    }
    
    @Test
    func filterWhereNameIgnoringEmpty() {
        let elements: [MIDIInputEndpoint] = [
            .init(ref: 1000, name: "Port B", displayName: "1", uniqueID: -1000),
            .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
            .init(ref: 1001, name: "Port C", displayName: "3", uniqueID: -1001),
            .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002),
            .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
        ]
        
        #expect(
            elements.filter(whereName: "Port A", ignoringEmpty: true) ==
                [
                    .init(ref: 1003, name: "Port A", displayName: "2", uniqueID: -1003),
                    .init(ref: 1002, name: "Port A", displayName: "4", uniqueID: -1002)
                ]
        )
        
        #expect(
            elements.filter(whereName: "", ignoringEmpty: false) ==
                [
                    .init(ref: 1004, name: "",       displayName: "5", uniqueID: -1004)
                ]
        )
        
        #expect(
            elements.filter(whereName: "", ignoringEmpty: true) ==
                []
        )
    }
}

#endif
