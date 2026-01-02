//
//  Model.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import SwiftRadix

@MainActor @Observable public final class Model {
    public internal(set) var receivedEventCount: Int = 0
    
    public init() { }
    
    public func handle(event: MIDIEvent) {
        receivedEventCount += 1
        
        switch event {
        case let .noteOn(payload):
            print(
                """
                Note On:
                  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))
                  Velocity (MIDI1 7-bit): \(payload.velocity.midi1Value)
                  Velocity (MIDI2 16-bit): \(payload.velocity.midi2Value)
                  Velocity (Unit Interval): \(payload.velocity.unitIntervalValue)
                  Attribute (MIDI2): \(payload.attribute)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .noteOff(payload):
            print(
                """
                Note Off:
                  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))
                  Velocity (MIDI1 7-bit): \(payload.velocity.midi1Value)
                  Velocity (MIDI2 16-bit): \(payload.velocity.midi2Value)
                  Velocity (Unit Interval): \(payload.velocity.unitIntervalValue)
                  Attribute (MIDI2): \(payload.attribute)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .noteCC(payload):
            print(
                """
                Per-Note CC (MIDI 2.0 Only):
                  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))
                  Controller: \(payload.controller)
                  Value (MIDI2 32-bit): \(payload.value.midi2Value)
                  Value (Unit Interval): \(payload.value.unitIntervalValue)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .notePitchBend(payload):
            print(
                """
                Per-Note Pitch Bend (MIDI 2.0 Only):
                  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))
                  Value (MIDI2 32-bit): \(payload.value.midi2Value)
                  Value (Unit Interval): \(payload.value.unitIntervalValue)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .notePressure(payload):
            print(
                """
                Per-Note Pressure (a.k.a. Polyphonic Aftertouch)
                  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))
                  Amount (MIDI1 7-bit): \(payload.amount.midi1Value)
                  Amount (MIDI2 32-bit): \(payload.amount.midi2Value)
                  Amount (Unit Interval): \(payload.amount.unitIntervalValue)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .noteManagement(payload):
            print(
                """
                Per-Note Management (MIDI 2.0 Only)
                  Note: \(payload.note.number.intValue) (\(payload.note.stringValue()))
                  Option Flags: \(payload.flags)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .cc(payload):
            print(
                """
                Control Change (CC)
                  Controller: \(payload.controller)
                  Value (MIDI1 7-bit): \(payload.value.midi1Value)
                  Value (MIDI2 32-bit): \(payload.value.midi2Value)
                  Value (Unit Interval): \(payload.value.unitIntervalValue)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .programChange(payload):
            print(
                """
                Program Change
                  Program: \(payload.program.intValue)
                  Bank Select: \(payload.bank)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .pitchBend(payload):
            print(
                """
                Channel Pitch Bend
                  Value (MIDI1 14-bit): \(payload.value.midi1Value)
                  Value (MIDI2 32-bit): \(payload.value.midi2Value)
                  Value (Unit Interval): \(payload.value.unitIntervalValue)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .pressure(payload):
            print(
                """
                Channel Pressure (a.k.a. Aftertouch)
                  Amount (MIDI1 7-bit): \(payload.amount.midi1Value)
                  Amount (MIDI2 32-bit): \(payload.amount.midi2Value)
                  Amount (Unit Interval): \(payload.amount.unitIntervalValue)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .rpn(payload):
            print(
                """
                Registered Parameter Number (RPN) (a.k.a. Registered Controller)
                  Parameter: \(payload.parameter)
                  Change Type (Only applicable for MIDI 2.0; MIDI 1.0 is always absolute): \(payload.change)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .nrpn(payload):
            print(
                """
                Non-Registered Parameter Number (NRPN) (a.k.a. Assignable Controller)
                  Parameter: \(payload.parameter)
                  Change Type (Only applicable for MIDI 2.0; MIDI 1.0 is always absolute): \(payload.change)
                  Channel: \(payload.channel.intValue.hex.stringValue(prefix: true)) ("Channel \(payload.channel.intValue + 1)")
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .sysEx7(payload):
            print(
                """
                System Exclusive 7
                  Manufacturer: \(payload.manufacturer)
                  Data (\(payload.data.count) bytes): \(payload.data.hex.stringValue(padTo: 2))
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .universalSysEx7(payload):
            print(
                """
                Universal System Exclusive 7
                  Type: \(payload.universalType)
                  Device ID: \(payload.deviceID.uInt8Value.hex.stringValue(padTo: 2, prefix: true))
                  Sub ID #1: \(payload.subID1.uInt8Value.hex.stringValue(padTo: 2, prefix: true))
                  Sub ID #2: \(payload.subID2.uInt8Value.hex.stringValue(padTo: 2, prefix: true))
                  Data (\(payload.data.count) bytes): \(payload.data.hex.stringValue(padTo: 2))
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .sysEx8(payload):
            print(
                """
                System Exclusive 8 (MIDI 2.0 Only)
                  Manufacturer: \(payload.manufacturer)
                  Data (\(payload.data.count) bytes): \(payload.data.hex.stringValue(padTo: 2))
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .universalSysEx8(payload):
            print(
                """
                Universal System Exclusive 8 (MIDI 2.0 Only)
                  Type: \(payload.universalType)
                  Device ID: \(payload.deviceID.uInt8Value.hex.stringValue(padTo: 2, prefix: true))
                  Sub ID #1: \(payload.subID1.uInt8Value.hex.stringValue(padTo: 2, prefix: true))
                  Sub ID #2: \(payload.subID2.uInt8Value.hex.stringValue(padTo: 2, prefix: true))
                  Data (\(payload.data.count) bytes): \(payload.data.hex.stringValue(padTo: 2))
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .timecodeQuarterFrame(payload):
            print(
                """
                Timecode Quarter-Frame
                  Data Byte: \(payload.dataByte.uInt8Value.hex.stringValue(padTo: 2, prefix: true))
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .songPositionPointer(payload):
            print(
                """
                Song Position Pointer
                  MIDI Beat: \(payload.midiBeat.intValue.hex.stringValue(prefix: true))
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .songSelect(payload):
            print(
                """
                Song Select
                  Number: \(payload.number.intValue)
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .tuneRequest(payload):
            print(
                """
                Tune Request
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .timingClock(payload):
            print(
                """
                Timing Clock
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .start(payload):
            print(
                """
                Start
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .continue(payload):
            print(
                """
                Continue
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .stop(payload):
            print(
                """
                Stop
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .activeSensing(payload):
            print(
                """
                Active Sensing (Deprecated in MIDI 2.0)
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .systemReset(payload):
            print(
                """
                System Reset
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .noOp(payload):
            print(
                """
                No-Op (MIDI 2.0 Only)
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .jrClock(payload):
            print(
                """
                JR Clock - Jitter-Reduction Clock (MIDI 2.0 Only)
                  Time Value: \(payload.time)
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
            
        case let .jrTimestamp(payload):
            print(
                """
                JR Timestamp - Jitter-Reduction Timestamp (MIDI 2.0 Only)
                  Time Value: \(payload.time)
                  UMP Group (MIDI2): \(payload.group.intValue.hex.stringValue(prefix: true))
                """
            )
        }
    }
}
