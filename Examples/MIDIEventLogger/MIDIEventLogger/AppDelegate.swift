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
        
        // set up midi manager
        
        midiManager = {
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
            
            #warning("> TODO: remove this")
            //newManager.preferredAPI = .newCoreMIDI
            
            return newManager
        }()
        
        guard let unwrappedMIDIManager = midiManager
        else { return }
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0,
                                y: 0,
                                width: ContentView.kMinWidth,
                                height: ContentView.kMinHeight),
            styleMask: [.titled, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        // Create the SwiftUI view that provides the window contents.
        window.isReleasedWhenClosed = true
        
        window.center()
        window.setFrameAutosaveName("Main Window")
        
        window.title = "MIDIKit Event Logger"
        window.contentView = NSHostingView(
            rootView: ContentView(midiManager: unwrappedMIDIManager)
        )
        
        window.makeKeyAndOrderFront(nil)
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}
