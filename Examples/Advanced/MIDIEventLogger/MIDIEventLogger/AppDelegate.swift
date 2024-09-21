//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import OTCore
import SwiftUI

// AppDelegate for legacy macOS versions support
@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    
    let midiManager = ObservableMIDIManager(
        clientName: "MIDIEventLogger",
        model: "LoggerApp",
        manufacturer: "MyCompany"
    )
    
    var midiHelper = MIDIHelper()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        midiHelper.setup(midiManager: midiManager)
        createAndShowWindow()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }
}

extension AppDelegate {
    func createAndShowWindow() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
            .environmentObject(midiManager)
            .environmentObject(midiHelper)
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .miniaturizable, .resizable],
            backing: .buffered, defer: false
        )
        window?.isReleasedWhenClosed = true
        window?.center()
        window?.setFrameAutosaveName("Main Window")
        window?.contentView = NSHostingView(rootView: contentView)
        window?.makeKeyAndOrderFront(nil)
    }
}
