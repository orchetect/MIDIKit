//
//  AppDelegate.swift
//  MIDIKitTestHarness
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
		
		// Create the window and set the content view.
		window = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 950, height: 850),
			styleMask: [.titled, .miniaturizable, .resizable],
		    backing: .buffered, defer: false)
		
		// Create the SwiftUI view that provides the window contents.
		window.isReleasedWhenClosed = false
		
		window.center()
		window.setFrameAutosaveName("Main Window")
		
		window.contentView = {
			if #available(macOS 11.0, *) {
				
				// for Big Sur, demonstrate using @StateObject to hold the MIDI.IO.Manager in a subordinate scope and not in AppDelegate
				window.title = "MIDIKit Test Harness (Big Sur)"
				return NSHostingView(
					rootView: ContentViewBigSur()
						.environment(\.hostingWindow, { [weak window] in window })
				)
				
			} else {
				
				// for Catalina, since @StateObject is not available for use, demonstrate storing the MIDI.IO.Manager instance in AppDelegate and passing it by reference into ContentView's weak @ObservedObject storage.
				midiManager = {
					let newManager =
						MIDI.IO.Manager(clientName: "MIDIKitTestHarness",
										model: "TestApp",
										manufacturer: "Orchetect")
					do {
						Log.debug("Starting MIDI manager client")
						try newManager.start()
					} catch {
						Log.default(error)
					}
					
					return newManager
				}()
				
				window.title = "MIDIKit Test Harness (Catalina)"
				return NSHostingView(
					rootView: ContentViewCatalina(midiManager: midiManager!)
						.environment(\.hostingWindow, { [weak window] in window })
				)
				
			}
		}()
		
		window.makeKeyAndOrderFront(nil)
		
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}
