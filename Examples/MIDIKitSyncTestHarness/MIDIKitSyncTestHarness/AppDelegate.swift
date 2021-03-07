//
//  AppDelegate.swift
//  MIDIKitSyncTestHarness
//
//  Created by Steffan Andrews on 2020-12-02.
//

import Cocoa
import SwiftUI

import OTCore
import MIDIKit
import TimecodeKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
    var window: NSWindow!
	
    func applicationDidFinishLaunching(_: Notification) {
		
        // log setup
        Log.setup(enabled: true,
                  defaultLog: nil,
                  defaultSubsystem: Globals.bundle.bundleID,
                  useEmoji: .all)
		
		// audio engine setup
		setupAudioEngine()
		
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 650, height: 375),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("MTC Receiver")
		window.title = "MTC Receiver"
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
		
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
	
}
