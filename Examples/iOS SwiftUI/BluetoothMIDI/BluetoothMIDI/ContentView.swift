//
//  ContentView.swift
//  BluetoothMIDI
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI

struct ContentView: View {
    @State var showingBluetoothMIDIOptions = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This example demonstrates connecting to Bluetooth MIDI devices on iOS and receiving events.")
            
            Text("Events received from all MIDI output endpoints are automatically logged to the console.")
            
            Button("Show Bluetooth MIDI Setup") {
                showingBluetoothMIDIOptions = true
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
