//
//  Core MIDI Thru Connections Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite struct CoreMIDIThruConnectionsTests_Tests {
    @Test
    func parameters_CFData() throws {
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
        
        #expect(params1.numDestinations == 1)
        #expect(params1.destinations.0.endpointRef == 1_234_567)
        #expect(params1.destinations.0.uniqueID == 987_654_321)
        #expect(params1.numSources == 1)
        #expect(params1.sources.0.endpointRef == 1_234_568)
        #expect(params1.sources.0.uniqueID == 987_654_322)
        
        #expect(params1.filterOutAllControls == 0)
        #expect(params1.filterOutBeatClock == 1)
        #expect(params1.filterOutMTC == 1)
        #expect(params1.filterOutSysEx == 0)
        #expect(params1.filterOutTuneRequest == 1)
        
        // convert to CFData, init MIDIThruConnectionParams from it, and test
        
        let cfData = params1.cfData()
        
        let params2 = try #require(MIDIThruConnectionParams(cfData: cfData))
        
        #expect(params2.numDestinations == 1)
        #expect(params2.destinations.0.endpointRef == 1_234_567)
        #expect(params2.destinations.0.uniqueID == 987_654_321)
        #expect(params2.numSources == 1)
        #expect(params2.sources.0.endpointRef == 1_234_568)
        #expect(params2.sources.0.uniqueID == 987_654_322)
        
        #expect(params2.filterOutAllControls == 0)
        #expect(params2.filterOutBeatClock == 1)
        #expect(params2.filterOutMTC == 1)
        #expect(params2.filterOutSysEx == 0)
        #expect(params2.filterOutTuneRequest == 1)
    }
    
    @Test
    func midiThruConnectionParams_initCFData_MaxByteSize() {
        let cfData = Data(
            repeating: 0xFF,
            count: MemoryLayout<MIDIThruConnectionParams>.size
        ) as CFData
        
        let params = MIDIThruConnectionParams(cfData: cfData)
        
        #expect(params != nil)
    }
    
    @Test
    func midiThruConnectionParams_initCFData_TooManyBytes() {
        let cfData = Data(
            repeating: 0xFF,
            count: MemoryLayout<MIDIThruConnectionParams>.size + 1
        ) as CFData
        
        let params = MIDIThruConnectionParams(cfData: cfData)
        
        #expect(params == nil)
    }
}

#endif
