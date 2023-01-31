//
//  MIDIManager MIDIIONotification Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import XCTestUtils
import MIDIKitIO
import CoreMIDI

final class MIDIManager_MIDIIONotification_Tests: XCTestCase {
    fileprivate var notifications: [MIDIIONotification] = []
    
    func testSystemNotification_Add_Remove() throws {
        // allow time for cleanup from previous unit tests, in case
        // MIDI endpoints are still being disposed of by Core MIDI
        wait(sec: 0.5)
    
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit",
            notificationHandler: { notification, manager in
                self.notifications.append(notification)
            }
        )
    
        // start midi client
        try manager.start()
    
        wait(sec: 0.5)
        XCTAssertEqual(notifications, [])
    
        notifications = []
    
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests Source 1",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
    
        wait(for: notifications.count >= 3, timeout: 0.5)
        wait(sec: 0.1)
    
        var addedNotifFound = false
        notifications.forEach { notif in
            switch notif {
            case .added(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    if endpoint.name == "MIDIKit IO Tests Source 1" {
                        addedNotifFound = true
                    }
                default:
                    XCTFail()
                }
            default: break
            }
        }
        XCTAssertTrue(addedNotifFound)
    
        notifications = []
    
        // remove output
        manager.remove(.output, .withTag(output1Tag))
    
        wait(for: notifications.count >= 2, timeout: 0.5)
        wait(sec: 0.1)
    
        var removedNotifFound = false
        notifications.forEach { notif in
            switch notif {
            case .removed(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    if endpoint.name == "MIDIKit IO Tests Source 1" {
                        removedNotifFound = true
                    }
                default:
                    XCTFail()
                }
            default: break
            }
        }
        XCTAssertTrue(removedNotifFound)
    }
    
    /// Tests that the internal MIDI object cache works when receiving
    /// more than one `removed` notification sequentially.
    func testSystemNotification_SequentialRemove() throws {
        // allow time for cleanup from previous unit tests, in case
        // MIDI endpoints are still being disposed of by Core MIDI
        wait(sec: 0.5)
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit",
            notificationHandler: { notification, manager in
                self.notifications.append(notification)
            }
        )
        
        // start midi client
        try manager.start()
        
        wait(sec: 0.5)
        XCTAssertEqual(notifications, [])
        
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
        wait(for: notifications.count >= 6, timeout: 0.5)
        wait(sec: 0.1)
        
        notifications = []
        
        // remove outputs
        manager.remove(.output, .withTag(output1Tag))
        manager.remove(.output, .withTag(output2Tag))
        
        wait(for: notifications.count >= 2, timeout: 0.5)
        wait(sec: 0.1)
        
        var removedEndpoints: [MIDIOutputEndpoint] = []
        notifications.forEach { notif in
            switch notif {
            case .removed(object: let object, parent: _):
                switch object {
                case let .outputEndpoint(endpoint):
                    removedEndpoints.append(endpoint)
                default:
                    XCTFail()
                }
            default: break
            }
        }
        XCTAssertEqual(removedEndpoints.count, 2)
        
        // verify metadata is present and not empty/default
        let removedEndpoint1 = removedEndpoints[0]
        let removedEndpoint2 = removedEndpoints[1]
        
        XCTAssertEqual(removedEndpoint1.name, output1Name)
        XCTAssertNotEqual(removedEndpoint1.uniqueID, .invalidMIDIIdentifier)
        
        XCTAssertEqual(removedEndpoint2.name, output2Name)
        XCTAssertNotEqual(removedEndpoint2.uniqueID, .invalidMIDIIdentifier)
    }
    
    /// ⚠️ DEV TEST. This is NOT a unit test!
    /// ONLY uncomment to log Core MIDI notifications to the console as a diagnostic.
    // func testSystemNotificationLogger() throws {
    //    // allow time for cleanup from previous unit tests, in case
    //    // MIDI endpoints are still being disposed of by Core MIDI
    //    wait(sec: 0.5)
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
    //    wait(sec: 120) // listen for 2 minutes so it doesn't run indefinitely
    // }
}

#endif
