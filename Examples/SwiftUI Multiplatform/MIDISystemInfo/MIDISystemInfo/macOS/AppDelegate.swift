//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    private let midiManager = ObservableObjectMIDIManager(
        clientName: "MIDISystemInfo",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // set up midi manager
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services: \(error.localizedDescription)")
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
        if #available(macOS 11.0, *) {
            window.toolbarStyle = .unified
            
            // force window to take on a unified title/toolbar look in the absence of toolbar content
            window.toolbar = .init()
        }
        
        window.contentView = NSHostingView(
            rootView: ContentViewForCurrentPlatform()
                .environmentObject(midiManager)
        )
        
        window.makeKeyAndOrderFront(nil)
    }
}
