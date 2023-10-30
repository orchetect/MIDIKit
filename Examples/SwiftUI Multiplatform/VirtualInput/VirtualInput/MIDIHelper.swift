//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import SwiftUI

/// Receiving MIDI happens as an asynchronous background callback. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class that conforms to
/// `ObservableObject` which contains `@Published` properties that SwiftUI can use to update views.
final class MIDIHelper: ObservableObject {
    private weak var midiManager: MIDIManager?
    
    public init() { }
    
    public func setup(midiManager: MIDIManager) {
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
                receiver: .eventsLogging(options: [.filterActiveSensingAndClock])
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    }
}
