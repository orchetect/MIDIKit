//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var midiManager: ObservableMIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(
                """
                This example creates a MIDI output connection to the MIDI endpoint that iOS creates once an iOS-to-Mac USB connection has been established in Audio MIDI Setup on the Mac.
                
                Note that this example project must be run on a physical iOS device connected with a USB cable.
                
                Test events can be sent to the Mac by using the buttons below.
                
                Events received from the Mac are logged to the console in this example.
                """
            )
            .multilineTextAlignment(.center)
            
            Button("Send Note On C3") {
                midiHelper.sendNoteOn()
            }
            
            Button("Send Note Off C3") {
                midiHelper.sendNoteOff()
            }
            
            Button("Send CC1") {
                midiHelper.sendCC1()
            }
        }
        .font(.system(size: 18))
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
