//
//  AppDelegate.swift
//  MIDIEventLogger
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import OTCore
import MIDIKit

@main
struct MIDIEventLogger: App {
    
    var midiManager: MIDI.IO.Manager = {
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
        
        return newManager
    }()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(midiManager)
        }
        
    }
    
}
