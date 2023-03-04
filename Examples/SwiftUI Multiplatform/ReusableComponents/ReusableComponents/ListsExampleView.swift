//
//  ListsExampleView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO

struct ListsExampleView: View {
    @AppStorage("midiInput") private var midiInput: Int?
    @AppStorage("midiInputName") private var midiInputName: String?
    @AppStorage("midiOutput") private var midiOutput: Int?
    @AppStorage("midiOutputName") private var midiOutputName: String?
    
    @State private var showIcons: Bool = true
    
    var body: some View {
        viewLayout
            .padding()
            
        Spacer()
        
        Toggle("Show Icons", isOn: $showIcons)
            .toggleStyle(.switch)
            .frame(width: 150)
        
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
            selection: intAdapter($midiInput),
            cachedSelectionName: $midiInputName,
            showIcons: showIcons
        )
#if os(macOS)
        .listStyle(.bordered(alternatesRowBackgrounds: true))
#endif
    }
    
    private var outputsList: some View {
        MIDIOutputsList(
            selection: intAdapter($midiOutput),
            cachedSelectionName: $midiOutputName,
            showIcons: showIcons
        )
#if os(macOS)
        .listStyle(.bordered(alternatesRowBackgrounds: true))
#endif
    }
}
