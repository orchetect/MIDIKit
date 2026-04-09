//
//  Endpoints Updating Threading Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator) && !GITHUB_ACTIONS

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite(.serialized, .enabled(if: isSystemTimingStable()))
struct EndpointsUpdating_Threading_Tests {
    protocol ManagerWrapperProtocol: Sendable {
        var manager: MIDIManager { get }
        init(manager: @Sendable () -> MIDIManager)
    }
    
    private final actor ManagerWrapperActor: ManagerWrapperProtocol {
        nonisolated let manager: MIDIManager
        init(manager: @Sendable () -> MIDIManager) { self.manager = manager() }
    }
    
    @MainActor private final class MainActorManagerWrapper: ManagerWrapperProtocol {
        nonisolated let manager: MIDIManager
        nonisolated init(manager: @Sendable () -> MIDIManager) { self.manager = manager() }
    }
    
    static let managerWrappers: [any ManagerWrapperProtocol.Type] = [ManagerWrapperActor.self, MainActorManagerWrapper.self]
    
    @TestActor private final class NotificationReceiver {
        var notifications: [MIDIIONotification] = []
        func add(notification: MIDIIONotification) { notifications.append(notification) }
        func reset() { notifications.removeAll() }
        nonisolated init() { }
    }
    
    static var managerGenerators: [@Sendable () -> MIDIManager] {
        var managers: [@Sendable () -> MIDIManager] = [
            { MIDIManager(clientName: "MIDIKit_Tests_1", model: "MIDIKit123", manufacturer: "MIDIKit") },
            { ObservableObjectMIDIManager(clientName: "MIDIKit_Tests_2", model: "MIDIKit123", manufacturer: "MIDIKit") },
        ]
        if #available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *) {
            managers.append({ ObservableMIDIManager(clientName: "MIDIKit_Tests_3", model: "MIDIKit123", manufacturer: "MIDIKit") })
        }
        return managers
    }
    
    struct TestArgument: Sendable, CustomStringConvertible {
        let name: String
        var managerWrapper: any ManagerWrapperProtocol.Type
        var managerGenerator: @Sendable () -> MIDIManager
        
        init(name: String, managerWrapper: any ManagerWrapperProtocol.Type, managerGenerator: @escaping @Sendable () -> MIDIManager) {
            self.name = name
            self.managerWrapper = managerWrapper
            self.managerGenerator = managerGenerator
        }
        
        var description: String { name }
    }
    
    static var testArguments: [TestArgument] {
        var args: [TestArgument] = []
        for managerWrapper in managerWrappers {
            for managerGenerator in managerGenerators {
                let name = "\(managerWrapper.self) \(type(of: managerGenerator()))"
                args.append(TestArgument(name: name, managerWrapper: managerWrapper, managerGenerator: managerGenerator))
            }
        }
        return args
    }
    
    let queue1 = DispatchQueue.global() // DispatchQueue(label: "midikit-endpoints-q1", target: .global())
    let queue2 = DispatchQueue.main // DispatchQueue(label: "midikit-endpoints-q2", target: .main)
    
    // MARK: - Test
    
    /// Test reading and writing endpoints from different threads.
    /// - Note: This test requires the Thread Sanitizer to be enabled in the Test Plan.
    @Test(.serialized, arguments: testArguments)
    func endpointsUpdating_threading(arg: TestArgument) async throws {
        let isStable = isSystemTimingStable() // test de-flake for slow CI pipelines
        let timeout: TimeInterval = isStable ? 2.0 : 10.0
        
        let wrapper = arg.managerWrapper
        let managerGenerator = arg.managerGenerator
        
        // ensure test does not continue if it's somehow being run on the main thread
        func isMainThread() -> Bool { Thread.isMainThread }
        try #require(!isMainThread())
        
        let mw = wrapper.init(manager: managerGenerator)
        let notificationReceiver = NotificationReceiver()
        
        // set up manager
        mw.manager.notificationHandler = { notification in
            print("- \(notification)")
            Task { await notificationReceiver.add(notification: notification) }
        }
        // start manager
        try mw.manager.start()
        
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
