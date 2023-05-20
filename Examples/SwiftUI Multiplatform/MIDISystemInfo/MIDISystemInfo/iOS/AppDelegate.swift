//
//  AppDelegate.swift
//  iOS-SwiftUI-AppDelegate-Template
//
//  Created by Steffan Andrews on 2023-02-14.
//

import UIKit
import MIDIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let midiManager = MIDIManager(
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
            print("Starting MIDI manager")
            try Self.midiManager.start()
        } catch {
            print(error)
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
