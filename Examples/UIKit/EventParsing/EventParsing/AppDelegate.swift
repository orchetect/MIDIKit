//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, Sendable {
    let midiHelper = MIDIHelper(start: true)
    let model = Model()
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupMIDIHelper()
        
        return true
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
