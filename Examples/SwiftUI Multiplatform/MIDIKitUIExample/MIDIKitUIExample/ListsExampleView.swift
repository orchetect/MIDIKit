//
//  ListsExampleView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import MIDIKitUI
import SwiftUI

struct ListsExampleView: View {
    @AppStorage(MIDIHelper.PrefKeys.midiInID) private var midiInput: MIDIIdentifier?
    @AppStorage(MIDIHelper.PrefKeys.midiInName) private var midiInputName: String?
    @AppStorage(MIDIHelper.PrefKeys.midiOutID) private var midiOutput: MIDIIdentifier?
    @AppStorage(MIDIHelper.PrefKeys.midiOutName) private var midiOutputName: String?
    
    @State private var hideCreated: Bool = false
    @State private var showIcons: Bool = true
    
    var body: some View {
        viewLayout
            .padding()
            
        Spacer()
        
        VStack {
            Toggle("Hide Created", isOn: $hideCreated)
            Toggle("Show Icons", isOn: $showIcons)
        }
        .toggleStyle(.switch)
        .frame(width: 200)
        
        Text("Inputs and Outputs lists allowing for a single selection or no selection.")
    }
    
    @ViewBuilder
    private var viewLayout: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            iPhoneView
        } else {
            standardView
        }
        #else
        standardView
        #endif
    }
    
    @ViewBuilder
    private var iPhoneView: some View {
        Form {
            Section("Inputs") {
                inputsList
            }
            Section("Outputs") {
                outputsList
            }
        }
        Group {
            Text(
                "Note that these lists will not be selectable on iPhone, but are on iPad and macOS."
            )
            Text(
                "For iOS it is recommended to use the `MIDI*putsPicker` variants instead of these."
            )
        }
        .multilineTextAlignment(.center)
    }
    
    private var standardView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Input").font(.title)
                inputsList
            }
            VStack(alignment: .leading) {
                Text("Output").font(.title)
                outputsList
            }
        }
    }
    
    private var inputsList: some View {
        MIDIInputsList(
            selectionID: $midiInput,
            selectionDisplayName: $midiInputName,
            showIcons: showIcons,
            hideOwned: hideCreated
        )
        // note: supply a non-nil tag to auto-update an output connection in MIDIManager
        .updatingOutputConnection(withTag: nil)
        
        #if os(macOS)
        .listStyle(.bordered(alternatesRowBackgrounds: true))
        #endif
    }
    
    private var outputsList: some View {
        MIDIOutputsList(
            selectionID: $midiOutput,
            selectionDisplayName: $midiOutputName,
            showIcons: showIcons,
            hideOwned: hideCreated
        )
        // note: supply a non-nil tag to auto-update an input connection in MIDIManager
        .updatingInputConnection(withTag: nil)
        
        #if os(macOS)
        .listStyle(.bordered(alternatesRowBackgrounds: true))
        #endif
    }
}
