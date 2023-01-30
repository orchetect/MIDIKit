//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTCore
import MIDIKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
	
    private let midiManager = MIDIManager(
        clientName: "MIDISystemInfo",
        model: "TestApp",
        manufacturer: "MyCompany"
    )

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // set up midi manager
    
        do {
            logger.debug("Starting MIDI manager client")
            try midiManager.start()
        } catch {
            logger.default(error)
        }
    
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 950, height: 850),
            styleMask: [.titled, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
    
        // Create the SwiftUI view that provides the window contents.
        window.isReleasedWhenClosed = false
    
        window.center()
        window.setFrameAutosaveName("Main Window")
    
        window.title = "MIDIKit System Info"
        
        window.contentView = NSHostingView(
            rootView: platformAppropriateContentView()
                .environmentObject(midiManager)
                .environment(\.hostingWindow) { [weak window] in window }
        )
    
        window.makeKeyAndOrderFront(nil)
    }
}
