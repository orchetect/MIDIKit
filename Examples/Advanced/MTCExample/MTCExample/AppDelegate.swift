//
//  AppDelegate.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import SwiftUI
import MIDIKitIO
import MIDIKitSync
import TimecodeKit
import OTCore

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let midiManager: MIDIManager = .init(
        clientName: "MTCExample",
        model: "TestApp",
        manufacturer: "Orchetect",
        notificationHandler: nil
    )
    
    var mtcGenWindow: NSWindow!
    var mtcRecWindow: NSWindow!
    
    func applicationDidFinishLaunching(_: Notification) {
        // audio engine setup
        setupAudioEngine()
        
        // midi setup
        _ = try? midiManager.start()
        
        // create windows
        createMTCGenWindow()
        createMTCRecWindow()
    }
    
    func createMTCGenWindow() {
        // normally in SwiftUI we would pass midiManager in as an EnvironmentObject
        // but that only works on macOS 11.0+ and for sake of backwards compatibility
        // we will do it old-school weak delegate storage pattern
        let contentView = MTCGenContentView(midiManager: midiManager)
        
        // (X,Y coord 0,0 origin is bottom left of screen)
        let scrW = NSScreen.main?.frame.width ?? 0
        let scrH = NSScreen.main?.frame.height ?? 0
        
        mtcGenWindow = NSWindow(
            contentRect: NSRect(
                x: (scrW / 2) - 400 - 20,
                y: (scrH / 2) - 225,
                width: 400,
                height: 450
            ),
            styleMask: [.titled, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        mtcGenWindow.isReleasedWhenClosed = false
        // mtcGenWindow.setFrameAutosaveName("MTC Generator")
        mtcGenWindow.title = "MTC Generator"
        mtcGenWindow.contentView = NSHostingView(rootView: contentView)
        mtcGenWindow.makeKeyAndOrderFront(nil)
    }
    
    func createMTCRecWindow() {
        // normally in SwiftUI we would pass midiManager in as an EnvironmentObject
        // but that only works on macOS 11.0+ and for sake of backwards compatibility
        // we will do it old-school weak delegate storage pattern
        let contentView = MTCRecContentView(midiManager: midiManager)
        
        // (X,Y coord 0,0 origin is bottom left of screen)
        let scrW = NSScreen.main?.frame.width ?? 0
        let scrH = NSScreen.main?.frame.height ?? 0
        
        mtcRecWindow = NSWindow(
            contentRect: NSRect(
                x: (scrW / 2) + 20,
                y: (scrH / 2) - 200,
                width: 650,
                height: 375
            ),
            styleMask: [.titled, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        mtcRecWindow.isReleasedWhenClosed = false
        // mtcRecWindow.setFrameAutosaveName("MTC Receiver")
        mtcRecWindow.title = "MTC Receiver"
        mtcRecWindow.contentView = NSHostingView(rootView: contentView)
        mtcRecWindow.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}
