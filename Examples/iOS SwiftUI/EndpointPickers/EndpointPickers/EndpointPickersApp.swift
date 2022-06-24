//
//  EndpointPickersApp.swift
//  EndpointPickers
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

@main
struct EndpointPickersApp: App {
    
    let midiManager = MIDI.IO.Manager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    @ObservedObject var midiHelper = MIDIHelper()
    
    @State var midiInSelectedID: MIDI.IO.UniqueID = 0
    @State var midiInSelectedDisplayName: String = "None"
    
    @State var midiOutSelectedID: MIDI.IO.UniqueID = 0
    @State var midiOutSelectedDisplayName: String = "None"
    
    init() {
        midiHelper.midiManager = midiManager
        midiHelper.initialSetup()
        
        // restore saved MIDI endpoint selections and connections
        midiRestorePersistentState()
        midiHelper.midiInUpdateConnection(selectedUniqueID: midiInSelectedID)
        midiHelper.midiOutUpdateConnection(selectedUniqueID: midiOutSelectedID)
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(
                midiInSelectedID: $midiInSelectedID,
                midiInSelectedDisplayName: $midiInSelectedDisplayName,
                midiOutSelectedID: $midiOutSelectedID,
                midiOutSelectedDisplayName: $midiOutSelectedDisplayName
            )
            .environmentObject(midiManager)
            .environmentObject(midiHelper)
        }
        
        .onChange(of: midiInSelectedID) {
            if $0 == 0 {
                midiInSelectedDisplayName = "None"
            } else if let found = midiManager.endpoints.outputs
                .first(whereUniqueID: .init($0))
            {
                midiInSelectedDisplayName = found.displayName
            }
            
            midiHelper.midiInUpdateConnection(selectedUniqueID: $0)
            midiSavePersistentState()
        }
        
        .onChange(of: midiOutSelectedID) {
            if $0 == 0 {
                midiOutSelectedDisplayName = "None"
            } else if let found = midiManager.endpoints.inputs
                .first(whereUniqueID: .init($0))
            {
                midiOutSelectedDisplayName = found.displayName
            }
            
            midiHelper.midiOutUpdateConnection(selectedUniqueID: $0)
            midiSavePersistentState()
        }
        
    }
    
}

// MARK: - String Constants

enum ConnectionTags {
    static let midiIn = "SelectedInputConnection"
    static let midiOut = "SelectedOutputConnection"
    
    static let midiTestIn1 = "TestIn1"
    static let midiTestIn2 = "TestIn2"
    static let midiTestOut1 = "TestOut1"
    static let midiTestOut2 = "TestOut2"
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
