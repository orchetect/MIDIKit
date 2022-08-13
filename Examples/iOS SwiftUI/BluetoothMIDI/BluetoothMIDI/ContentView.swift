//
//  ContentView.swift
//  BluetoothMIDI
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    
    @State var showingBluetoothMIDIOptions = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(
                "This example demonstrates connecting to Bluetooth MIDI devices on iOS and receiving events."
            )
            
            Text(
                "Events received from all MIDI output endpoints are automatically logged to the console."
            )
            
            Button("Show Bluetooth MIDI Setup") {
                showingBluetoothMIDIOptions = true
            }
            
            Button("Send test MIDI Event to all MIDI Inputs") {
                let conn = midiManager.managedOutputConnections["Broadcaster"]
                try? conn?.send(event: .cc(.expression, value: .midi1(64), channel: 0))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .font(.system(size: 14))
        .lineLimit(4)
        .multilineTextAlignment(.center)
        .padding()
        
        .sheet(isPresented: $showingBluetoothMIDIOptions) {
            BluetoothMIDIView()
        }
    }
}
