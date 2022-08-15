//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

class MIDIHelper: ObservableObject {
    public weak var midiManager: MIDIManager?
    
    @Published
    public private(set) var receivedEvents: [MIDIEvent] = []
    
    public init() { }
    
    /// Run once after setting the local `midiManager` property.
    public func initialSetup() {
        guard let midiManager = midiManager else {
            print("MIDIManager is missing.")
            return
        }
    
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    
        do {
            try midiManager.addInputConnection(
                toOutputs: [],
                tag: ConnectionTags.midiIn,
                receiveHandler: .events() { [weak self] events in
                    DispatchQueue.main.async {
                        self?.receivedEvents.append(contentsOf: events)
                    }
                }
            )
    
            try midiManager.addOutputConnection(
                toInputs: [],
                tag: ConnectionTags.midiOut
            )
        } catch {
            print("Error creating MIDI connections:", error.localizedDescription)
        }
    }
    
    // MARK: - MIDI In
    
    public var midiInputConnection: MIDIInputConnection? {
        midiManager?.managedInputConnections[ConnectionTags.midiIn]
    }
    
    public func midiInUpdateConnection(selectedUniqueID: MIDIIdentifier) {
        guard let midiInputConnection = midiInputConnection else { return }
    
        if selectedUniqueID == .invalidMIDIIdentifier {
            midiInputConnection.removeAllOutputs()
        } else {
            if midiInputConnection.outputsCriteria != [.uniqueID(selectedUniqueID)] {
                midiInputConnection.removeAllOutputs()
                midiInputConnection.add(outputs: [.uniqueID(selectedUniqueID)])
            }
        }
    }
    
    // MARK: - MIDI Out
    
    public var midiOutputConnection: MIDIOutputConnection? {
        midiManager?.managedOutputConnections[ConnectionTags.midiOut]
    }
    
    public func midiOutUpdateConnection(selectedUniqueID: MIDIIdentifier) {
        guard let midiOutputConnection = midiOutputConnection else { return }
    
        if selectedUniqueID == .invalidMIDIIdentifier {
            midiOutputConnection.removeAllInputs()
        } else {
            if midiOutputConnection.inputsCriteria != [.uniqueID(selectedUniqueID)] {
                midiOutputConnection.removeAllInputs()
                midiOutputConnection.add(inputs: [.uniqueID(selectedUniqueID)])
            }
        }
    }
    
    // MARK: - Test Virtual Endpoints
    
    public var midiTestIn1: MIDIInput? {
        midiManager?.managedInputs[ConnectionTags.midiTestIn1]
    }
    
    public var midiTestIn2: MIDIInput? {
        midiManager?.managedInputs[ConnectionTags.midiTestIn2]
    }
    
    public var midiTestOut1: MIDIOutput? {
        midiManager?.managedOutputs[ConnectionTags.midiTestOut1]
    }
    
    public var midiTestOut2: MIDIOutput? {
        midiManager?.managedOutputs[ConnectionTags.midiTestOut2]
    }
    
    public func createVirtualInputs() {
        try? midiManager?.addInput(
            name: "Test In 1",
            tag: ConnectionTags.midiTestIn1,
            uniqueID: .userDefaultsManaged(key: ConnectionTags.midiTestIn1),
            receiveHandler: .events() { [weak self] events in
                DispatchQueue.main.async {
                    self?.receivedEvents.append(contentsOf: events)
                }
            }
        )
    
        try? midiManager?.addInput(
            name: "Test In 2",
            tag: ConnectionTags.midiTestIn2,
            uniqueID: .userDefaultsManaged(key: ConnectionTags.midiTestIn2),
            receiveHandler: .events() { [weak self] events in
                DispatchQueue.main.async {
                    self?.receivedEvents.append(contentsOf: events)
                }
            }
        )
    
        try? midiManager?.addOutput(
            name: "Test Out 1",
            tag: ConnectionTags.midiTestOut1,
            uniqueID: .userDefaultsManaged(key: ConnectionTags.midiTestOut1)
        )
    
        try? midiManager?.addOutput(
            name: "Test Out 2",
            tag: ConnectionTags.midiTestOut2,
            uniqueID: .userDefaultsManaged(key: ConnectionTags.midiTestOut2)
        )
    }
    
    public func destroyVirtualInputs() {
        midiManager?.remove(.input, .all)
        midiManager?.remove(.output, .all)
    }
    
    public var virtualsExist: Bool {
        midiTestIn1 != nil &&
            midiTestIn2 != nil &&
            midiTestOut1 != nil &&
            midiTestOut2 != nil
    }
    
    // MARK: - Helpers
    
    public func isInputPresentInSystem(uniqueID: MIDIIdentifier) -> Bool {
        midiManager?.endpoints.inputs.contains(whereUniqueID: uniqueID) ?? false
    }
    
    public func isOutputPresentInSystem(uniqueID: MIDIIdentifier) -> Bool {
        midiManager?.endpoints.outputs.contains(whereUniqueID: uniqueID) ?? false
    }
}
