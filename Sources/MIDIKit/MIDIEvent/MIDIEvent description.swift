//
//  MIDIEvent description.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import SwiftRadix

extension MIDIEvent: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case let .noteOn(event):
            let attrStr: String
            switch event.attribute {
            case .none:
                attrStr = ""
            default:
                attrStr = "\(event.attribute), "
            }
            
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "noteOn(\(event.note.number) (\(event.note.stringValue())), vel: \(event.velocity), \(attrStr)chan: \(channelString), group: \(groupString))"
            
        case let .noteOff(event):
            let attrStr: String
            switch event.attribute {
            case .none:
                attrStr = ""
            default:
                attrStr = "\(event.attribute), "
            }
            
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "noteOff(\(event.note.number) (\(event.note.stringValue())), \(attrStr)chan: \(channelString), group: \(groupString))"
            
        case let .noteCC(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "noteCC(note: \(event.note.number) (\(event.note.stringValue())), controller: \(event.controller), val: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case let .notePitchBend(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "notePitchBend(note: \(event.note.number) (\(event.note.stringValue())), value: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case let .notePressure(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "notePressure(note: \(event.note.number) (\(event.note.stringValue())), amount: \(event.amount), chan: \(channelString), group: \(groupString))"
            
        case let .noteManagement(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "noteManagement(options: \(event.optionFlags), chan: \(channelString), group: \(groupString))"
            
        case let .cc(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "cc(\(event.controller.number), val: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case let .programChange(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            switch event.bank {
            case .noBankSelect:
                return "prgChange(\(event.program), chan: \(channelString), group: \(groupString))"
            case let .bankSelect(bank):
                return "prgChange(\(event.program), bank: \(bank), chan: \(channelString), group: \(groupString))"
            }
            
        case let .pressure(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "pressure(amount: \(event.amount), chan: \(channelString), group: \(groupString))"
            
        case let .pitchBend(event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "pitchBend(\(event.value), chan: \(channelString), group: \(groupString))"
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case let .sysEx7(event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "sysEx7(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString))"
            
        case let .universalSysEx7(event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "universalSysEx7(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString))"
            
        case let .sysEx8(event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "sysEx8(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
            
        case let .universalSysEx8(event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "universalSysEx8(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case let .timecodeQuarterFrame(event):
            let dataByteString = event.dataByte.uInt8Value
                .binary.stringValue(padTo: 8, splitEvery: 8, prefix: true)
            
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "timecodeQF(\(dataByteString), group: \(groupString))"
            
        case let .songPositionPointer(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "songPositionPointer(beat: \(event.midiBeat), group: \(groupString))"
            
        case let .songSelect(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "songSelect(number: \(event.number), group: \(groupString))"
            
        case let .unofficialBusSelect(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "unofficialBusSelect(bus: \(event.bus), group: \(groupString))"
            
        case let .tuneRequest(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "tuneRequest(group: \(groupString))"
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case let .timingClock(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "timingClock(group: \(groupString))"
            
        case let .start(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "start(group: \(groupString))"
            
        case let .continue(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "continue(group: \(groupString))"
            
        case let .stop(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "stop(group: \(groupString))"
            
        case let .activeSensing(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "activeSensing(group: \(groupString))"
            
        case let .systemReset(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "systemReset(group: \(groupString))"
        
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
            
        case let .noOp(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "noOp(group: \(groupString))"
            
        case let .jrClock(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "jrClock(\(event.time), group: \(groupString))"
            
        case let .jrTimestamp(event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "jrTimestamp(\(event.time), group: \(groupString))"
        }
    }
    
    public var debugDescription: String {
        description
    }
}
