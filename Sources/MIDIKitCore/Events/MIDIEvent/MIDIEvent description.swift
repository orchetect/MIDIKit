//
//  MIDIEvent description.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIEvent: CustomStringConvertible {
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
            
            let noteString = "\(event.note.number) (\(event.note.stringValue()))"
            
            let midi1VelString = "midi1(\(event.velocity.midi1Value))"
            let midi2VelString = "midi2(\(event.velocity.midi2Value))"
            let velString = "\(midi1VelString)/\(midi2VelString)"
            
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "noteOn(\(noteString), vel: \(velString), \(attrStr)chan: \(channelString), group: \(groupString))"
            
        case let .noteOff(event):
            let attrStr: String
            switch event.attribute {
            case .none:
                attrStr = ""
            default:
                attrStr = "\(event.attribute), "
            }
            
            let noteString = "\(event.note.number) (\(event.note.stringValue()))"
            
            let midi1VelString = "midi1(\(event.velocity.midi1Value))"
            let midi2VelString = "midi2(\(event.velocity.midi2Value))"
            let velString = "\(midi1VelString)/\(midi2VelString)"
            
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "noteOff(\(noteString), vel: \(velString), \(attrStr)chan: \(channelString), group: \(groupString))"
            
        case let .noteCC(event):
            let noteString = "\(event.note.number) (\(event.note.stringValue()))"
            // value is 32-bit MIDI 2 only, so we can't show a MIDI 1 value since it makes no sense
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "noteCC(note: \(noteString), controller: \(event.controller), val: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case let .notePitchBend(event):
            let noteString = "\(event.note.number) (\(event.note.stringValue()))"
            // value is 32-bit MIDI 2 only, so we can't show a MIDI 1 value since it makes no sense
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "notePitchBend(note: \(noteString), value: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case let .notePressure(event):
            let noteString = "\(event.note.number) (\(event.note.stringValue()))"
            
            let midi1ValString = "midi1(\(event.amount.midi1Value))"
            let midi2ValString = "midi2(\(event.amount.midi2Value))"
            let valString = "\(midi1ValString)/\(midi2ValString)"
            
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "notePressure(note: \(noteString), amount: \(valString), chan: \(channelString), group: \(groupString))"
            
        case let .noteManagement(event):
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "noteManagement(options: \(event.optionFlags), chan: \(channelString), group: \(groupString))"
            
        case let .cc(event):
            let midi1ValString = "midi1(\(event.value.midi1Value))"
            let midi2ValString = "midi2(\(event.value.midi2Value))"
            let valString = "\(midi1ValString)/\(midi2ValString)"
            
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "cc(\(event.controller.number), val: \(valString), chan: \(channelString), group: \(groupString))"
            
        case let .programChange(event):
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            switch event.bank {
            case .noBankSelect:
                return "prgChange(\(event.program), chan: \(channelString), group: \(groupString))"
            case let .bankSelect(bank):
                return "prgChange(\(event.program), bank: \(bank), chan: \(channelString), group: \(groupString))"
            }
            
        case let .pressure(event):
            let midi1ValString = "midi1(\(event.amount.midi1Value))"
            let midi2ValString = "midi2(\(event.amount.midi2Value))"
            let valString = "\(midi1ValString)/\(midi2ValString)"
            
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "pressure(amount: \(valString), chan: \(channelString), group: \(groupString))"
            
        case let .pitchBend(event):
            let midi1ValString = "midi1(\(event.value.midi1Value))"
            let midi2ValString = "midi2(\(event.value.midi2Value))"
            let valString = "\(midi1ValString)/\(midi2ValString)"
            
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "pitchBend(\(valString), chan: \(channelString), group: \(groupString))"
            
            // -----------------------------------------------
            // MARK: Channel Voice - Parameter Number Messages
            // -----------------------------------------------
            
        case let .rpn(event):
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "rpn(\(event.parameter), change: \(event.change), chan: \(channelString), group: \(groupString))"
            
        case let .nrpn(event):
            let channelString = event.channel.hexString()
            let groupString = event.group.hexString()
            
            return "nrpn(\(event.parameter), change: \(event.change), chan: \(channelString), group: \(groupString))"
            
            // ----------------------
            // MARK: System Exclusive
            // ----------------------
            
        case let .sysEx7(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.hexString()
            
            return "sysEx7(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString))"
            
        case let .universalSysEx7(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.hexString()
            
            return "universalSysEx7(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString))"
            
        case let .sysEx8(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.hexString()
            
            return "sysEx8(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
            
        case let .universalSysEx8(event):
            let dataString = event.data.hexString(padEachTo: 2, prefixes: true)
            let groupString = event.group.hexString()
            
            return "universalSysEx8(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
            
            // -------------------
            // MARK: System Common
            // -------------------
            
        case let .timecodeQuarterFrame(event):
            let dataByteString = event.dataByte.uInt8Value
                .binaryString(padTo: 8, prefix: true)
            
            let groupString = event.group.hexString()
            
            return "timecodeQF(\(dataByteString), group: \(groupString))"
            
        case let .songPositionPointer(event):
            let groupString = event.group.hexString()
            return "songPositionPointer(beat: \(event.midiBeat), group: \(groupString))"
            
        case let .songSelect(event):
            let groupString = event.group.hexString()
            return "songSelect(number: \(event.number), group: \(groupString))"
            
        case let .tuneRequest(event):
            let groupString = event.group.hexString()
            return "tuneRequest(group: \(groupString))"
            
            // ----------------------
            // MARK: System Real-Time
            // ----------------------
            
        case let .timingClock(event):
            let groupString = event.group.hexString()
            return "timingClock(group: \(groupString))"
            
        case let .start(event):
            let groupString = event.group.hexString()
            return "start(group: \(groupString))"
            
        case let .continue(event):
            let groupString = event.group.hexString()
            return "continue(group: \(groupString))"
            
        case let .stop(event):
            let groupString = event.group.hexString()
            return "stop(group: \(groupString))"
            
        case let .activeSensing(event):
            let groupString = event.group.hexString()
            return "activeSensing(group: \(groupString))"
            
        case let .systemReset(event):
            let groupString = event.group.hexString()
            return "systemReset(group: \(groupString))"
            
            // -------------------------------
            // MARK: MIDI 2.0 Utility Messages
            // -------------------------------
            
        case let .noOp(event):
            let groupString = event.group.hexString()
            return "noOp(group: \(groupString))"
            
        case let .jrClock(event):
            let groupString = event.group.hexString()
            return "jrClock(\(event.time), group: \(groupString))"
            
        case let .jrTimestamp(event):
            let groupString = event.group.hexString()
            return "jrTimestamp(\(event.time), group: \(groupString))"
        }
    }
}

extension MIDIEvent: CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }
}
