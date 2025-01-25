//
//  MIDIManager MIDIIONotification Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitIO
import Testing

@Suite(.serialized) @MainActor class MIDIManager_MIDIIONotification_Tests {
    fileprivate var notifications: [MIDIIONotification] = []
}

// MARK: - Tests

extension MIDIManager_MIDIIONotification_Tests {
    @Test
    func systemNotification_Add_Remove() async throws {
        // allow time for cleanup from previous unit tests, in case
        // MIDI endpoints are still being disposed of by Core MIDI
        try await Task.sleep(seconds: 0.500)
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit",
            notificationHandler: { notification, manager in
                // handler is called on main thread
                self.notifications.append(notification)
            }
        )
        
        // start midi client
        try manager.start()
        
        try await Task.sleep(seconds: 0.500)
        #expect(notifications == [])
        
        notifications = []
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 1",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        
        try await wait(require: { await notifications.count >= 3 }, timeout: 0.5)
        try await Task.sleep(seconds: 0.100)
        
        var addedNotifFound = false
        for notif in notifications {
            switch notif {
            case .added(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    if endpoint.name == "MIDIKit IO Tests Source 1" {
                        addedNotifFound = true
                    }
                default:
                    Issue.record()
                }
            default: break
            }
        }
        #expect(addedNotifFound)
        
        notifications = []
        
        // remove output
        manager.remove(.output, .withTag(output1Tag))
        
        try await wait(require: { await notifications.count >= 2 }, timeout: 0.5)
        try await Task.sleep(seconds: 0.100)
        
        var removedNotifFound = false
        for notif in notifications {
            switch notif {
            case .removed(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    if endpoint.name == "MIDIKit IO Tests Source 1" {
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
        // allow time for cleanup from previous unit tests, in case
        // MIDI endpoints are still being disposed of by Core MIDI
        try await Task.sleep(seconds: 0.500)
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit",
            notificationHandler: { notification, manager in
                // handler is called on main thread
                self.notifications.append(notification)
            }
        )
        
        // start midi client
        try manager.start()
        
        try await Task.sleep(seconds: 0.500)
        #expect(notifications == [])
        
        notifications = []
        
        // create virtual outputs
        let output1Tag = "output1"
        let output1Name = "MIDIKit IO Tests Source 1"
        try manager.addOutput(
            name: output1Name,
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        
        let output2Tag = "output2"
        let output2Name = "MIDIKit IO Tests Source 2"
        try manager.addOutput(
            name: output2Name,
            tag: output2Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        
        // each port produces at least 3 notifications, plus `setupChanged`
        try await wait(require: { await notifications.count >= 6 }, timeout: 0.5)
        try await Task.sleep(seconds: 0.100)
        
        notifications = []
        
        // remove outputs
        manager.remove(.output, .withTag(output1Tag))
        manager.remove(.output, .withTag(output2Tag))
        
        try await wait(require: { await notifications.count >= 2 }, timeout: 0.5)
        try await Task.sleep(seconds: 0.100)
        
        var removedEndpoints: [MIDIOutputEndpoint] = []
        for notif in notifications {
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
        #expect(removedEndpoints.count == 2)
        
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
    //    // allow time for cleanup from previous unit tests, in case
    //    // MIDI endpoints are still being disposed of by Core MIDI
    //    try await Task.sleep(seconds: 0.500)
    //
    //    let manager = MIDIManager(
    //        clientName: UUID().uuidString,
    //        model: "MIDIKit123",
    //        manufacturer: "MIDIKit",
    //        notificationHandler: { notification, manager in
    //            print(notification)
    //        }
    //    )
    //
    //    // start midi client
    //    try manager.start()
    //
    //    print("Listening for Core MIDI notifications...")
    //    try await Task.sleep(seconds: 120.0) // listen for 2 minutes so it doesn't run indefinitely
    // }
}

#endif
