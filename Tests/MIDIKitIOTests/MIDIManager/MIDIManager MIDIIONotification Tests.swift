//
//  MIDIManager MIDIIONotification Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitIO
import Testing

// MARK: - Tests

@Suite(.serialized) struct MIDIManager_MIDIIONotification_Tests {
    @TestActor private final class Receiver {
        let manager: MIDIManager
        var notifications: [MIDIIONotification] = []
        
        func add(notification: MIDIIONotification) { notifications.append(notification) }
        func reset() { notifications.removeAll() }
        
        nonisolated init() {
            manager = MIDIManager(
                clientName: UUID().uuidString,
                model: "MIDIKit123",
                manufacturer: "MIDIKit"
            )
            manager.notificationHandler = { [weak self] notification in
                print(notification)
                Task { @TestActor in
                    self?.add(notification: notification)
                }
            }
        }
    }
    
    init() async throws {
        let isStable = isSystemTimingStable()
        
        // allow time for cleanup from previous unit tests, in case
        // MIDI endpoints are still being disposed of by Core MIDI
        try await Task.sleep(seconds: isStable ? 0.5 : 2.0)
    }
    
    @Test
    func systemNotification_Add_Remove() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // we don't expect any notifications to be generated simply by starting the manager
        #expect(await receiver.notifications == [])
        
        // create a virtual output
        let output1Tag = UUID().uuidString
        let output1Name = UUID().uuidString
        try receiver.manager.addOutput(
            name: output1Name,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        
        try await wait(require: { await receiver.notifications.count >= 3 }, timeout: 10.0)
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0) // in case more than anticipated notifications arrive
        
        var addedNotifFound = false
        for notif in await receiver.notifications {
            switch notif {
            case .added(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    if endpoint.name == output1Name {
                        addedNotifFound = true
                    }
                default:
                    Issue.record()
                }
            default: break
            }
        }
        #expect(addedNotifFound)
        
        await receiver.reset()
        
        // remove output
        receiver.manager.remove(.output, .withTag(output1Tag))
        
        try await wait(require: { await receiver.notifications.count >= 2 }, timeout: 10.0)
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0) // in case more than anticipated notifications arrive
        
        var removedNotifFound = false
        for notif in await receiver.notifications {
            switch notif {
            case .removed(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    if endpoint.name == output1Name {
                        removedNotifFound = true
                    }
                default:
                    Issue.record()
                }
            default: break
            }
        }
        #expect(removedNotifFound)
    }
    
    /// Tests that the internal MIDI object cache works when receiving
    /// more than one `removed` notification sequentially.
    @Test
    func systemNotification_SequentialRemove() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        // start midi client
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        // we don't expect any notifications to be generated simply by starting the manager
        #expect(await receiver.notifications == [])
        
        // create virtual outputs
        let output1Tag = UUID().uuidString
        let output1Name = UUID().uuidString
        try receiver.manager.addOutput(
            name: output1Name,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        
        let output2Tag = UUID().uuidString
        let output2Name = UUID().uuidString
        try receiver.manager.addOutput(
            name: output2Name,
            tag: output2Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        
        // each port produces at least 3 notifications, plus `setupChanged`
        try await wait(require: { await receiver.notifications.count >= 6 }, timeout: 10.0)
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0) // in case more than anticipated notifications arrive
        
        await receiver.reset()
        
        // remove output1
        receiver.manager.remove(.output, .withTag(output1Tag))
        
        // pause between, just in case notifications are processed out-of-order, since we want to test deterministic ordering of these
        try await Task.sleep(seconds: isStable ? 0.3 : 1.0)
        
        // remove output2
        receiver.manager.remove(.output, .withTag(output2Tag))
        
        try await wait(require: {
            await receiver.notifications.filter { $0.isCase(.removed) }.count >= 2
        }, timeout: 10.0)
        
        var removedEndpoints: [MIDIOutputEndpoint] = []
        for notif in await receiver.notifications {
            switch notif {
            case .removed(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    removedEndpoints.append(endpoint)
                default:
                    Issue.record()
                }
            default: break
            }
        }
        try #require(removedEndpoints.count == 2)
        
        // verify metadata is present and not empty/default
        let removedEndpoint1 = removedEndpoints[0]
        let removedEndpoint2 = removedEndpoints[1]
        
        #expect(removedEndpoint1.name == output1Name)
        #expect(removedEndpoint1.uniqueID != .invalidMIDIIdentifier)
        
        #expect(removedEndpoint2.name == output2Name)
        #expect(removedEndpoint2.uniqueID != .invalidMIDIIdentifier)
    }
    
    /// ⚠️ DEV TEST. This is NOT a unit test!
    /// ONLY uncomment to log Core MIDI notifications to the console as a diagnostic.
    // @Test
    // func systemNotificationLogger() async throws {
    //    // start midi client
    //    try receiver.manager.start()
    //
    //    print("Listening for Core MIDI notifications...")
    //    try await Task.sleep(seconds: 120.0) // listen for 2 minutes so it doesn't run indefinitely
    // }
}

#endif
