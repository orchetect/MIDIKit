//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct ContentView: View {
    @Environment(MIDIHelper.self) private var midiHelper
    
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
            .disabled(!midiHelper.isVirtualInputsExist)
            
            Button("Destroy a Virtual Output") {
                midiHelper.removeVirtualOutput()
            }
            .disabled(!midiHelper.isVirtualOutputsExist)
        }
        #if os(iOS)
        .font(.system(size: 18))
        #endif
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
