//
//  MIDIEvent description.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
    
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "noteOn(\(event.note.number) (\(event.note.stringValue())), vel: \(event.velocity), \(attrStr)chan: \(channelString), group: \(groupString))"
    
        case let .noteOff(event):
            let attrStr: String
            switch event.attribute {
            case .none:
                attrStr = ""
            default:
                attrStr = "\(event.attribute), "
            }
    
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "noteOff(\(event.note.number) (\(event.note.stringValue())), \(attrStr)chan: \(channelString), group: \(groupString))"
    
        case let .noteCC(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "noteCC(note: \(event.note.number) (\(event.note.stringValue())), controller: \(event.controller), val: \(event.value), chan: \(channelString), group: \(groupString))"
    
        case let .notePitchBend(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "notePitchBend(note: \(event.note.number) (\(event.note.stringValue())), value: \(event.value), chan: \(channelString), group: \(groupString))"
    
        case let .notePressure(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "notePressure(note: \(event.note.number) (\(event.note.stringValue())), amount: \(event.amount), chan: \(channelString), group: \(groupString))"
    
        case let .noteManagement(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "noteManagement(options: \(event.optionFlags), chan: \(channelString), group: \(groupString))"
    
        case let .cc(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "cc(\(event.controller.number), val: \(event.value), chan: \(channelString), group: \(groupString))"
    
        case let .programChange(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            switch event.bank {
            case .noBankSelect:
                return "prgChange(\(event.program), chan: \(channelString), group: \(groupString))"
            case let .bankSelect(bank):
                return "prgChange(\(event.program), bank: \(bank), chan: \(channelString), group: \(groupString))"
            }
    
        case let .pressure(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "pressure(amount: \(event.amount), chan: \(channelString), group: \(groupString))"
    
        case let .pitchBend(event):
            let channelString = event.channel.value.hexString()
            let groupString = event.group.value.hexString()
    
            return "pitchBend(\(event.value), chan: \(channelString), group: \(groupString))"
    
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
    
        case let .sysEx7(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.value.hexString()
    
            return "sysEx7(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString))"
    
        case let .universalSysEx7(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.value.hexString()
    
            return "universalSysEx7(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString))"
    
        case let .sysEx8(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.value.hexString()
    
            return "sysEx8(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
    
        case let .universalSysEx8(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.value.hexString()
    
            return "universalSysEx8(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
    
        // -------------------
        // MARK: System Common
        // -------------------
    
        case let .timecodeQuarterFrame(event):
            let dataByteString = event.dataByte.uInt8Value
                .binaryString(padTo: 8, prefix: true)
    
            let groupString = event.group.value.hexString()
    
            return "timecodeQF(\(dataByteString), group: \(groupString))"
    
        case let .songPositionPointer(event):
            let groupString = event.group.value.hexString()
            return "songPositionPointer(beat: \(event.midiBeat), group: \(groupString))"
    
        case let .songSelect(event):
            let groupString = event.group.value.hexString()
            return "songSelect(number: \(event.number), group: \(groupString))"
    
        case let .unofficialBusSelect(event):
            let groupString = event.group.value.hexString()
            return "unofficialBusSelect(bus: \(event.bus), group: \(groupString))"
    
        case let .tuneRequest(event):
            let groupString = event.group.value.hexString()
            return "tuneRequest(group: \(groupString))"
    
        // ----------------------
        // MARK: System Real Time
        // ----------------------
    
        case let .timingClock(event):
            let groupString = event.group.value.hexString()
            return "timingClock(group: \(groupString))"
    
        case let .start(event):
            let groupString = event.group.value.hexString()
            return "start(group: \(groupString))"
    
        case let .continue(event):
            let groupString = event.group.value.hexString()
            return "continue(group: \(groupString))"
    
        case let .stop(event):
            let groupString = event.group.value.hexString()
            return "stop(group: \(groupString))"
    
        case let .activeSensing(event):
            let groupString = event.group.value.hexString()
            return "activeSensing(group: \(groupString))"
    
        case let .systemReset(event):
            let groupString = event.group.value.hexString()
            return "systemReset(group: \(groupString))"
    
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
    
        case let .noOp(event):
            let groupString = event.group.value.hexString()
            return "noOp(group: \(groupString))"
    
        case let .jrClock(event):
            let groupString = event.group.value.hexString()
            return "jrClock(\(event.time), group: \(groupString))"
    
        case let .jrTimestamp(event):
            let groupString = event.group.value.hexString()
            return "jrTimestamp(\(event.time), group: \(groupString))"
        }
    }
    
    public var debugDescription: String {
        description
    }
}
