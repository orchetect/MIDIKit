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
                sendNoteOn()
            }
            
            Button("Send Note Off C3") {
                sendNoteOff()
            }
            
            Button("Send CC1") {
                sendCC1()
            }
        }
        .font(.system(size: 18))
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - MIDI Events

extension ContentView {
    private func send(event: MIDIEvent) {
        try? midiHelper.outputConnection?.send(event: event)
    }
    
    private func sendNoteOn() {
        send(event: .noteOn(
            60,
            velocity: .midi1(127),
            channel: 0
        ))
    }
    
    private func sendNoteOff() {
        send(event: .noteOff(
            60,
            velocity: .midi1(0),
            channel: 0
        ))
    }
    
    private func sendCC1() {
        send(event: .cc(
            1,
            value: .midi1(64),
            channel: 0
        ))
    }
}
