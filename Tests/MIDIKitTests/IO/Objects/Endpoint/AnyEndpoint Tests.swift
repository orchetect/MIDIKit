//
//  AnyEndpoint Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
@testable import MIDIKit

class AnyEndpoint_Tests: XCTestCase {
    
    var manager: MIDI.IO.Manager! = nil
    
    override func setUp() {
        manager = .init(clientName: "MIDIKit_IO_AnyEndpoint_Tests",
                        model: "",
                        manufacturer: "")
        
        guard let _ = try? manager.start() else {
            XCTFail("Couldn't start MIDI.IO.Manager.")
            return
        }
    }
    
    override func tearDown() {
        manager = nil
    }
    
    func testAnyEndpoint() throws {
        
        // to properly test this, we need to actually
        // create a couple MIDI endpoints in the system first
        
        let kInputName = "MIDIKit Test Input"
        let kInputTag = "testInput"
        try manager.addInput(name: kInputName,
                             tag: kInputTag,
                             uniqueID: .none,
                             receiveHandler: .rawDataLogging())
        
        let kOutputName = "MIDIKit Test Output"
        let kOutputTag = "testOutput"
        try manager.addOutput(name: kOutputName,
                              tag: kOutputTag,
                              uniqueID: .none)
        
        // have to give CoreMIDI a bit of time to create the ports (async)
        XCTWait(sec: 1.0)
        
        // input
        
        guard let inputUniqueID = manager.managedInputs[kInputTag]?.uniqueID,
              let inputEndpoint = manager.endpoints.inputs.first(whereUniqueID: inputUniqueID)
        else { XCTFail() ; return }
        
        let anyInput = MIDI.IO.AnyEndpoint(inputEndpoint)
        _ = inputEndpoint.asAnyEndpoint // also works
        XCTAssertEqual(anyInput.coreMIDIObjectRef, inputEndpoint.coreMIDIObjectRef)
        XCTAssertEqual(anyInput.name, kInputName)
        XCTAssertEqual(anyInput.endpointType, .input)
        
        // output
        
        guard let outputUniqueID = manager.managedOutputs[kOutputTag]?.uniqueID,
              let outputEndpoint = manager.endpoints.outputs.first(whereUniqueID: outputUniqueID)
        else { XCTFail() ; return }
        
        let anyOutput = MIDI.IO.AnyEndpoint(outputEndpoint)
        _ = outputEndpoint.asAnyEndpoint // also works
        XCTAssertEqual(outputEndpoint.coreMIDIObjectRef, anyOutput.coreMIDIObjectRef)
        XCTAssertEqual(anyOutput.name, kOutputName)
        XCTAssertEqual(anyOutput.endpointType, .output)
        
        // Collection
        
        let inputArray = [inputEndpoint]
        let inputArrayAsAnyEndpoints = inputArray.asAnyEndpoints
        XCTAssertEqual(inputArrayAsAnyEndpoints.count, 1)
        XCTAssertEqual(inputArrayAsAnyEndpoints[0].coreMIDIObjectRef, inputEndpoint.coreMIDIObjectRef)
        
        let outputArray = [outputEndpoint]
        let outputArrayAsAnyEndpoints = outputArray.asAnyEndpoints
        XCTAssertEqual(outputArrayAsAnyEndpoints.count, 1)
        XCTAssertEqual(outputArrayAsAnyEndpoints[0].coreMIDIObjectRef, outputEndpoint.coreMIDIObjectRef)
        
        let combined = inputArrayAsAnyEndpoints + outputArrayAsAnyEndpoints
        XCTAssertEqual(combined.count, 2)
        
        // AnyEndpoint from AnyEndpoint (just to check for crashes)
        let anyAny = MIDI.IO.AnyEndpoint(anyInput)
        XCTAssertEqual(anyAny.coreMIDIObjectRef, anyInput.coreMIDIObjectRef)
        XCTAssertEqual(anyAny.name, anyInput.name)
        XCTAssertEqual(anyAny.endpointType, .input)
        XCTAssertEqual(anyAny.uniqueID, anyInput.uniqueID)
        
    }
    
}
#endif
