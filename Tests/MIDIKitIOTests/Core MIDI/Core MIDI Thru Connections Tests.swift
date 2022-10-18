//
//  Core MIDI Thru Connections Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKitIO
import CoreMIDI

final class CoreMIDIThruConnectionsTests_Tests: XCTestCase {
    func testParameters_CFData() throws {
        // set up original parameters
    
        var params = MIDIThruConnection.Parameters()
    
        let input = MIDIInputEndpoint(
            ref: 1_234_567,
            name: "TestInput",
            displayName: "TestInput",
            uniqueID: 987_654_321
        )
    
        let output = MIDIOutputEndpoint(
            ref: 1_234_568,
            name: "TestOutput",
            displayName: "TestOutput",
            uniqueID: 987_654_322
        )
    
        params.filterOutAllControls = false
        params.filterOutBeatClock = true
        params.filterOutMTC = true
        params.filterOutSysEx = false
        params.filterOutTuneRequest = true
    
        // convert to Core MIDI MIDIThruConnectionParams and test
    
        let params1 = params.coreMIDIThruConnectionParams(
            inputs: [input],
            outputs: [output]
        )
    
        XCTAssertEqual(params1.numDestinations, 1)
        XCTAssertEqual(params1.destinations.0.endpointRef, 1_234_567)
        XCTAssertEqual(params1.destinations.0.uniqueID, 987_654_321)
        XCTAssertEqual(params1.numSources, 1)
        XCTAssertEqual(params1.sources.0.endpointRef, 1_234_568)
        XCTAssertEqual(params1.sources.0.uniqueID, 987_654_322)
    
        XCTAssertEqual(params1.filterOutAllControls, 0)
        XCTAssertEqual(params1.filterOutBeatClock, 1)
        XCTAssertEqual(params1.filterOutMTC, 1)
        XCTAssertEqual(params1.filterOutSysEx, 0)
        XCTAssertEqual(params1.filterOutTuneRequest, 1)
    
        // convert to CFData, init MIDIThruConnectionParams from it, and test
    
        let cfData = params1.cfData()
    
        let params2 = try XCTUnwrap(MIDIThruConnectionParams(cfData: cfData))
    
        XCTAssertEqual(params2.numDestinations, 1)
        XCTAssertEqual(params2.destinations.0.endpointRef, 1_234_567)
        XCTAssertEqual(params2.destinations.0.uniqueID, 987_654_321)
        XCTAssertEqual(params2.numSources, 1)
        XCTAssertEqual(params2.sources.0.endpointRef, 1_234_568)
        XCTAssertEqual(params2.sources.0.uniqueID, 987_654_322)
    
        XCTAssertEqual(params2.filterOutAllControls, 0)
        XCTAssertEqual(params2.filterOutBeatClock, 1)
        XCTAssertEqual(params2.filterOutMTC, 1)
        XCTAssertEqual(params2.filterOutSysEx, 0)
        XCTAssertEqual(params2.filterOutTuneRequest, 1)
    }
    
    func testMIDIThruConnectionParams_initCFData_MaxByteSize() {
        let cfData = Data(
            repeating: 0xFF,
            count: MemoryLayout<MIDIThruConnectionParams>.size
        ) as CFData
    
        let params = MIDIThruConnectionParams(cfData: cfData)
    
        XCTAssertNotNil(params)
    }
    
    func testMIDIThruConnectionParams_initCFData_TooManyBytes() {
        let cfData = Data(
            repeating: 0xFF,
            count: MemoryLayout<MIDIThruConnectionParams>.size + 1
        ) as CFData
    
        let params = MIDIThruConnectionParams(cfData: cfData)
    
        XCTAssertNil(params)
    }
}

#endif
