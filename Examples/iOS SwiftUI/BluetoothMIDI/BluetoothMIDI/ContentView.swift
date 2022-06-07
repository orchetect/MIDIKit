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
            Text("This example demonstrates configuring Bluetooth MIDI on iOS.")
                .font(.system(size: 14))
                .lineLimit(4)
                .multilineTextAlignment(.center)
            
            Button("Show Bluetooth MIDI Setup") {
                showingBluetoothMIDIOptions = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        
        .sheet(isPresented: $showingBluetoothMIDIOptions) {
            BluetoothMIDIView()
        }
        
    }
    
}
