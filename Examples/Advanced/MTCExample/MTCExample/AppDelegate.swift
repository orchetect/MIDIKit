//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import SwiftUI
import MIDIKitIO
import MIDIKitSync
import TimecodeKit
import OTCore

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let midiManager = MIDIManager(
        clientName: "MTCExample",
        model: "TestApp",
        manufacturer: "MyCompany"
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
        let contentView = MTCGenContentView()
            .environmentObject(midiManager)
        
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
        mtcGenWindow.isReleasedWhenClosed = true
        mtcGenWindow.setFrameAutosaveName("MTC Generator")
        mtcGenWindow.title = "MTC Generator"
        mtcGenWindow.contentView = NSHostingView(rootView: contentView)
        mtcGenWindow.makeKeyAndOrderFront(nil)
    }
    
    func createMTCRecWindow() {
        let contentView = MTCRecContentView()
            .environmentObject(midiManager)
        
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
        mtcRecWindow.isReleasedWhenClosed = true
        mtcRecWindow.setFrameAutosaveName("MTC Receiver")
        mtcRecWindow.title = "MTC Receiver"
        mtcRecWindow.contentView = NSHostingView(rootView: contentView)
        mtcRecWindow.makeKeyAndOrderFront(nil)
    }
}
