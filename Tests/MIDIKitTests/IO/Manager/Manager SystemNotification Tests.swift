//
//  Manager SystemNotification Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
import XCTestUtils
import MIDIKit
import CoreMIDI

final class Manager_SystemNotification_Tests: XCTestCase {
    
    fileprivate var notifications: [MIDI.IO.SystemNotification] = []
    
    func testSystemNotification_Add_Remove() throws {
        
        // allow time for cleanup from previous unit tests, in case
        // MIDI endpoints are still being disposed of by Core MIDI
        wait(sec: 0.5)
        
        let manager = MIDI.IO.Manager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit",
            notificationHandler: { notification, manager in
                self.notifications.append(notification)
            })
            
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
            uniqueID: .none // allow system to generate random ID
        )
        
        wait(for: notifications.count >= 3, timeout: 0.5)
        wait(sec: 0.1)
        
        var addedNotifFound = false
        notifications.forEach { notif in
            switch notif {
            case .added(parent: _,
                        child: let child):
                switch child {
                case .outputEndpoint(let endpoint):
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
            case .removed(parent: _,
                          child: let child):
                switch child {
                case .outputEndpoint(let endpoint):
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
