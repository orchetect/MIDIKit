//
//  PickersExampleView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO
import MIDIKitUI

struct PickersExampleView: View {
    @AppStorage("midiInput") private var midiInput: Int?
    @AppStorage("midiInputName") private var midiInputName: String?
    @AppStorage("midiOutput") private var midiOutput: Int?
    @AppStorage("midiOutputName") private var midiOutputName: String?
    
    @State private var pickerStyle: PickerStyleSelection = .automatic
    @State private var showIcons: Bool = true
    @State private var singleColumn: Bool = true
    
    var body: some View {
        viewLayout
        
        Spacer()
        
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            Toggle("Single Column", isOn: $singleColumn)
                .toggleStyle(.switch)
                .frame(width: 200)
            
        }
#endif
            
        Toggle("Show Icons", isOn: $showIcons)
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
            selection: intAdapter($midiInput),
            cachedSelectionName: $midiInputName,
            showIcons: showIcons
        )
        .pickerStyle(selection: pickerStyle)
    }
    
    private var outputsList: some View {
        MIDIOutputsPicker(
            title: "Output",
            selection: intAdapter($midiOutput),
            cachedSelectionName: $midiOutputName,
            showIcons: showIcons
        )
        .pickerStyle(selection: pickerStyle)
    }
}

extension View {
    @ViewBuilder
    fileprivate func pickerStyle(selection: PickerStyleSelection) -> some View {
        switch selection {
        case .automatic:
            self.pickerStyle(.automatic)
        case .inline:
            self.pickerStyle(.inline)
        case .menu:
            self.pickerStyle(.menu)
#if os(macOS)
        case .radioGroup:
            self.pickerStyle(.radioGroup)
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
