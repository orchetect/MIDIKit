//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTCore
import MIDIKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    let midiManager = MIDIManager(
        clientName: "MIDIEventLogger",
        model: "LoggerApp",
        manufacturer: "MyCompany"
    ) { notification, manager in
        print("Core MIDI notification:", notification)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do {
            logger.debug("Starting MIDI manager")
            try midiManager.start()
        } catch {
            logger.default(error)
        }
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
            .environmentObject(midiManager)
    
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .miniaturizable, .resizable],
            backing: .buffered, defer: false
        )
        window.isReleasedWhenClosed = true
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
}
