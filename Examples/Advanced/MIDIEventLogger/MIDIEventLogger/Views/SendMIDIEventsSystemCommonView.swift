//
//  SendMIDIEventsSystemCommonView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import OTCore
import SwiftRadix
import SwiftUI

extension ContentView {
    struct SendMIDIEventsSystemCommonView: View {
        @Binding var midiGroup: UInt4
        var sendEvent: (MIDIEvent) -> Void
        
        var body: some View {
            GroupBox(label: Text("System Common")) {
                VStack(alignment: .center, spacing: 8) {
                    Button {
                        sendEvent(.timecodeQuarterFrame(
                            dataByte: 0x00,
                            group: midiGroup
                        ))
                    } label: { Text("Timecode Quarter-Frame") }
                    
                    Button {
                        sendEvent(.songPositionPointer(
                            midiBeat: 8,
                            group: midiGroup
                        ))
                    } label: { Text("Song Position Pointer") }
                    
                    Button {
                        sendEvent(.songSelect(
                            number: 4,
                            group: midiGroup
                        ))
                    } label: { Text("Song Select") }
                    
                    Button {
                        sendEvent(.unofficialBusSelect(
                            bus: 2,
                            group: midiGroup
                        ))
                    } label: { Text("Bus Select (Unofficial)") }
                    
                    Button {
                        sendEvent(.tuneRequest(group: midiGroup))
                    } label: { Text("Tune Request") }
                }
                .padding()
                .frame(height: 270)
            }
        }
    }
}
