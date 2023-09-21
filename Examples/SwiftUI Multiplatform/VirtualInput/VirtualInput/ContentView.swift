//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(
                """
                This example creates a virtual MIDI input port named "\(MIDIHelper.virtualInputName)".
                
                Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.
                
                Values are logged in both MIDI 1.0 and MIDI 2.0 resolutions for convenience, regardless of which API being used in the system.
                
                For a more in-depth example demonstrating reading values from events, review the Event Parsing example project.
                """
            )
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
}
