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
                "This example creates a virtual MIDI output port named \"\(midiHelper.virtualOutputName)\"."
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
        #if os(iOS)
        .font(.system(size: 18))
        #endif
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Events

extension ContentView {
    private func send(event: MIDIEvent) {
        try? midiHelper.virtualOutput?.send(event: event)
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
