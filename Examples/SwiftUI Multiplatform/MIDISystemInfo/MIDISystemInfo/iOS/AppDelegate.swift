//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let midiManager = ObservableObjectMIDIManager(
        clientName: "MIDISystemInfo",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // set up midi manager
        
        do {
            print("Starting MIDI services.")
            try Self.midiManager.start()
        } catch {
            print("Error starting MIDI services: \(error.localizedDescription)")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // empty
    }
}
