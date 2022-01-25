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
    
    var midiManager: MIDI.IO.Manager = {
        let newManager =
        MIDI.IO.Manager(clientName: "MIDIEventLogger",
                        model: "LoggerApp",
                        manufacturer: "Orchetect")
        do {
            logger.debug("Starting MIDI manager")
            try newManager.start()
        } catch {
            logger.default(error)
        }
        
//        #warning("> TODO: remove this")
//        newManager.preferredAPI = .legacyCoreMIDI
        
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
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
}
