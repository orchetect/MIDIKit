//
//  ContentView.swift
//  VirtualOutput
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    
    @EnvironmentObject var midiManager: MIDI.IO.Manager
    
    let virtualOutputName = "TestApp Output"
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            Text("This example creates a virtual MIDI output port named \"TestApp Output\".")
                .font(.system(size: 14))
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
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        
    }
    
    func sendNoteOn() {
        
        guard let output = midiManager.managedOutputs[virtualOutputName] else { return }
        
        try? output.send(
            event: .noteOn(60,
                           velocity: .midi1(127),
                           channel: 0)
        )
        
    }
    
    func sendNoteOff() {
        
        guard let output = midiManager.managedOutputs[virtualOutputName] else { return }
        
        try? output.send(
            event: .noteOff(60,
                            velocity: .midi1(0),
                            channel: 0)
        )
        
    }
    
    func sendCC1() {
        
        guard let output = midiManager.managedOutputs[virtualOutputName] else { return }
        
        try? output.send(
            event: .cc(1,
                       value: .midi1(64),
                       channel: 0)
        )
        
    }
    
}
