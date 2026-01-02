//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let midiHelper = MIDIHelper(start: true)
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }
}

extension AppDelegate {
    func send(event: MIDIEvent) {
        try? midiHelper.virtualOutput?.send(event: event)
    }
    
    @IBAction
    func sendNoteOn(_ sender: Any) {
        send(event: .noteOn(
            60,
            velocity: .midi1(127),
            channel: 0
        ))
    }
    
    @IBAction
    func sendNoteOff(_ sender: Any) {
        send(event: .noteOff(
            60,
            velocity: .midi1(0),
            channel: 0
        ))
    }
    
    @IBAction
    func sendCC1(_ sender: Any) {
        send(event: .cc(
            1,
            value: .midi1(64),
            channel: 0
        ))
    }
}
