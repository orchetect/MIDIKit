//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct ContentView: View {
    @Environment(MIDIHelper.self) private var midiHelper
    
    @State private var model = Model()
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(
                """
                This example creates a virtual MIDI input port named "\(midiHelper.virtualInputName)".
                
                Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.
                
                Event values are logged in all available formats.
                """
            )
            .multilineTextAlignment(.center)
            
            Text("Received events count: \(model.receivedEventCount)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .onAppear {
            setupMIDIHelper()
        }
    }
    
    private func setupMIDIHelper() {
        midiHelper.setEventHandler { event in
            // if the event may result in UI changes, we need to put it on the main actor/thread
            Task { @MainActor in
                model.handle(event: event)
            }
        }
    }
}
