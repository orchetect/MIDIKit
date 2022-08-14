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
    var window: NSWindow!
	
    fileprivate(set) var midiManager: MIDIManager?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // set up midi manager
        
        midiManager = {
            let newManager =
                MIDIManager(
                    clientName: "MIDISystemInfo",
                    model: "TestApp",
                    manufacturer: "Orchetect"
                )
            do {
                logger.debug("Starting MIDI manager client")
                try newManager.start()
            } catch {
                logger.default(error)
            }
            
            return newManager
        }()
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 950, height: 850),
            styleMask: [.titled, .miniaturizable, .resizable],
            backing: .buffered, defer: false
        )
        
        // Create the SwiftUI view that provides the window contents.
        window.isReleasedWhenClosed = false
        
        window.center()
        window.setFrameAutosaveName("Main Window")
        
        window.title = "MIDIKit System Info"
        window.contentView = NSHostingView(
            rootView: ContentView(midiManager: midiManager!)
                .environment(\.hostingWindow) { [weak window] in window }
        )
        
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
