//
//  ListsExampleView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO
import MIDIKitUI

struct ListsExampleView: View {
    @AppStorage(MIDIHelper.PrefKeys.midiInID) private var midiInput: MIDIIdentifier?
    @AppStorage(MIDIHelper.PrefKeys.midiInName) private var midiInputName: String?
    @AppStorage(MIDIHelper.PrefKeys.midiOutID) private var midiOutput: MIDIIdentifier?
    @AppStorage(MIDIHelper.PrefKeys.midiOutName) private var midiOutputName: String?
    
    @State private var filterOwned: Bool = false
    @State private var showIcons: Bool = true
    
    var body: some View {
        viewLayout
            .padding()
            
        Spacer()
        
        VStack {
            // TODO: ⚠️ Not yet functional, will be fixed in future.
            Toggle("Filter Manager-Owned", isOn: $filterOwned)
                .disabled(true)
            
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
            Text("Note that these lists will not be selectable on iPhone, but are on iPad and macOS.")
            Text("For iOS it is recommended to use the `MIDI*putsPicker` variants instead of these.")
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
            selection: $midiInput,
            cachedSelectionName: $midiInputName,
            showIcons: showIcons,
            filterOwned: filterOwned
        )
#if os(macOS)
        .listStyle(.bordered(alternatesRowBackgrounds: true))
#endif
    }
    
    private var outputsList: some View {
        MIDIOutputsList(
            selection: $midiOutput,
            cachedSelectionName: $midiOutputName,
            showIcons: showIcons,
            filterOwned: filterOwned
        )
#if os(macOS)
        .listStyle(.bordered(alternatesRowBackgrounds: true))
#endif
    }
}
