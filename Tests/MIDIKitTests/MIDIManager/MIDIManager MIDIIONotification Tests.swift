//
//  MIDIManager MIDIIONotification Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import XCTestUtils
import MIDIKit
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
            case .added(
                parent: _,
                child: let child
            ):
                switch child {
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
            case .removed(
                parent: _,
                child: let child
            ):
                switch child {
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
}

#endif
