//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    
    var body: some View {
        NavigationView {
            Form() {
                NavigationLink("Info") {
                    InfoView()
                }
                Section("Connect to Remote Peripheral") {
                    NavigationLink(
                        destination: BluetoothMIDIView()
                            .navigationTitle("Remote Peripheral Config")
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label("Config", systemImage: "gear")
                    }
                }
                Section("Act as Peripheral") {
                    NavigationLink(
                        destination: BluetoothMIDIPeripheralView()
                            .navigationTitle("Local Peripheral Config")
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        Label("Config", systemImage: "gear")
                    }
                }
                Section("Send Test Event") {
                    Button("Broadcast test MIDI Event to all MIDI Inputs") {
                        sendTestMIDIEvent()
                    }
                }
                Section("Receive Events") {
                    Text(
                        "Events received from all MIDI output endpoints are logged to the console in this demo."
                    )
                }
            }
            .navigationTitle("Bluetooth MIDI")
            
            InfoView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
    
    func sendTestMIDIEvent() {
        let conn = midiManager.managedOutputConnections["Broadcaster"]
        try? conn?.send(event: .cc(.expression, value: .midi1(64), channel: 0))
    }
}

struct InfoView: View {
    var body: some View {
        Text(
            """
            This example demonstrates two paradigms:
            
            1. Connecting to remote Bluetooth MIDI device(s) to send/receive.
            2. Acting as a Bluetooth peripheral that other devices can connect to.
            
            Generally your app will only employ one of these paradigms, not both. For demonstration purposes, both are available in this demo app.
            """
        )
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
