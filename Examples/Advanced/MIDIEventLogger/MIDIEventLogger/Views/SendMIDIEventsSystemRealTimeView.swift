//
//  SendMIDIEventsSystemRealTimeView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTCore
import SwiftRadix
import MIDIKit

extension ContentView {
    struct SendMIDIEventsSystemRealTimeView: View {
        @Binding var midiGroup: UInt4
        var sendEvent: (MIDIEvent) -> Void
        
        var body: some View {
            GroupBox(label: Text("System Real-Time")) {
                VStack(alignment: .center, spacing: 8) {
                    Button {
                        sendEvent(.timingClock(group: midiGroup))
                    } label: { Text("Timing Clock") }
                    
                    Button {
                        sendEvent(.start(group: midiGroup))
                    } label: { Text("Start") }
                    
                    Button {
                        sendEvent(.continue(group: midiGroup))
                    } label: { Text("Continue") }
                    
                    Button {
                        sendEvent(.stop(group: midiGroup))
                    } label: { Text("Stop") }
                    
                    Button {
                        sendEvent(.activeSensing(group: midiGroup))
                    } label: { Text("Active Sensing") }
                    
                    Button {
                        sendEvent(.systemReset(group: midiGroup))
                    } label: { Text("System Reset") }
                }
                .padding()
                .frame(height: 270)
            }
        }
    }
}
