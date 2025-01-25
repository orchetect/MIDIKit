//
//  Endpoint Hashable Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import Testing

@Suite struct Endpoint_Hashable_Tests {
    @Test
    func inputEndpoint1() {
        let same: Set<MIDIInputEndpoint> = [
            .init(from: 123),
            .init(from: 123)
        ]
        
        #expect(same.count == 1)
    }
    
    @Test
    func inputEndpoint1B() {
        let same: Set<MIDIInputEndpoint> = [
            .init(from: 123),
            .init(from: 456)
        ]
        
        // even with different ref IDs, since these don't actually currently
        // exist in the system, their Unique IDs will both be 0 and thus equal
        #expect(same.count == 1)
    }
    
    @Test
    func inputEndpoint2() {
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
        
        #expect(same.count == 1)
    }
    
    @Test
    func inputEndpoint2Diff() {
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
        
        #expect(same.count == 2)
    }
    
    @Test
    func outputEndpoint1() {
        let same: Set<MIDIOutputEndpoint> = [
            .init(from: 123),
            .init(from: 123)
        ]
        
        #expect(same.count == 1)
    }
    
    @Test
    func outputEndpoint1B() {
        let same: Set<MIDIOutputEndpoint> = [
            .init(from: 123),
            .init(from: 456)
        ]
        
        // even with different ref IDs, since these don't actually currently
        // exist in the system, their Unique IDs will both be 0 and thus equal
        #expect(same.count == 1)
    }
    
    @Test
    func outputEndpoint2() {
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
        
        #expect(same.count == 1)
    }
    
    @Test
    func outputEndpoint2Diff() {
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
        
        #expect(same.count == 2)
    }
}

#endif
