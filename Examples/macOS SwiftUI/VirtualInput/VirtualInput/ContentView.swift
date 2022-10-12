//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(
                """
                This example creates a virtual MIDI input port named "TestApp Input"
                    
                Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.
                    
                Event values are logged in their native format.
                    
                On modern operating systems supporting MIDI 2.0, event values will be natively received as MIDI 2.0 values.
                    
                Regardless, MIDI 1.0 ←→ MIDI 2.0 values are always seamlessly convertible.
                    
                For more details, review the Event Parsing example project.
                """
            )
            .font(.system(size: 14))
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
}
