//
//  AppDelegate.swift
//  EventParsing
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Cocoa
import MIDIKit
import SwiftRadix

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let midiManager = MIDI.IO.Manager(clientName: "TestAppMIDIManager",
                                      model: "TestApp",
                                      manufacturer: "MyCompany")
    
    let virtualInputName = "TestApp Input"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        do {
            print("Creating virtual MIDI input.")
            try midiManager.addInput(
                name: virtualInputName,
                tag: virtualInputName,
                uniqueID: .userDefaultsManaged(key: virtualInputName),
                receiveHandler: .events() { [weak self] events in
                    events.forEach { self?.handleMIDI(event: $0) }
                }
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
        
    }
    
    private func handleMIDI(event: MIDI.Event) {
        
        switch event {
        case .noteOn(let payload):
            print("Note On:",
                  "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                  "\n  Velocity (MIDI1 7-bit):", payload.velocity.midi1Value,
                  "\n  Velocity (MIDI2 16-bit):", payload.velocity.midi2Value,
                  "\n  Velocity (Unit Interval):", payload.velocity.unitIntervalValue,
                  "\n  Attribute (MIDI2):", payload.attribute,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .noteOff(let payload):
            print("Note Off:",
                  "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                  "\n  Velocity (MIDI1 7-bit):", payload.velocity.midi1Value,
                  "\n  Velocity (MIDI2 16-bit):", payload.velocity.midi2Value,
                  "\n  Velocity (Unit Interval):", payload.velocity.unitIntervalValue,
                  "\n  Attribute (MIDI2):", payload.attribute,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .noteCC(let payload):
            print("Per-Note CC (MIDI 2.0 Only):",
                  "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                  "\n  Controller:", payload.controller,
                  "\n  Value (MIDI2 32-bit):", payload.value.midi2Value,
                  "\n  Value (Unit Interval):", payload.value.unitIntervalValue,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .notePitchBend(let payload):
            print("Per-Note Pitch Bend (MIDI 2.0 Only):",
                  "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                  "\n  Value (MIDI2 32-bit):", payload.value.midi2Value,
                  "\n  Value (Unit Interval):", payload.value.unitIntervalValue,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .notePressure(let payload):
            print("Per-Note Pressure (a.k.a. Polyphonic Aftertouch):",
                  "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                  "\n  Amount (MIDI1 7-bit):", payload.amount.midi1Value,
                  "\n  Amount (MIDI2 32-bit):", payload.amount.midi2Value,
                  "\n  Amount (Unit Interval):", payload.amount.unitIntervalValue,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .noteManagement(let payload):
            print("Per-Note Management (MIDI 2.0 Only):",
                  "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                  "\n  Option Flags:", payload.optionFlags,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .cc(let payload):
            print("Control Change (CC):",
                  "\n  Controller:", payload.controller,
                  "\n  Value (MIDI1 7-bit):", payload.value.midi1Value,
                  "\n  Value (MIDI2 32-bit):", payload.value.midi2Value,
                  "\n  Value (Unit Interval):", payload.value.unitIntervalValue,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .programChange(let payload):
            print("Program Change:",
                  "\n  Program:", payload.program.intValue,
                  "\n  Bank Select:", payload.bank,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .pitchBend(let payload):
            print("Channel Pitch Bend:",
                  "\n  Value (MIDI1 14-bit):", payload.value.midi1Value,
                  "\n  Value (MIDI2 32-bit):", payload.value.midi2Value,
                  "\n  Value (Unit Interval):", payload.value.unitIntervalValue,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .pressure(let payload):
            print("Channel Pressure (a.k.a. Aftertouch):",
                  "\n  Amount (MIDI1 7-bit):", payload.amount.midi1Value,
                  "\n  Amount (MIDI2 32-bit):", payload.amount.midi2Value,
                  "\n  Amount (Unit Interval):", payload.amount.unitIntervalValue,
                  "\n  Channel:", payload.channel.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .sysEx7(let payload):
            print("System Exclusive 7:",
                  "\n  Manufacturer:", payload.manufacturer,
                  "\n  Data (\(payload.data.count) bytes):", payload.data.hex.stringValue(padToEvery: 2),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .universalSysEx7(let payload):
            print("Universal System Exclusive 7:",
                  "\n  Type:", payload.universalType,
                  "\n  Device ID:", payload.deviceID.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                  "\n  Sub ID #1:", payload.subID1.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                  "\n  Sub ID #2:", payload.subID2.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                  "\n  Data (\(payload.data.count) bytes):", payload.data.hex.stringValue(padToEvery: 2),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .sysEx8(let payload):
            print("System Exclusive 8 (MIDI 2.0 Only):",
                  "\n  Manufacturer:", payload.manufacturer,
                  "\n  Data (\(payload.data.count) bytes):", payload.data.hex.stringValue(padToEvery: 2),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .universalSysEx8(let payload):
            print("Universal System Exclusive 8 (MIDI 2.0 Only):",
                  "\n  Type:", payload.universalType,
                  "\n  Device ID:", payload.deviceID.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                  "\n  Sub ID #1:", payload.subID1.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                  "\n  Sub ID #2:", payload.subID2.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                  "\n  Data (\(payload.data.count) bytes):", payload.data.hex.stringValue(padToEvery: 2),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .timecodeQuarterFrame(let payload):
            print("Timecode Quarter-Frame:",
                  "\n  Data Byte:", payload.dataByte.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .songPositionPointer(let payload):
            print("Song Position Pointer:",
                  "\n  MIDI Beat:", payload.midiBeat.intValue.hex.stringValue(prefix: true),
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .songSelect(let payload):
            print("Song Select:",
                  "\n  Number:", payload.number.intValue,
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .unofficialBusSelect(let payload):
            print("Unofficial Bus Select (May be removed in a future MIDIKit release):",
                  "\n  Bus:", payload.bus.intValue,
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .tuneRequest(let payload):
            print("Tune Request:",
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .timingClock(let payload):
            print("Timing Clock:",
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .start(let payload):
            print("Start:",
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .continue(let payload):
            print("Continue:",
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .stop(let payload):
            print("Stop:",
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .activeSensing(let payload):
            print("Active Sensing (Deprecated in MIDI 2.0):",
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
            
        case .systemReset(let payload):
            print("System Reset:",
                  "\n  UMP Group (MIDI2):", payload.group.intValue.hex.stringValue(prefix: true))
        }
        
    }
    
}
