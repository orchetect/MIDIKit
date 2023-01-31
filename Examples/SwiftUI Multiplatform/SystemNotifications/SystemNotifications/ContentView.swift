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
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This example logs all Core MIDI system notifications to the console.")
                .multilineTextAlignment(.center)
            
            Button("Create a Virtual Input") {
                midiHelper.addVirtualInput()
            }
            
            Button("Create a Virtual Output") {
                midiHelper.addVirtualOutput()
            }
            
            Button("Destroy a Virtual Input") {
                midiHelper.removeVirtualInput()
            }
            .disabled(midiManager.managedInputs.isEmpty)
            
            Button("Destroy a Virtual Output") {
                midiHelper.removeVirtualOutput()
            }
            .disabled(midiManager.managedOutputs.isEmpty)
        }
        .font(.system(size: 18))
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
