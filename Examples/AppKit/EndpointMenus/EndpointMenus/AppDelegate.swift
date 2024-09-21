//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import MIDIKitIO

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var midiInMenu: NSMenu!
    @IBOutlet var midiOutMenu: NSMenu!
    
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    var midiEndpointsMenusHelper: MIDIEndpointsMenusHelper?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        midiEndpointsMenusHelper = MIDIEndpointsMenusHelper(
            midiManager: midiManager,
            midiInMenu: midiInMenu,
            midiOutMenu: midiOutMenu
        )
        midiEndpointsMenusHelper?.setup()
        
        // restore endpoint selection saved to persistent storage
        midiEndpointsMenusHelper?.restorePersistentState()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // save endpoint selection to persistent storage
        midiEndpointsMenusHelper?.savePersistentState()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }
}

// MARK: - Menu Action First Responder Receivers

extension AppDelegate {
    @objc
    func midiInMenuItemSelected(_ sender: NSMenuItem?) {
        midiEndpointsMenusHelper?.midiInMenuItemSelected(sender)
    }
    
    @objc
    func midiOutMenuItemSelected(_ sender: NSMenuItem?) {
        midiEndpointsMenusHelper?.midiOutMenuItemSelected(sender)
    }
}

// MARK: - Test MIDI Event Send

extension AppDelegate {
    @IBAction
    func sendNoteOn(_ sender: Any) {
        try? midiEndpointsMenusHelper?.midiOutputConnection?.send(
            event: .noteOn(
                60,
                velocity: .midi1(127),
                channel: 0
            )
        )
    }
    
    @IBAction
    func sendNoteOff(_ sender: Any) {
        try? midiEndpointsMenusHelper?.midiOutputConnection?.send(
            event: .noteOff(
                60,
                velocity: .midi1(0),
                channel: 0
            )
        )
    }
    
    @IBAction
    func sendCC1(_ sender: Any) {
        try? midiEndpointsMenusHelper?.midiOutputConnection?.send(
            event: .cc(
                1,
                value: .midi1(64),
                channel: 0
            )
        )
    }
}
