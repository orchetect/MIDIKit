//
//  Endpoints Updating Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@MainActor @Suite(.serialized, .enabled(if: isSystemTimingStable()))
class EndpointsUpdating_Tests {
    fileprivate var manager1: MIDIManager!
    fileprivate var manager2: MIDIManager!
    
    fileprivate let man1inputTag1 = "MIDIKit Endpoints Updating In 1"
    fileprivate let man1inputTag2 = "MIDIKit Endpoints Updating In 2"
    fileprivate let man2inputTag1 = "MIDIKit Endpoints Updating In 3"
    fileprivate let man1outputTag1 = "MIDIKit Endpoints Updating Out 1"
    fileprivate let man2outputTag1 = "MIDIKit Endpoints Updating Out 2"
    
    // called before each method
    init() async throws {
        print("EndpointsUpdating_Tests init starting")
        
        let isPerformant = isSystemTimingStable() // test de-flake for slow CI pipelines
        
        try await Task.sleep(seconds: 0.500)
        
        manager1 = .init(
            clientName: "EndpointsUpdating_Tests_Tests_1",
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        manager2 = .init(
            clientName: "EndpointsUpdating_Tests_Tests_2",
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi clients
        
        do {
            try manager1.start()
            try manager2.start()
        } catch {
            Issue.record("Could not start MIDIManager. \(error.localizedDescription)")
            return
        }
        
        try await Task.sleep(seconds: isPerformant ? 0.5 : 2.0)
        
        print("EndpointsUpdating_Tests init done")
    }
    
    @Test
    func endpointsUpdating() async throws {
        let isPerformant = isSystemTimingStable() // test de-flake for slow CI pipelines
        
        // capture existing endpoints in the system, as these may vary depending on the CI system these tests run on.
        // this way we can account for them in the test.
        let existingInputs = manager1.endpoints.inputs
        let existingOutputs = manager1.endpoints.outputs
        
        // check owned and unowned are being populated correctly
        #expect(Set(manager1.endpoints.inputs) == Set(existingInputs))
        #expect(Set(manager1.endpoints.inputsUnowned) == Set(existingInputs))
        #expect(Set(manager1.endpoints.inputsOwned) == Set([]))
        #expect(Set(manager1.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsOwned) == Set([]))
        
        #expect(Set(manager2.endpoints.inputs) == Set(existingInputs))
        #expect(Set(manager2.endpoints.inputsUnowned) == Set(existingInputs))
        #expect(Set(manager2.endpoints.inputsOwned) == Set([]))
        #expect(Set(manager2.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsOwned) == Set([]))
        
        // create an input in manager1
        try manager1.addInput(name: man1inputTag1, tag: man1inputTag1, uniqueID: .adHoc, receiver: .eventsLogging())
        try await Task.sleep(seconds: isPerformant ? 0.3 : 2.0)
        let man1input1 = try #require(manager1.managedInputs[man1inputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        #expect(Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1])) // <--
        #expect(Set(manager1.endpoints.inputsUnowned) == Set(existingInputs))
        #expect(Set(manager1.endpoints.inputsOwned) == Set([man1input1])) // <--
        #expect(Set(manager1.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsOwned) == Set([]))
        
        #expect(Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1])) // <--
        #expect(Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1])) // <--
        #expect(Set(manager2.endpoints.inputsOwned) == Set([]))
        #expect(Set(manager2.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsOwned) == Set([]))
        
        // create an input in manager1
        try manager1.addInput(name: man1inputTag2, tag: man1inputTag2, uniqueID: .adHoc, receiver: .eventsLogging())
        try await Task.sleep(seconds: isPerformant ? 0.3 : 2.0)
        let man1input2 = try #require(manager1.managedInputs[man1inputTag2]).endpoint
        
        // check owned and unowned are being populated correctly
        #expect(Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2])) // <--
        #expect(Set(manager1.endpoints.inputsUnowned) == Set(existingInputs))
        #expect(Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2])) // <--
        #expect(Set(manager1.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsOwned) == Set([]))
        
        #expect(Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2])) // <--
        #expect(Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2])) // <--
        #expect(Set(manager2.endpoints.inputsOwned) == Set([]))
        #expect(Set(manager2.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsOwned) == Set([]))
        
        // create an input in manager2
        try manager2.addInput(name: man2inputTag1, tag: man2inputTag1, uniqueID: .adHoc, receiver: .eventsLogging())
        try await Task.sleep(seconds: isPerformant ? 0.3 : 2.0)
        let man2input1 = try #require(manager2.managedInputs[man2inputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        #expect(Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1])) // <--
        #expect(Set(manager1.endpoints.inputsUnowned) == Set(existingInputs + [man2input1])) // <--
        #expect(Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2]))
        #expect(Set(manager1.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsOwned) == Set([]))
        
        #expect(Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1])) // <--
        #expect(Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2]))
        #expect(Set(manager2.endpoints.inputsOwned) == Set([man2input1])) // <--
        #expect(Set(manager2.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsOwned) == Set([]))
        
        // create an output in manager1
        try manager1.addOutput(name: man1outputTag1, tag: man1outputTag1, uniqueID: .adHoc)
        try await Task.sleep(seconds: isPerformant ? 0.3 : 2.0)
        let man1output1 = try #require(manager1.managedOutputs[man1outputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        #expect(Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]))
        #expect(Set(manager1.endpoints.inputsUnowned) == Set(existingInputs + [man2input1]))
        #expect(Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2]))
        #expect(Set(manager1.endpoints.outputs) == Set(existingOutputs + [man1output1])) // <--
        #expect(Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsOwned) == Set([man1output1])) // <--
        
        #expect(Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]))
        #expect(Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2]))
        #expect(Set(manager2.endpoints.inputsOwned) == Set([man2input1]))
        #expect(Set(manager2.endpoints.outputs) == Set(existingOutputs + [man1output1])) // <--
        #expect(Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs + [man1output1])) // <--
        #expect(Set(manager2.endpoints.outputsOwned) == Set([]))
        
        // create an output in manager2
        try manager2.addOutput(name: man2outputTag1, tag: man2outputTag1, uniqueID: .adHoc)
        try await Task.sleep(seconds: isPerformant ? 0.3 : 2.0)
        let man2output1 = try #require(manager2.managedOutputs[man2outputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        #expect(Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]))
        #expect(Set(manager1.endpoints.inputsUnowned) == Set(existingInputs + [man2input1]))
        #expect(Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2]))
        #expect(Set(manager1.endpoints.outputs) == Set(existingOutputs + [man1output1, man2output1])) // <--
        #expect(Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs + [man2output1])) // <--
        #expect(Set(manager1.endpoints.outputsOwned) == Set([man1output1]))
        
        #expect(Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]))
        #expect(Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2]))
        #expect(Set(manager2.endpoints.inputsOwned) == Set([man2input1]))
        #expect(Set(manager2.endpoints.outputs) == Set(existingOutputs + [man1output1, man2output1])) // <--
        #expect(Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs + [man1output1]))
        #expect(Set(manager2.endpoints.outputsOwned) == Set([man2output1])) // <--
        
        // remove all owned inputs and outputs, effectively resetting to the test's starting state
        manager1.remove(.input, .withTag(man1inputTag1))
        manager1.remove(.input, .withTag(man1inputTag2))
        manager1.remove(.output, .withTag(man1outputTag1))
        manager2.remove(.input, .withTag(man2inputTag1))
        manager2.remove(.output, .withTag(man2outputTag1))
        try await Task.sleep(seconds: isPerformant ? 0.3 : 2.0)
        
        // check owned and unowned are being populated correctly
        #expect(Set(manager1.endpoints.inputs) == Set(existingInputs))
        #expect(Set(manager1.endpoints.inputsUnowned) == Set(existingInputs))
        #expect(Set(manager1.endpoints.inputsOwned) == Set([]))
        #expect(Set(manager1.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager1.endpoints.outputsOwned) == Set([]))
        
        #expect(Set(manager2.endpoints.inputs) == Set(existingInputs))
        #expect(Set(manager2.endpoints.inputsUnowned) == Set(existingInputs))
        #expect(Set(manager2.endpoints.inputsOwned) == Set([]))
        #expect(Set(manager2.endpoints.outputs) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs))
        #expect(Set(manager2.endpoints.outputsOwned) == Set([]))
    }
}

#endif
