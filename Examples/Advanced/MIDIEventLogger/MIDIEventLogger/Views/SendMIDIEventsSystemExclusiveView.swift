//
//  SendMIDIEventsSystemExclusiveView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftRadix
import SwiftUI

extension ContentView {
    struct SendMIDIEventsSystemExclusiveView: View {
        @Binding var midiGroup: UInt4
        var sendEvent: (MIDIEvent) -> Void
        
        var body: some View {
            GroupBox(label: Text("System Exclusive")) {
                VStack(alignment: .center, spacing: 8) {
                    GroupBox(label: Text("SysEx7")) {
                        HStack {
                            Text("Bytes:")
                            
                            Button {
                                sendEvent(sysEx7(dataByteCount: 0, group: midiGroup))
                            } label: { Text("0") }
                            
                            Button {
                                sendEvent(sysEx7(dataByteCount: 2, group: midiGroup))
                            } label: { Text("2") }
                            
                            Button {
                                sendEvent(sysEx7(dataByteCount: 5, group: midiGroup))
                            } label: { Text("5") }
                            
                            Button {
                                sendEvent(sysEx7(dataByteCount: 7, group: midiGroup))
                            } label: { Text("7") }
                            
                            Button {
                                sendEvent(sysEx7(dataByteCount: 13, group: midiGroup))
                            } label: { Text("13") }
                        }
                        .frame(width: 220)
                    }
                    
                    GroupBox(label: Text("Universal SysEx7")) {
                        HStack {
                            Text("Bytes:")
                            
                            Button {
                                sendEvent(universalSysEx7(dataByteCount: 0, group: midiGroup))
                            } label: { Text("0") }
                            
                            Button {
                                sendEvent(universalSysEx7(dataByteCount: 2, group: midiGroup))
                            } label: { Text("2") }
                            
                            Button {
                                sendEvent(universalSysEx7(dataByteCount: 4, group: midiGroup))
                            } label: { Text("4") }
                            
                            Button {
                                sendEvent(universalSysEx7(dataByteCount: 10, group: midiGroup))
                            } label: { Text("10") }
                        }
                        .frame(width: 220)
                    }
                    
                    GroupBox(label: Text("SysEx8 (MIDI 2.0)")) {
                        HStack {
                            Text("Bytes:")
                            
                            Button {
                                sendEvent(sysEx8(dataByteCount: 0, group: midiGroup))
                            } label: { Text("0") }
                            
                            Button {
                                sendEvent(sysEx8(dataByteCount: 2, group: midiGroup))
                            } label: { Text("2") }
                            
                            Button {
                                sendEvent(sysEx8(dataByteCount: 5, group: midiGroup))
                            } label: { Text("5") }
                            
                            Button {
                                sendEvent(sysEx8(dataByteCount: 7, group: midiGroup))
                            } label: { Text("7") }
                            
                            Button {
                                sendEvent(sysEx8(dataByteCount: 13, group: midiGroup))
                            } label: { Text("13") }
                        }
                        .frame(width: 220)
                    }
                    
                    GroupBox(label: Text("Universal SysEx8 (MIDI 2.0)")) {
                        HStack {
                            Text("Bytes:")
                            
                            Button {
                                sendEvent(universalSysEx8(dataByteCount: 0, group: midiGroup))
                            } label: { Text("0") }
                            
                            Button {
                                sendEvent(universalSysEx8(dataByteCount: 2, group: midiGroup))
                            } label: { Text("2") }
                            
                            Button {
                                sendEvent(universalSysEx8(dataByteCount: 4, group: midiGroup))
                            } label: { Text("4") }
                            
                            Button {
                                sendEvent(universalSysEx8(dataByteCount: 10, group: midiGroup))
                            } label: { Text("10") }
                        }
                        .frame(width: 220)
                    }
                }
                .padding()
                .frame(height: 270)
            }
        }
        
        // MARK: - Helpers
        
        /// Sample SysEx7 event generator.
        private func sysEx7(dataByteCount: Int, group: UInt4) -> MIDIEvent {
            let dataBytes: [UInt7] = random7BitBytes(count: dataByteCount)
            
            return .sysEx7(
                manufacturer: .educational(),
                data: dataBytes,
                group: group
            )
        }
        
        /// Sample Universal SysEx7 event generator.
        private func universalSysEx7(dataByteCount: Int, group: UInt4) -> MIDIEvent {
            let dataBytes: [UInt7] = random7BitBytes(count: dataByteCount)
            
            return .universalSysEx7(
                universalType: Bool.random() ? .realTime : .nonRealTime,
                deviceID: random7Bit(),
                subID1: random7Bit(),
                subID2: random7Bit(),
                data: dataBytes,
                group: group
            )
        }
        
        private func random7Bit() -> UInt7 {
            // TODO: need this only because `UInt7.random(in:)` is not yet implemented
            UInt8.random(in: UInt7.min.uInt8Value ... UInt7.max.uInt8Value).toUInt7
        }
        
        private func random7BitBytes(count: Int) -> [UInt7] {
            // TODO: need this only because `UInt7` doesn't conform to FixedWidthIngeter
            (0 ..< count.clamped(to: 0 ... 63))
                .map { _ in random7Bit() }
        }
        
        /// Sample SysEx8 event generator.
        private func sysEx8(dataByteCount: Int, group: UInt4) -> MIDIEvent {
            let dataBytes: [UInt8] = .randomValues(count: dataByteCount)
            
            return .sysEx8(
                manufacturer: .educational(),
                data: dataBytes,
                group: group
            )
        }
        
        /// Sample Universal SysEx8 event generator.
        private func universalSysEx8(dataByteCount: Int, group: UInt4) -> MIDIEvent {
            let dataBytes: [UInt8] = .randomValues(count: dataByteCount)
            
            return .universalSysEx8(
                universalType: Bool.random() ? .realTime : .nonRealTime,
                deviceID: random7Bit(),
                subID1: random7Bit(),
                subID2: random7Bit(),
                data: dataBytes,
                group: group
            )
        }
        
        private func random8Bit() -> UInt8 {
            UInt8.random(in: UInt8.min ... UInt8.max)
        }
    }
}
