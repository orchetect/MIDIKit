//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import UIKit
import MIDIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    let virtualInputName = "TestApp Input"
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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
                receiver: .events { [weak self] events in
                    events.forEach { self?.handleMIDI(event: $0) }
                }
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    
        return true
    }
    
    private func handleMIDI(event: MIDIEvent) {
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .noteManagement(payload):
            print(
                "Per-Note Management (MIDI 2.0 Only):",
                "\n  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))",
                "\n  Option Flags:",
                payload.optionFlags,
                "\n  Channel:",
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .programChange(payload):
            print(
                "Program Change:",
                "\n  Program:",
                payload.program.intValue,
                "\n  Bank Select:",
                payload.bank,
                "\n  Channel:",
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
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
                payload.channel.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .sysEx7(payload):
            print(
                "System Exclusive 7:",
                "\n  Manufacturer:",
                payload.manufacturer,
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hexString(padEachTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .universalSysEx7(payload):
            print(
                "Universal System Exclusive 7:",
                "\n  Type:",
                payload.universalType,
                "\n  Device ID:",
                payload.deviceID.uInt8Value.hexString(padTo: 2, prefix: true),
                "\n  Sub ID #1:",
                payload.subID1.uInt8Value.hexString(padTo: 2, prefix: true),
                "\n  Sub ID #2:",
                payload.subID2.uInt8Value.hexString(padTo: 2, prefix: true),
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hexString(padEachTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .sysEx8(payload):
            print(
                "System Exclusive 8 (MIDI 2.0 Only):",
                "\n  Manufacturer:",
                payload.manufacturer,
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hexString(padEachTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .universalSysEx8(payload):
            print(
                "Universal System Exclusive 8 (MIDI 2.0 Only):",
                "\n  Type:",
                payload.universalType,
                "\n  Device ID:",
                payload.deviceID.uInt8Value.hexString(padTo: 2, prefix: true),
                "\n  Sub ID #1:",
                payload.subID1.uInt8Value.hexString(padTo: 2, prefix: true),
                "\n  Sub ID #2:",
                payload.subID2.uInt8Value.hexString(padTo: 2, prefix: true),
                "\n  Data (\(payload.data.count) bytes):",
                payload.data.hexString(padEachTo: 2),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .timecodeQuarterFrame(payload):
            print(
                "Timecode Quarter-Frame:",
                "\n  Data Byte:",
                payload.dataByte.uInt8Value.hexString(padTo: 2, prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .songPositionPointer(payload):
            print(
                "Song Position Pointer:",
                "\n  MIDI Beat:",
                payload.midiBeat.intValue.hexString(prefix: true),
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .songSelect(payload):
            print(
                "Song Select:",
                "\n  Number:",
                payload.number.intValue,
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .unofficialBusSelect(payload):
            print(
                "Unofficial Bus Select (May be removed in a future MIDIKit release):",
                "\n  Bus:",
                payload.bus.intValue,
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .tuneRequest(payload):
            print(
                "Tune Request:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .timingClock(payload):
            print(
                "Timing Clock:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .start(payload):
            print(
                "Start:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .continue(payload):
            print(
                "Continue:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .stop(payload):
            print(
                "Stop:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .activeSensing(payload):
            print(
                "Active Sensing (Deprecated in MIDI 2.0):",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .systemReset(payload):
            print(
                "System Reset:",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .noOp(payload):
            print(
                "No-Op (MIDI 2.0 Only):",
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .jrClock(payload):
            print(
                "JR Clock - Jitter-Reduction Clock (MIDI 2.0 Only):",
                "\n  Time Value:",
                payload.time,
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
    
        case let .jrTimestamp(payload):
            print(
                "JR Timestamp - Jitter-Reduction Timestamp (MIDI 2.0 Only):",
                "\n  Time Value:",
                payload.time,
                "\n  UMP Group (MIDI2):",
                payload.group.intValue.hexString(prefix: true)
            )
        }
    }
}
