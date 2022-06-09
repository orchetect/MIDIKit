//
//  EndpointPickersApp.swift
//  EndpointPickers
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

@main
struct EndpointPickersApp: App {
    
    let midiManager = MIDI.IO.Manager(clientName: "TestAppMIDIManager",
                                      model: "TestApp",
                                      manufacturer: "MyCompany")
    
    @State var midiInSelectedID: MIDI.IO.CoreMIDIUniqueID = 0
    @State var midiInSelectedDisplayName: String = ""
    
    @State var midiOutSelectedID: MIDI.IO.CoreMIDIUniqueID = 0
    @State var midiOutSelectedDisplayName: String = ""
    
    init() {
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
            
            // set up input connection
            try midiManager.addInputConnection(
                toOutputs: [],
                tag: ConnectionTags.midiIn,
                receiveHandler: .eventsLogging(filterActiveSensingAndClock: true)
            )
            
            // set up output connection
            try midiManager.addOutputConnection(toInputs: [],
                                                tag: ConnectionTags.midiOut)
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        // restore saved MIDI endpoint selections and connections
        midiRestorePersistentState()
        midiInUpdateConnection()
        midiOutUpdateConnection()
        
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(
                midiInSelectedID: $midiInSelectedID,
                midiInSelectedDisplayName: $midiInSelectedDisplayName,
                midiOutSelectedID: $midiOutSelectedID,
                midiOutSelectedDisplayName: $midiOutSelectedDisplayName
            )
            .frame(width: 550, height: 375, alignment: .center)
            .environmentObject(midiManager)
        }
        
        .onChange(of: midiInSelectedID) {
            if $0 == 0 {
                midiInSelectedDisplayName = ""
            } else if let found = midiManager.endpoints.outputs
                .first(whereUniqueID: .init($0))
            {
                midiInSelectedDisplayName = found.displayName
            }
            
            midiInUpdateConnection()
            midiSavePersistentState()
        }
        
        .onChange(of: midiOutSelectedID) {
            if $0 == 0 {
                midiOutSelectedDisplayName = ""
            } else if let found = midiManager.endpoints.inputs
                .first(whereUniqueID: .init($0))
            {
                midiOutSelectedDisplayName = found.displayName
            }
            
            midiOutUpdateConnection()
            midiSavePersistentState()
        }
        
    }
    
}

// MARK: - String Constants

enum ConnectionTags {
    static let midiIn = "SelectedInputConnection"
    static let midiOut = "SelectedOutputConnection"
}

enum UserDefaultsKeys {
    static let midiInID = "SelectedMIDIInID"
    static let midiInDisplayName = "SelectedMIDIInDisplayName"
    
    static let midiOutID = "SelectedMIDIOutID"
    static let midiOutDisplayName = "SelectedMIDIOutDisplayName"
}

extension EndpointPickersApp {
    
    /// This should only be run once at app startup.
    private mutating func midiRestorePersistentState() {
        
        print("Restoring saved MIDI connections.")
        
        let inName = UserDefaults.standard.string(forKey: UserDefaultsKeys.midiInDisplayName) ?? ""
        _midiInSelectedDisplayName = State(wrappedValue: inName)
        
        let inID = Int32(exactly: UserDefaults.standard.integer(forKey: UserDefaultsKeys.midiInID)) ?? 0
        _midiInSelectedID = State(wrappedValue: inID)
        
        let outName = UserDefaults.standard.string(forKey: UserDefaultsKeys.midiOutDisplayName) ?? ""
        _midiOutSelectedDisplayName = State(wrappedValue: outName)
        
        let outID = Int32(exactly: UserDefaults.standard.integer(forKey: UserDefaultsKeys.midiOutID)) ?? 0
        _midiOutSelectedID = State(wrappedValue: outID)
        
    }
    
    public func midiSavePersistentState() {
        // save endpoint selection to UserDefaults
        
        UserDefaults.standard.set(midiInSelectedID,
                                  forKey: UserDefaultsKeys.midiInID)
        UserDefaults.standard.set(midiInSelectedDisplayName,
                                  forKey: UserDefaultsKeys.midiInDisplayName)
        
        UserDefaults.standard.set(midiOutSelectedID,
                                  forKey: UserDefaultsKeys.midiOutID)
        UserDefaults.standard.set(midiOutSelectedDisplayName,
                                  forKey: UserDefaultsKeys.midiOutDisplayName)
    }
    
}

// MARK: - MIDI In

extension EndpointPickersApp {
    
    var midiInputConnection: MIDI.IO.InputConnection? {
        midiManager.managedInputConnections[ConnectionTags.midiIn]
    }
    
    /// Set the selected MIDI output manually.
    public func midiInSetSelected(id: MIDI.IO.CoreMIDIUniqueID,
                                  displayName: String) {
        midiInSelectedDisplayName = displayName
        midiInSelectedID = id
    }
    
    fileprivate func midiInUpdateConnection() {
        guard let midiInputConnection = midiInputConnection else { return }
        
        if midiInSelectedID == 0 {
            midiInputConnection.removeAllOutputs()
        } else {
            let uID = MIDI.IO.OutputEndpoint.UniqueID(midiInSelectedID)
            if midiInputConnection.outputsCriteria != [.uniqueID(uID)] {
                midiInputConnection.removeAllOutputs()
                midiInputConnection.add(outputs: [.uniqueID(uID)])
            }
        }
    }
    
}

// MARK: - MIDI Out

extension EndpointPickersApp {
    
    var midiOutputConnection: MIDI.IO.OutputConnection? {
        midiManager.managedOutputConnections[ConnectionTags.midiOut]
    }
    
    public func midiOutSetSelected(id: MIDI.IO.CoreMIDIUniqueID,
                                   displayName: String) {
        midiOutSelectedDisplayName = displayName
        midiOutSelectedID = id
    }
    
    fileprivate func midiOutUpdateConnection() {
        guard let midiOutputConnection = midiOutputConnection else { return }
        
        if midiOutSelectedID == 0 {
            midiOutputConnection.removeAllInputs()
        } else {
            let uID = MIDI.IO.InputEndpoint.UniqueID(midiOutSelectedID)
            if midiOutputConnection.inputsCriteria != [.uniqueID(uID)] {
                midiOutputConnection.removeAllInputs()
                midiOutputConnection.add(inputs: [.uniqueID(uID)])
            }
        }
    }
    
}
