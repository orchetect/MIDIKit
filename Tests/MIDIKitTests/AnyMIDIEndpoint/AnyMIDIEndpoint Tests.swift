//
//  AnyMIDIEndpoint Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
@testable import MIDIKit

final class AnyMIDIEndpoint_Tests: XCTestCase {
    func testAnyMIDIEndpoint() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    
        // start midi client
        try manager.start()
        wait(sec: 0.1)
    
        // to properly test this, we need to actually
        // create a couple MIDI endpoints in the system first
    
        let kInputName = "MIDIKit Test Input"
        let kInputTag = "testInput"
        try manager.addInput(
            name: kInputName,
            tag: kInputTag,
            uniqueID: .adHoc,
            receiver: .rawDataLogging()
        )
    
        let kOutputName = "MIDIKit Test Output"
        let kOutputTag = "testOutput"
        try manager.addOutput(
            name: kOutputName,
            tag: kOutputTag,
            uniqueID: .adHoc
        )
    
        // have to give Core MIDI a bit of time to create the ports (async)
        wait(sec: 1.0)
    
        // input
    
        guard let inputUniqueID = manager.managedInputs[kInputTag]?.uniqueID,
              let inputEndpoint = manager.endpoints.inputs.first(whereUniqueID: inputUniqueID)
        else { XCTFail(); return }
    
        let anyInput = AnyMIDIEndpoint(inputEndpoint)
        _ = inputEndpoint.asAnyEndpoint // also works
        XCTAssertEqual(anyInput.coreMIDIObjectRef, inputEndpoint.coreMIDIObjectRef)
        XCTAssertEqual(anyInput.name, kInputName)
        XCTAssertEqual(anyInput.endpointType, .input)
    
        // output
    
        guard let outputUniqueID = manager.managedOutputs[kOutputTag]?.uniqueID,
              let outputEndpoint = manager.endpoints.outputs
                  .first(whereUniqueID: outputUniqueID)
        else { XCTFail(); return }
    
        let anyOutput = AnyMIDIEndpoint(outputEndpoint)
        _ = outputEndpoint.asAnyEndpoint // also works
        XCTAssertEqual(outputEndpoint.coreMIDIObjectRef, anyOutput.coreMIDIObjectRef)
        XCTAssertEqual(anyOutput.name, kOutputName)
        XCTAssertEqual(anyOutput.endpointType, .output)
    
        // Collection
    
        let inputArray = [inputEndpoint]
        let inputArrayAsAnyEndpoints = inputArray.asAnyEndpoints()
        XCTAssertEqual(inputArrayAsAnyEndpoints.count, 1)
        XCTAssertEqual(
            inputArrayAsAnyEndpoints[0].coreMIDIObjectRef,
            inputEndpoint.coreMIDIObjectRef
        )
    
        let outputArray = [outputEndpoint]
        let outputArrayAsAnyEndpoints = outputArray.asAnyEndpoints()
        XCTAssertEqual(outputArrayAsAnyEndpoints.count, 1)
        XCTAssertEqual(
            outputArrayAsAnyEndpoints[0].coreMIDIObjectRef,
            outputEndpoint.coreMIDIObjectRef
        )
    
        let combined = inputArrayAsAnyEndpoints + outputArrayAsAnyEndpoints
        XCTAssertEqual(combined.count, 2)
    
        // AnyEndpoint from AnyEndpoint (just to check for crashes)
        let anyAny = AnyMIDIEndpoint(anyInput)
        XCTAssertEqual(anyAny.coreMIDIObjectRef, anyInput.coreMIDIObjectRef)
        XCTAssertEqual(anyAny.name, anyInput.name)
        XCTAssertEqual(anyAny.endpointType, .input)
        XCTAssertEqual(anyAny.uniqueID, anyInput.uniqueID)
    }
}

#endif
