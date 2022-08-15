//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Group {
                Text("This example creates a virtual MIDI input port named \"TestApp Input\".")
    
                Text(
                    "Received MIDI events are logged to the console, filtering out Active Sensing and Clock events."
                )
    
                Text("Event values are logged in all formats available in MIDIKit.")
            }
            .font(.system(size: 14))
            .lineLimit(4)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
}
