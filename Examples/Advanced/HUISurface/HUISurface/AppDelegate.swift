//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import SwiftUI
import MIDIKitIO

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    private let midiManager = MIDIManager(
        clientName: "HUISurface",
        model: "HUISurface",
        manufacturer: "Orchetect",
        notificationHandler: nil
    )
    
    func applicationDidFinishLaunching(_: Notification) {
        do {
            try midiManager.start()
        } catch {
            Logger.debug("Error setting up MIDI.")
        }
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(midiManager: midiManager)
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1180, height: 920),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        window.title = "HUI Surface"
        window.isReleasedWhenClosed = false
        window.center()
        //window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}
