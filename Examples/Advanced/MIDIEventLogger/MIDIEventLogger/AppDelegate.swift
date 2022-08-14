//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTCore
import MIDIKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var midiManager: MIDIManager = {
        let newManager = MIDIManager(
            clientName: "MIDIEventLogger",
            model: "LoggerApp",
            manufacturer: "Orchetect"
        ) { notification, manager in
            print("Core MIDI notification:", notification)
        }
        do {
            logger.debug("Starting MIDI manager")
            try newManager.start()
        } catch {
            logger.default(error)
        }
        
        // uncomment this to test different API versions or limit to MIDI 1.0 protocol
        // newManager.preferredAPI = .legacyCoreMIDI
        
        return newManager
    }()
    
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
            .environmentObject(midiManager)
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
}
