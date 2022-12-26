//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    
    let virtualOutputName = "TestApp Output"
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This example creates a virtual MIDI output port named \"TestApp Output\".")
                .lineLimit(4)
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
    
    /// Convenience accessor for created virtual MIDI Output.
    var virtualOutput: MIDIOutput? {
        midiManager.managedOutputs[virtualOutputName]
    }
    
    func sendNoteOn() {
        try? virtualOutput?.send(event: .noteOn(
            60,
            velocity: .midi1(127),
            channel: 0
        ))
    }
    
    func sendNoteOff() {
        try? virtualOutput?.send(event: .noteOff(
            60,
            velocity: .midi1(0),
            channel: 0
        ))
    }
    
    func sendCC1() {
        try? virtualOutput?.send(event: .cc(
            1,
            value: .midi1(64),
            channel: 0
        ))
    }
}
