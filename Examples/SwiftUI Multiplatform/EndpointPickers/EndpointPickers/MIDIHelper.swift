//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Receiving MIDI happens on an asynchronous background thread. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class marked with `@Observable`
/// which contains properties that SwiftUI can use to update views.
@Observable @MainActor final class MIDIHelper {
    private weak var midiManager: ObservableMIDIManager?
    
    public private(set) var receivedEvents: [MIDIEvent] = []
    
    public var filterActiveSensingAndClock = false
    
    public init() { }
    
    public func setup(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
        
        // update a local property in response to when
        // MIDI devices/endpoints change in system
        midiManager.notificationHandler = { [weak self] notification in
            Task { @MainActor in
                switch notification {
                case .added, .removed, .propertyChanged:
                    self?.updateVirtualsExist()
                default:
                    break
                }
            }
        }
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        do {
            try midiManager.addInputConnection(
                to: .none,
                tag: Tags.midiIn,
                receiver: .events { [weak self] events, timeStamp, source in
                    Task { @MainActor in
                        self?.received(events: events)
                    }
                }
            )
            
            try midiManager.addOutputConnection(
                to: .none,
                tag: Tags.midiOut
            )
        } catch {
            print("Error creating MIDI connections:", error.localizedDescription)
        }
    }
    
    // MARK: Common Event Receiver
    
    private func received(events: [MIDIEvent]) {
        let events = filterActiveSensingAndClock
            ? events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
            : events
        
        // must update properties that result in UI changes on main thread
        Task { @MainActor in
            self.receivedEvents.append(contentsOf: events)
        }
    }
    
    // MARK: - MIDI Input Connection
    
    public var midiInputConnection: MIDIInputConnection? {
        midiManager?.managedInputConnections[Tags.midiIn]
    }
    
    // MARK: - MIDI Output Connection
    
    public var midiOutputConnection: MIDIOutputConnection? {
        midiManager?.managedOutputConnections[Tags.midiOut]
    }
    
    // MARK: - Test Virtual Endpoints
    
    public var midiTestIn1: MIDIInput? {
        midiManager?.managedInputs[Tags.midiTestIn1]
    }
    
    public var midiTestIn2: MIDIInput? {
        midiManager?.managedInputs[Tags.midiTestIn2]
    }
    
    public var midiTestOut1: MIDIOutput? {
        midiManager?.managedOutputs[Tags.midiTestOut1]
    }
    
    public var midiTestOut2: MIDIOutput? {
        midiManager?.managedOutputs[Tags.midiTestOut2]
    }
    
    public func createVirtualEndpoints() {
        do {
            try midiManager?.addInput(
                name: "Test In 1",
                tag: Tags.midiTestIn1,
                uniqueID: .userDefaultsManaged(key: Tags.midiTestIn1),
                receiver: .events { [weak self] events, timeStamp, source in
                    Task { @MainActor in
                        self?.received(events: events)
                    }
                }
            )
            
            try midiManager?.addInput(
                name: "Test In 2",
                tag: Tags.midiTestIn2,
                uniqueID: .userDefaultsManaged(key: Tags.midiTestIn2),
                receiver: .events { [weak self] events, timeStamp, source in
                    Task { @MainActor in
                        self?.received(events: events)
                    }
                }
            )
            
            try midiManager?.addOutput(
                name: "Test Out 1",
                tag: Tags.midiTestOut1,
                uniqueID: .userDefaultsManaged(key: Tags.midiTestOut1)
            )
            
            try midiManager?.addOutput(
                name: "Test Out 2",
                tag: Tags.midiTestOut2,
                uniqueID: .userDefaultsManaged(key: Tags.midiTestOut2)
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func destroyVirtualInputs() {
        midiManager?.remove(.input, .all)
        midiManager?.remove(.output, .all)
    }
    
    public private(set) var virtualsExist: Bool = false
    
    private func updateVirtualsExist() {
        virtualsExist =
            midiTestIn1 != nil &&
            midiTestIn2 != nil &&
            midiTestOut1 != nil &&
            midiTestOut2 != nil
    }
}

// MARK: - String Constants

extension MIDIHelper {
    enum Tags {
        static let midiIn = "SelectedInputConnection"
        static let midiOut = "SelectedOutputConnection"
        
        static let midiTestIn1 = "TestIn1"
        static let midiTestIn2 = "TestIn2"
        static let midiTestOut1 = "TestOut1"
        static let midiTestOut2 = "TestOut2"
    }
    
    enum PrefKeys {
        static let midiInID = "SelectedMIDIInID"
        static let midiInDisplayName = "SelectedMIDIInDisplayName"
        
        static let midiOutID = "SelectedMIDIOutID"
        static let midiOutDisplayName = "SelectedMIDIOutDisplayName"
    }
    
    enum Defaults {
        static let selectedDisplayName = "None"
    }
}
