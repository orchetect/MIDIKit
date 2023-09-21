//
//  PickersExampleView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import MIDIKitUI
import SwiftUI

struct PickersExampleView: View {
    @AppStorage(MIDIHelper.PrefKeys.midiInID) private var midiInput: MIDIIdentifier?
    @AppStorage(MIDIHelper.PrefKeys.midiInName) private var midiInputName: String?
    @AppStorage(MIDIHelper.PrefKeys.midiOutID) private var midiOutput: MIDIIdentifier?
    @AppStorage(MIDIHelper.PrefKeys.midiOutName) private var midiOutputName: String?
    
    @State private var pickerStyle: PickerStyleSelection = .automatic
    @State private var filterOwned: Bool = false
    @State private var showIcons: Bool = true
    @State private var singleColumn: Bool = true
    
    var body: some View {
        viewLayout
        
        Spacer()
        
        VStack {
            // TODO: ⚠️ Not yet functional, will be fixed in future.
            Toggle("Filter Manager-Owned", isOn: $filterOwned)
                .disabled(true)
            
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                Toggle("Single Column", isOn: $singleColumn)
            }
            #endif
            
            Toggle("Show Icons", isOn: $showIcons)
        }
        .toggleStyle(.switch)
        .frame(width: 200)
        
        Picker("Picker Style", selection: $pickerStyle) {
            ForEach(PickerStyleSelection.allCases) {
                Text($0.name).tag($0)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .frame(maxWidth: 400)
        
        Text("Inputs and Outputs pickers allowing for a single selection or 'None'.")
    }
    
    @ViewBuilder
    private var viewLayout: some View {
        #if os(iOS)
        if singleColumn {
            iPhoneView
        } else {
            standardView
        }
        #else
        standardView
        #endif
    }
    
    private var iPhoneView: some View {
        VStack {
            Form {
                Section("Input") {
                    if pickerStyle == .inline {
                        inputsList
                            .labelsHidden()
                    } else {
                        inputsList
                    }
                }
                Section("Output") {
                    if pickerStyle == .inline {
                        outputsList
                            .labelsHidden()
                    } else {
                        outputsList
                    }
                }
            }
        }
    }
    
    private var standardView: some View {
        HStack(alignment: .top, spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Input").font(.title)
                    inputsList
                }
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Output").font(.title)
                    outputsList
                }
                Spacer()
            }
        }
        .padding()
    }
    
    private var inputsList: some View {
        MIDIInputsPicker(
            title: "Input",
            selection: $midiInput,
            cachedSelectionName: $midiInputName,
            showIcons: showIcons,
            filterOwned: filterOwned
        )
        .pickerStyle(selection: pickerStyle)
    }
    
    private var outputsList: some View {
        MIDIOutputsPicker(
            title: "Output",
            selection: $midiOutput,
            cachedSelectionName: $midiOutputName,
            showIcons: showIcons,
            filterOwned: filterOwned
        )
        .pickerStyle(selection: pickerStyle)
    }
}

extension View {
    @ViewBuilder
    fileprivate func pickerStyle(selection: PickerStyleSelection) -> some View {
        switch selection {
        case .automatic:
            pickerStyle(.automatic)
        case .inline:
            pickerStyle(.inline)
        case .menu:
            pickerStyle(.menu)
        #if os(macOS)
        case .radioGroup:
            pickerStyle(.radioGroup)
        #endif
        }
    }
}

private enum PickerStyleSelection: String, Identifiable, CaseIterable {
    case automatic = "Automatic"
    case inline = "Inline"
    case menu = "Menu"
    #if os(macOS)
    case radioGroup = "Radio Group"
    #endif
    
    var id: RawValue { rawValue }
    var name: String { id }
}

extension PickerStyle {
    fileprivate static var selectionOptions: [any PickerStyle] {
        #if os(macOS)
        [.automatic, .inline, .menu, .radioGroup]
        #else
        [.automatic, .inline, .menu]
        #endif
    }
}
