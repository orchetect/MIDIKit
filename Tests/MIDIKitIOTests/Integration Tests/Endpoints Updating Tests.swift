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

@Suite(.serialized, .enabled(if: isSystemTimingStable()))
struct EndpointsUpdating_Tests {
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
        
        let isStable = isSystemTimingStable() // test de-flake for slow CI pipelines
        
        manager1 = MIDIManager(
            clientName: "EndpointsUpdating_Tests_Tests_1",
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        manager2 = MIDIManager(
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
        
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
        
        print("EndpointsUpdating_Tests init done")
    }
    
    @Test
    func endpointsUpdating() async throws {
        let isStable = isSystemTimingStable() // test de-flake for slow CI pipelines
        let timeout: TimeInterval = isStable ? 2.0 : 10.0
        
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
        let man1input1 = try #require(manager1.managedInputs[man1inputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        
        await wait(expect: { Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.inputsUnowned) == Set(existingInputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsOwned) == Set([man1input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        await wait(expect: { Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.inputsOwned) == Set([]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        // create an input in manager1
        try manager1.addInput(name: man1inputTag2, tag: man1inputTag2, uniqueID: .adHoc, receiver: .eventsLogging())
        let man1input2 = try #require(manager1.managedInputs[man1inputTag2]).endpoint
        
        // check owned and unowned are being populated correctly
        await wait(expect: { Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.inputsUnowned) == Set(existingInputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        await wait(expect: { Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.inputsOwned) == Set([]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        // create an input in manager2
        try manager2.addInput(name: man2inputTag1, tag: man2inputTag1, uniqueID: .adHoc, receiver: .eventsLogging())
        let man2input1 = try #require(manager2.managedInputs[man2inputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        await wait(expect: { Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.inputsUnowned) == Set(existingInputs + [man2input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        await wait(expect: { Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.inputsOwned) == Set([man2input1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        // create an output in manager1
        try manager1.addOutput(name: man1outputTag1, tag: man1outputTag1, uniqueID: .adHoc)
        let man1output1 = try #require(manager1.managedOutputs[man1outputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        await wait(expect: { Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsUnowned) == Set(existingInputs + [man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputs) == Set(existingOutputs + [man1output1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsOwned) == Set([man1output1]) }, timeout: timeout) // <--
        
        await wait(expect: { Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.inputsOwned) == Set([man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputs) == Set(existingOutputs + [man1output1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs + [man1output1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        // create an output in manager2
        try manager2.addOutput(name: man2outputTag1, tag: man2outputTag1, uniqueID: .adHoc)
        let man2output1 = try #require(manager2.managedOutputs[man2outputTag1]).endpoint
        
        // check owned and unowned are being populated correctly
        await wait(expect: { Set(manager1.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsUnowned) == Set(existingInputs + [man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsOwned) == Set([man1input1, man1input2]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputs) == Set(existingOutputs + [man1output1, man2output1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs + [man2output1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager1.endpoints.outputsOwned) == Set([man1output1]) }, timeout: timeout)
        
        await wait(expect: { Set(manager2.endpoints.inputs) == Set(existingInputs + [man1input1, man1input2, man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.inputsUnowned) == Set(existingInputs + [man1input1, man1input2]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.inputsOwned) == Set([man2input1]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputs) == Set(existingOutputs + [man1output1, man2output1]) }, timeout: timeout) // <--
        await wait(expect: { Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs + [man1output1]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsOwned) == Set([man2output1]) }, timeout: timeout) // <--
        
        // remove all owned inputs and outputs, effectively resetting to the test's starting state
        manager1.remove(.input, .withTag(man1inputTag1))
        manager1.remove(.input, .withTag(man1inputTag2))
        manager1.remove(.output, .withTag(man1outputTag1))
        manager2.remove(.input, .withTag(man2inputTag1))
        manager2.remove(.output, .withTag(man2outputTag1))
        
        // check owned and unowned are being populated correctly
        await wait(expect: { Set(manager1.endpoints.inputs) == Set(existingInputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsUnowned) == Set(existingInputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.inputsOwned) == Set([]) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager1.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
        
        await wait(expect: { Set(manager2.endpoints.inputs) == Set(existingInputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.inputsUnowned) == Set(existingInputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.inputsOwned) == Set([]) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputs) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsUnowned) == Set(existingOutputs) }, timeout: timeout)
        await wait(expect: { Set(manager2.endpoints.outputsOwned) == Set([]) }, timeout: timeout)
    }
}

@Suite(.serialized, .enabled(if: isSystemTimingStable()))
struct EndpointsUpdating_Threading_Tests {
    private final actor ManagerWrapper {
        nonisolated let manager: MIDIManager
        init(manager: MIDIManager) { self.manager = manager }
    }
    
    @TestActor private final class NotificationReceiver {
        var notifications: [MIDIIONotification] = []
        func add(notification: MIDIIONotification) { notifications.append(notification) }
        func reset() { notifications.removeAll() }
        nonisolated init() { }
    }
    
    static let managerClasses: [() -> MIDIManager] = [
        { MIDIManager(clientName: "MIDIKit_Tests_1", model: "MIDIKit123", manufacturer: "MIDIKit") },
        { ObservableObjectMIDIManager(clientName: "MIDIKit_Tests_2", model: "MIDIKit123", manufacturer: "MIDIKit") },
        { ObservableMIDIManager(clientName: "MIDIKit_Tests_3", model: "MIDIKit123", manufacturer: "MIDIKit") }
    ]
    
    /// Test reading and writing endpoints from different threads.
    /// - Note: This test requires the Thread Sanitizer to be enabled in the Test Plan.
    @Test(.serialized, arguments: managerClasses)
    func endpointsUpdating_threading(managerGenerator: () -> MIDIManager) async throws {
        let isStable = isSystemTimingStable() // test de-flake for slow CI pipelines
        let timeout: TimeInterval = isStable ? 2.0 : 10.0
        
        let queue1 = DispatchQueue.global() // DispatchQueue(label: "midikit-endpoints-q1", target: .global())
        let queue2 = DispatchQueue.main // DispatchQueue(label: "midikit-endpoints-q2", target: .main)
        
        let notificationReceiver = NotificationReceiver()
        
        let mw = ManagerWrapper(manager: managerGenerator())
        
        // start manager
        try queue1.sync {
            mw.manager.notificationHandler = { notification in
                print(notification)
                Task { await notificationReceiver.add(notification: notification) }
            }
            try mw.manager.start()
        }
        
        // read endpoints & devices on queue 1
        let _ = queue1.sync { mw.manager.endpoints.inputs }
        let _ = queue1.sync { mw.manager.endpoints.outputs }
        let _ = queue1.sync { mw.manager.devices.devices }
        
        // read endpoints & devices on queue 2
        let _ = queue2.sync { mw.manager.endpoints.inputs }
        let _ = queue2.sync { mw.manager.endpoints.outputs }
        let _ = queue2.sync { mw.manager.devices.devices }
        
        // create an endpoint in the system to trigger a Core MIDI notification
        print("Creating input")
        let inputTag = "input"
        try mw.manager.addInput(name: UUID().uuidString, tag: inputTag, uniqueID: .adHoc, receiver: .eventsLogging())
        let inputEndpoint = try #require(mw.manager.managedInputs[inputTag]).endpoint
        
        // wait for MIDI manager's internal notifications to update its endpoints.
        // this will happen on the thread that the manager was started on.
        try await wait(require: { mw.manager.endpoints.inputs.contains(inputEndpoint) }, timeout: timeout)
        
        // wait for MIDI manager's notification handler to pass us notifications in turn:
        print("Waiting for input creation notifications")
        let inputAddNotifications: Set<MIDIIONotification> = [
            .added(object: inputEndpoint.asAnyMIDIIOObject(), parent: nil),
            .propertyChanged(property: .model, forObject: inputEndpoint.asAnyMIDIIOObject()),
            .propertyChanged(property: .manufacturer, forObject: inputEndpoint.asAnyMIDIIOObject()),
            .setupChanged
        ]
        await wait(
            expect: { await Set(notificationReceiver.notifications) == inputAddNotifications },
            timeout: timeout,
            "\(await notificationReceiver.notifications)"
        )
        await notificationReceiver.reset()
        
        // attempt to read the endpoints from a different thread than the one that was used to update them.
        
        // read endpoints & devices on queue 1
        let _ = queue1.sync { mw.manager.endpoints.inputs }
        let _ = queue1.sync { mw.manager.endpoints.outputs }
        let _ = queue1.sync { mw.manager.devices.devices }
        
        // read endpoints & devices on queue 2
        let _ = queue2.sync { mw.manager.endpoints.inputs }
        let _ = queue2.sync { mw.manager.endpoints.outputs }
        let _ = queue2.sync { mw.manager.devices.devices }
        
        // cleanup and wait for notifications
        #expect(await notificationReceiver.notifications == [])
        print("Removing input")
        mw.manager.remove(.input, .withTag(inputTag))
        print("Waiting for removal notifications")
        let removalNotifications: Set<MIDIIONotification> = [
            .removed(object: inputEndpoint.asAnyMIDIIOObject(), parent: nil),
            .setupChanged
        ]
        await wait(
            expect: { await Set(notificationReceiver.notifications) == removalNotifications },
            timeout: timeout,
            "\(await notificationReceiver.notifications)"
        )
        await notificationReceiver.reset()
        mw.manager.notificationHandler = nil
        
        // wait briefly for any additional Core MIDI clean-up
        try await Task.sleep(seconds: 0.5)
    }
}


#endif
