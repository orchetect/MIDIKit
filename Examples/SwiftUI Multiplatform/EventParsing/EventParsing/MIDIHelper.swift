//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftRadix
import SwiftUI

/// Receiving MIDI happens on an asynchronous background thread. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class marked with `@Observable`
/// which contains properties that SwiftUI can use to update views.
@Observable final class MIDIHelper {
    private weak var midiManager: ObservableMIDIManager?
    
    let virtualInputName = "TestApp Input"
    
    public init() { }
    
    public func setup(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
    
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
                receiver: .events { [weak self] events, timeStamp, source in
                    events.forEach { self?.received(event: $0) }
                }
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    }
    
    private func received(event: MIDIEvent) {
        switch event {
        case let .noteOn(payload):
            print(
                "Note On:",
                "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                "\n  Velocity (MIDI1 7-bit):",
                payload.velocity.midi1Value,
                "\n  Velocity (MIDI2 16-bit):",
                payload.velocity.midi2Value,
                "\n  Velocity (Unit Interval):",
                payload.velocity.unitIntervalValue,
                "\n  Attribute (MIDI2):",
                payload.attribute,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .noteOff(payload):
            print(
                "Note Off:",
                "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                "\n  Velocity (MIDI1 7-bit):",
                payload.velocity.midi1Value,
                "\n  Velocity (MIDI2 16-bit):",
                payload.velocity.midi2Value,
                "\n  Velocity (Unit Interval):",
                payload.velocity.unitIntervalValue,
                "\n  Attribute (MIDI2):",
                payload.attribute,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .noteCC(payload):
            print(
                "Per-Note CC (MIDI 2.0 Only):",
                "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                "\n  Controller:",
                payload.controller,
                "\n  Value (MIDI2 32-bit):",
                payload.value.midi2Value,
                "\n  Value (Unit Interval):",
                payload.value.unitIntervalValue,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .notePitchBend(payload):
            print(
                "Per-Note Pitch Bend (MIDI 2.0 Only):",
                "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                "\n  Value (MIDI2 32-bit):",
                payload.value.midi2Value,
                "\n  Value (Unit Interval):",
                payload.value.unitIntervalValue,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .notePressure(payload):
            print(
                "Per-Note Pressure (a.k.a. Polyphonic Aftertouch):",
                "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                "\n  Amount (MIDI1 7-bit):",
                payload.amount.midi1Value,
                "\n  Amount (MIDI2 32-bit):",
                payload.amount.midi2Value,
                "\n  Amount (Unit Interval):",
                payload.amount.unitIntervalValue,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .noteManagement(payload):
            print(
                "Per-Note Management (MIDI 2.0 Only):",
                "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                "\n  Option Flags:",
                payload.optionFlags,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .cc(payload):
            print(
                "Control Change (CC):",
                "\n  Controller:",
                payload.controller,
                "\n  Value (MIDI1 7-bit):",
                payload.value.midi1Value,
                "\n  Value (MIDI2 32-bit):",
                payload.value.midi2Value,
                "\n  Value (Unit Interval):",
                payload.value.unitIntervalValue,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .programChange(payload):
            print(
                "Program Change:",
                "\n  Program:",
                payload.program.intValue,
                "\n  Bank Select:",
                payload.bank,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .pitchBend(payload):
            print(
                "Channel Pitch Bend:",
                "\n  Value (MIDI1 14-bit):",
                payload.value.midi1Value,
                "\n  Value (MIDI2 32-bit):",
                payload.value.midi2Value,
                "\n  Value (Unit Interval):",
                payload.value.unitIntervalValue,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .pressure(payload):
            print(
                "Channel Pressure (a.k.a. Aftertouch):",
                "\n  Amount (MIDI1 7-bit):",
                payload.amount.midi1Value,
                "\n  Amount (MIDI2 32-bit):",
                payload.amount.midi2Value,
                "\n  Amount (Unit Interval):",
                payload.amount.unitIntervalValue,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
        
        case let .rpn(payload):
            print(
                "Registered Parameter Number (RPN) (a.k.a. Registered Controller):",
                "\n  Parameter:",
                payload.parameter,
                "\n  Change Type (Only applicable for MIDI 2.0; MIDI 1.0 is always absolute):",
                payload.change,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
            
        case let .nrpn(payload):
            print(
                "Non-Registered Parameter Number (NRPN) (a.k.a. Assignable Controller):",
                "\n  Parameter:",
                payload.parameter,
                "\n  Change Type (Only applicable for MIDI 2.0; MIDI 1.0 is always absolute):",
                payload.change,
                "\n  Channel:",
                payload.channel.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
            
        case let .sysEx7(payload):
            print(
                "System Exclusive 7:",
                "\n  Manufacturer:",
                payload.manufacturer,
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hex.stringValue(padTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .universalSysEx7(payload):
            print(
                "Universal System Exclusive 7:",
                "\n  Type:",
                payload.universalType,
                "\n  Device ID:",
                payload.deviceID.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                "\n  Sub ID #1:",
                payload.subID1.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                "\n  Sub ID #2:",
                payload.subID2.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hex.stringValue(padTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .sysEx8(payload):
            print(
                "System Exclusive 8 (MIDI 2.0 Only):",
                "\n  Manufacturer:",
                payload.manufacturer,
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hex.stringValue(padTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .universalSysEx8(payload):
            print(
                "Universal System Exclusive 8 (MIDI 2.0 Only):",
                "\n  Type:",
                payload.universalType,
                "\n  Device ID:",
                payload.deviceID.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                "\n  Sub ID #1:",
                payload.subID1.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                "\n  Sub ID #2:",
                payload.subID2.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hex.stringValue(padTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .timecodeQuarterFrame(payload):
            print(
                "Timecode Quarter-Frame:",
                "\n  Data Byte:",
                payload.dataByte.uInt8Value.hex.stringValue(padTo: 2, prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .songPositionPointer(payload):
            print(
                "Song Position Pointer:",
                "\n  MIDI Beat:",
                payload.midiBeat.intValue.hex.stringValue(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .songSelect(payload):
            print(
                "Song Select:",
                "\n  Number:",
                payload.number.intValue,
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .tuneRequest(payload):
            print(
                "Tune Request:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .timingClock(payload):
            print(
                "Timing Clock:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .start(payload):
            print(
                "Start:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .continue(payload):
            print(
                "Continue:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .stop(payload):
            print(
                "Stop:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .activeSensing(payload):
            print(
                "Active Sensing (Deprecated in MIDI 2.0):",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .systemReset(payload):
            print(
                "System Reset:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .noOp(payload):
            print(
                "No-Op (MIDI 2.0 Only):",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .jrClock(payload):
            print(
                "JR Clock - Jitter-Reduction Clock (MIDI 2.0 Only):",
                "\n  Time Value:",
                payload.time,
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
    
        case let .jrTimestamp(payload):
            print(
                "JR Timestamp - Jitter-Reduction Timestamp (MIDI 2.0 Only):",
                "\n  Time Value:",
                payload.time,
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hex.stringValue(prefix: true)
            )
        }
    }
}
