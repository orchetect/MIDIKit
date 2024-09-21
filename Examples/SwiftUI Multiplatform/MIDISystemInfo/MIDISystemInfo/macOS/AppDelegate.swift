//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
	
    private let midiManager = ObservableMIDIManager(
        clientName: "MIDISystemInfo",
        model: "TestApp",
        manufacturer: "MyCompany"
    )

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // set up midi manager
    
        do {
            print("Starting MIDI manager")
            try midiManager.start()
        } catch {
            print(error)
        }
    
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 950, height: 850),
            styleMask: [
                .titled,
                .unifiedTitleAndToolbar,
                .fullSizeContentView,
                .miniaturizable,
                .resizable
            ],
            backing: .buffered,
            defer: false
        )
    
        // Create the SwiftUI view that provides the window contents.
        window.isReleasedWhenClosed = false
    
        window.center()
        window.setFrameAutosaveName("Main Window")
    
        window.title = "MIDI System Info"
        
        window.contentView = NSHostingView(
            rootView: ContentViewForCurrentPlatform()
                .environmentObject(midiManager)
        )
    
        window.makeKeyAndOrderFront(nil)
    }
}
