//
//  AnyMIDIEndpoint Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import Foundation
@testable import MIDIKitIO
import Testing

@Suite(.serialized) struct AnyMIDIEndpoint_Tests {
    private final actor ManagerWrapper {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
    }
    
    @Test
    func anyMIDIEndpoint() async throws {
        let isStable = isSystemTimingStable()
        
        let mw = ManagerWrapper()
        
        // start midi client
        try mw.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // to properly test this, we need to actually
        // create a couple MIDI endpoints in the system first
        
        let kInputTag = "testInput-\(UUID().uuidString)"
        let kInputName = "MIDIKit Test Input \(kInputTag)"
        try mw.manager.addInput(
            name: kInputName,
            tag: kInputTag,
            uniqueID: .adHoc,
            receiver: .rawDataLogging()
        )
        
        let kOutputTag = "testOutput-\(UUID().uuidString)"
        let kOutputName = "MIDIKit Test Output \(kInputTag)"
        try mw.manager.addOutput(
            name: kOutputName,
            tag: kOutputTag,
            uniqueID: .adHoc
        )
        
        // input
        
        let inputUniqueID = try #require(mw.manager.managedInputs[kInputTag]?.uniqueID)
        #expect(inputUniqueID != .invalidMIDIIdentifier)
        await wait(expect: { mw.manager.endpoints.inputs.contains(whereUniqueID: inputUniqueID) }, timeout: isStable ? 2.0 : 10.0)
        let inputEndpoint = try #require(mw.manager.endpoints.inputs.first(whereUniqueID: inputUniqueID))
        
        let anyInput = AnyMIDIEndpoint(inputEndpoint)
        _ = inputEndpoint.asAnyEndpoint // also works
        #expect(anyInput.coreMIDIObjectRef == inputEndpoint.coreMIDIObjectRef)
        #expect(anyInput.name == kInputName)
        #expect(anyInput.endpointType == .input)
        
        // output
        
        let outputUniqueID = try #require(mw.manager.managedOutputs[kOutputTag]?.uniqueID)
        #expect(outputUniqueID != .invalidMIDIIdentifier)
        await wait(expect: { mw.manager.endpoints.outputs.contains(whereUniqueID: outputUniqueID) }, timeout: isStable ? 2.0 : 10.0)
        let outputEndpoint = try #require(mw.manager.endpoints.outputs.first(whereUniqueID: outputUniqueID))
        
        let anyOutput = AnyMIDIEndpoint(outputEndpoint)
        _ = outputEndpoint.asAnyEndpoint // also works
        #expect(outputEndpoint.coreMIDIObjectRef == anyOutput.coreMIDIObjectRef)
        #expect(anyOutput.name == kOutputName)
        #expect(anyOutput.endpointType == .output)
        
        // Collection
        
        let inputArray = [inputEndpoint]
        let inputArrayAsAnyEndpoints = inputArray.asAnyEndpoints()
        #expect(inputArrayAsAnyEndpoints.count == 1)
        #expect(
            inputArrayAsAnyEndpoints[0].coreMIDIObjectRef ==
                inputEndpoint.coreMIDIObjectRef
        )
        
        let outputArray = [outputEndpoint]
        let outputArrayAsAnyEndpoints = outputArray.asAnyEndpoints()
        #expect(outputArrayAsAnyEndpoints.count == 1)
        #expect(
            outputArrayAsAnyEndpoints[0].coreMIDIObjectRef ==
                outputEndpoint.coreMIDIObjectRef
        )
        
        let combined = inputArrayAsAnyEndpoints + outputArrayAsAnyEndpoints
        #expect(combined.count == 2)
        
        // AnyEndpoint from AnyEndpoint (just to check for crashes)
        let anyAny = AnyMIDIEndpoint(anyInput)
        #expect(anyAny.coreMIDIObjectRef == anyInput.coreMIDIObjectRef)
        #expect(anyAny.name == anyInput.name)
        #expect(anyAny.endpointType == .input)
        #expect(anyAny.uniqueID == anyInput.uniqueID)
    }
}

#endif
