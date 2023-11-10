//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    @EnvironmentObject var midiManager: ObservableMIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(
                """
                This example creates a virtual MIDI input port named "\(midiHelper.virtualInputName)".
                
                Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.
                
                Event values are logged verbosely for purposes of this example.
                """
            )
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
}
