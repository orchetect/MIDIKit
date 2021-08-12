//
//  AppDelegate.swift
//  MIDIEventLogger
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import OTCore
import MIDIKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    fileprivate(set) var midiManager: MIDI.IO.Manager?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Configure console logging
        Log.setup(enabled: true,
                  defaultLog: nil,
                  defaultSubsystem: Globals.bundle.bundleID,
                  useEmoji: .all)
        
        // set up midi manager
        
        midiManager = {
            let newManager =
            MIDI.IO.Manager(clientName: "MIDIEventLogger",
                            model: "LoggerApp",
                            manufacturer: "Orchetect")
            do {
                Log.debug("Starting MIDI manager client")
                try newManager.start()
            } catch {
                Log.default(error)
            }
            
            return newManager
        }()
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0,
                                y: 0,
                                width: ContentView.kMinHeight,
                                height: ContentView.kMinWidth),
            styleMask: [.titled, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        
        // Create the SwiftUI view that provides the window contents.
        window.isReleasedWhenClosed = false
        
        window.center()
        window.setFrameAutosaveName("Main Window")
        
        window.title = "MIDIKit Event Logger"
        window.contentView = NSHostingView(
            rootView: ContentView(midiManager: midiManager!)
                .environment(\.hostingWindow, { [weak window] in window })
        )
        
        window.makeKeyAndOrderFront(nil)
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}
