//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    
    @Binding var midiOutSelectedID: MIDIIdentifier
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    NavigationLink("Info") {
                        InfoView()
                    }
                }
    
                Section() {
                    MIDIEndpointSelectionView(
                        midiInSelectedID: $midiInSelectedID,
                        midiInSelectedDisplayName: $midiInSelectedDisplayName,
                        midiOutSelectedID: $midiOutSelectedID,
                        midiOutSelectedDisplayName: $midiOutSelectedDisplayName
                    )
    
                    Group {
                        Button("Send Note On C3") {
                            sendToConnection(event: .noteOn(
                                60,
                                velocity: .midi1(127),
                                channel: 0
                            ))
                        }
    
                        Button("Send Note Off C3") {
                            sendToConnection(event: .noteOff(
                                60,
                                velocity: .midi1(0),
                                channel: 0
                            ))
                        }
    
                        Button("Send CC1") {
                            sendToConnection(event: .cc(
                                1,
                                value: .midi1(64),
                                channel: 0
                            ))
                        }
                    }
                    .disabled(
                        midiOutSelectedID == 0 ||
                            !midiHelper.isInputPresentInSystem(uniqueID: midiOutSelectedID)
                    )
                }
    
                Section() {
                    Button("Create Test Virtual Endpoints") {
                        midiHelper.createVirtualInputs()
                    }
                    .disabled(midiHelper.virtualsExist)
    
                    Button("Destroy Test Virtual Endpoints") {
                        midiHelper.destroyVirtualInputs()
                    }
                    .disabled(!midiHelper.virtualsExist)
    
                    Group {
                        Button("Send Note On C3") {
                            sendToVirtuals(event: .noteOn(
                                60,
                                velocity: .midi1(127),
                                channel: 0
                            ))
                        }
    
                        Button("Send Note Off C3") {
                            sendToVirtuals(event: .noteOff(
                                60,
                                velocity: .midi1(0),
                                channel: 0
                            ))
                        }
    
                        Button("Send CC1") {
                            sendToVirtuals(event: .cc(
                                1,
                                value: .midi1(64),
                                channel: 0
                            ))
                        }
                    }
                    .disabled(!midiHelper.virtualsExist)
                }
    
                Section(header: Text("Received Events")) {
                    let events = midiHelper.receivedEvents.reversed()
                    
                    List(events.indices, id: \.self) { index in
                        Text(events[index].description)
                        .foregroundColor(color(for: events[index]))
                    }
                }
            }
            .navigationBarTitle("Endpoint Pickers")
            
            InfoView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
    
    func sendToConnection(event: MIDIEvent) {
        try? midiHelper.midiOutputConnection?.send(event: event)
    }
    
    func sendToVirtuals(event: MIDIEvent) {
        try? midiHelper.midiTestOut1?.send(event: event)
        try? midiHelper.midiTestOut2?.send(event: event)
    }
    
    func color(for event: MIDIEvent) -> Color? {
        switch event {
        case .noteOn: return .green
        case .noteOff: return .red
        case .cc: return .orange
        default: return nil
        }
    }
}

struct InfoView: View {
    var body: some View {
        Text(
            """
            This example demonstrates maintaining menus with MIDI endpoints in the system, allowing a single selection for each menu.
            
            Refer to this example's README.md file for important information.
            
            For testing purposes, try creating virtual endpoints, selecting them as MIDI In and MIDI Out, then destroying them. They appear as missing but their selection is retained. Then create them again, and they will appear normally once again and connection will resume. They are remembered even if you quit the app.
            """
        )
        .multilineTextAlignment(.center)
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: 600)
    }
}
