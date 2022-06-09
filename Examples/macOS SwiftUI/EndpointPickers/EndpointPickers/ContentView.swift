//
//  ContentView.swift
//  EndpointPickers
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

struct ContentView: View {
    
    @EnvironmentObject var midiManager: MIDI.IO.Manager
    
    @Binding var midiInSelectedID: MIDI.IO.CoreMIDIUniqueID
    @Binding var midiInSelectedDisplayName: String
    
    @Binding var midiOutSelectedID: MIDI.IO.CoreMIDIUniqueID
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            
            Group {
                Text("This example demonstrates maintaining menus with MIDI endpoints in the system, allowing a single selection for each menu.")
                
                Text("Refer to this example's README.md file for important information.")
            }
            .frame(height: 40)
            
            Spacer()
            
            Text("MIDI In: Received MIDI events are logged to the console.")
            
            MIDIEndpointSelectionView(
                midiInSelectedID: $midiInSelectedID,
                midiInSelectedDisplayName: $midiInSelectedDisplayName,
                midiOutSelectedID: $midiOutSelectedID,
                midiOutSelectedDisplayName: $midiOutSelectedDisplayName
            )
            
            Text("MIDI Out: Send test MIDI events with these buttons.")
            
            HStack {
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
            
            Spacer()
        }
        .font(.system(size: 14))
        .lineLimit(nil)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        
    }
    
    var midiOutputConnection: MIDI.IO.OutputConnection? {
        midiManager.managedOutputConnections[ConnectionTags.midiOut]
    }
    
    func sendNoteOn() {
        
        try? midiOutputConnection?.send(
            event: .noteOn(60,
                           velocity: .midi1(127),
                           channel: 0)
        )
        
    }
    
    func sendNoteOff() {
        
        try? midiOutputConnection?.send(
            event: .noteOff(60,
                            velocity: .midi1(0),
                            channel: 0)
        )
        
    }
    
    func sendCC1() {
        
        try? midiOutputConnection?.send(
            event: .cc(1,
                       value: .midi1(64),
                       channel: 0)
        )
        
    }
    
}
