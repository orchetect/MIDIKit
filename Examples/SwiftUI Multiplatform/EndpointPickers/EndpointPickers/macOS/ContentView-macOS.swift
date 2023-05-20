//
//  ContentView-macOS.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import SwiftUI
import MIDIKitIO

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    
    @Binding var midiOutSelectedID: MIDIIdentifier
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        VStack {
            Text(
                """
                This example demonstrates maintaining menus with MIDI endpoints in the system, allowing a single selection for each menu.
                
                Refer to this example's README.md file for important information.
                """
            )
            .font(.system(size: 14))
            .padding(5)
    
            GroupBox(label: Text("MIDI In Connection")) {
                MIDIInSelectionView(
                    midiInSelectedID: $midiInSelectedID,
                    midiInSelectedDisplayName: $midiInSelectedDisplayName
                )
                .padding([.leading, .trailing], 60)
                
                Toggle("Filter Active Sensing and Clock", isOn: $midiHelper.filterActiveSensingAndClock)
            }
            .padding(5)
    
            GroupBox(label: Text("MIDI Out Connection")) {
                MIDIOutSelectionView(
                    midiOutSelectedID: $midiOutSelectedID,
                    midiOutSelectedDisplayName: $midiOutSelectedDisplayName
                )
                .padding([.leading, .trailing], 60)
    
                HStack {
                    Button("Send Note On C3") {
                        sendToConnection(.noteOn(60, velocity: .midi1(127), channel: 0))
                    }
    
                    Button("Send Note Off C3") {
                        sendToConnection(.noteOff(60, velocity: .midi1(0), channel: 0))
                    }
    
                    Button("Send CC1") {
                        sendToConnection(.cc(1, value: .midi1(64), channel: 0))
                    }
                }
                .disabled(
                    midiOutSelectedID == .invalidMIDIIdentifier ||
                    !midiManager.endpoints.inputs.contains(whereUniqueID: midiOutSelectedID)
                )
            }
            .padding(5)
    
            GroupBox(label: Text("Virtual Endpoints")) {
                HStack {
                    Button("Create Test Virtual Endpoints") {
                        midiHelper.createVirtualEndpoints()
                    }
                    .disabled(midiHelper.virtualsExist)
    
                    Button("Destroy Test Virtual Endpoints") {
                        midiHelper.destroyVirtualInputs()
                    }
                    .disabled(!midiHelper.virtualsExist)
                }
                .frame(maxWidth: .infinity)
    
                HStack {
                    Button("Send Note On C3") {
                        sendToVirtuals(.noteOn(60, velocity: .midi1(127), channel: 0))
                    }
    
                    Button("Send Note Off C3") {
                        sendToVirtuals(.noteOff(60, velocity: .midi1(0), channel: 0))
                    }
    
                    Button("Send CC1") {
                        sendToVirtuals(.cc(1, value: .midi1(64), channel: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .disabled(!midiHelper.virtualsExist)
            }
            .padding(5)
    
            GroupBox(label: Text("Received Events")) {
                let events = midiHelper.receivedEvents.reversed()
                
                // Since MIDIEvent doesn't conform to Identifiable (and won't ever), in a List or
                // ForEach we need to either use an array index or a wrap MIDIEvent in a custom
                // type that does conform to Identifiable. It's really up to your use case.
                // Usually application interaction is driven by MIDI events and we aren't literally
                // logging events, but this is for diagnostic purposes here.
                List(events.indices, id: \.self) { index in
                    Text(events[index].description)
                    .foregroundColor(color(for: events[index]))
                }
                .frame(minHeight: 100)
            }
        }
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .padding()
        .frame(minWidth: 700, minHeight: 660)
    }
}

extension ContentView {
    private func sendToConnection(_ event: MIDIEvent) {
        try? midiHelper.midiOutputConnection?.send(event: event)
    }
    
    private func sendToVirtuals(_ event: MIDIEvent) {
        try? midiHelper.midiTestOut1?.send(event: event)
        try? midiHelper.midiTestOut2?.send(event: event)
    }
    
    private func color(for event: MIDIEvent) -> Color? {
        switch event {
        case .noteOn: return .green
        case .noteOff: return .red
        case .cc: return .orange
        default: return nil
        }
    }
}

#endif
