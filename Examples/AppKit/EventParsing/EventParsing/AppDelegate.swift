//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Cocoa

@main
final class AppDelegate: NSObject, NSApplicationDelegate, Sendable {
    let midiHelper = MIDIHelper(start: true)
    let model = Model()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMIDIHelper()
    }
}

extension AppDelegate {
    private func setupMIDIHelper() {
        midiHelper.setEventHandler { [weak self] event in
            // if the event may result in UI changes, we need to put it on the main actor/thread
            Task { @MainActor in
                self?.model.handle(event: event)
            }
        }
    }
}
