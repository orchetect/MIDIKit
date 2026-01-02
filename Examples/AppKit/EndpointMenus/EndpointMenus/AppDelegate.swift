//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import MIDIKitIO

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let prefs = AppPrefs()
    let midiHelper = MIDIHelper(start: true)
    var midiMenusHelper: MIDIMenusHelper?
    
    @IBOutlet var midiInMenu: NSMenu!
    @IBOutlet var midiOutMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // load saved connection states
        midiHelper.restorePersistentState(from: prefs)
        
        let midiMenusHelper = MIDIMenusHelper(
            midiHelper: midiHelper,
            prefs: prefs,
            midiInMenu: midiInMenu,
            midiOutMenu: midiOutMenu
        )
        self.midiMenusHelper = midiMenusHelper
        
        midiMenusHelper.start()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }
}

// MARK: - Menu Action First Responder Receivers

extension AppDelegate {
    @objc @MainActor
    func midiInMenuItemSelected(_ sender: NSMenuItem?) {
        midiMenusHelper?.midiInMenuItemSelected(sender)
    }
    
    @objc @MainActor
    func midiOutMenuItemSelected(_ sender: NSMenuItem?) {
        midiMenusHelper?.midiOutMenuItemSelected(sender)
    }
}

// MARK: - Test MIDI Event Send

extension AppDelegate {
    func send(event: MIDIEvent) {
        try? midiHelper.outputConnection?.send(event: event)
    }
    
    @IBAction
    func sendNoteOn(_ sender: Any) {
        send(event: .noteOn(
            60,
            velocity: .midi1(127),
            channel: 0
        ))
    }
    
    @IBAction
    func sendNoteOff(_ sender: Any) {
        send(event: .noteOff(
            60,
            velocity: .midi1(0),
            channel: 0
        ))
    }
    
    @IBAction
    func sendCC1(_ sender: Any) {
        send(event: .cc(
            1,
            value: .midi1(64),
            channel: 0
        ))
    }
}
