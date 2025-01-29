//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Receiving MIDI happens on an asynchronous background thread. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class marked with `@Observable`
/// which contains properties that SwiftUI can use to update views.
@Observable final class MIDIHelper {
    private weak var midiManager: ObservableMIDIManager?
    
    public init() { }
    
    public func setup(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        addVirtualInput()
    }
    
    // MARK: - Virtual Endpoints
    
    static let virtualInputName = "TestApp Input"
    
    func addVirtualInput() {
        guard let midiManager else { return }
        do {
            print("Creating virtual MIDI input.")
            try midiManager.addInput(
                name: Self.virtualInputName,
                tag: Self.virtualInputName,
                uniqueID: .userDefaultsManaged(key: Self.virtualInputName),
                receiver: .eventsLogging(options: [
                    .bundleRPNAndNRPNDataEntryLSB,
                    .filterActiveSensingAndClock
                ])
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    }
}
