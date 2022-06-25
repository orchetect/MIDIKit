//
//  Event description.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import SwiftRadix

extension MIDI.Event: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(let event):
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
            
        case .noteOff(let event):
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
            
        case .noteCC(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "noteCC(note: \(event.note.number) (\(event.note.stringValue())), controller: \(event.controller), val: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case .notePitchBend(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "notePitchBend(note: \(event.note.number) (\(event.note.stringValue())), value: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case .notePressure(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "notePressure(note: \(event.note.number) (\(event.note.stringValue())), amount: \(event.amount), chan: \(channelString), group: \(groupString))"
            
        case .noteManagement(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "noteManagement(options: \(event.optionFlags), chan: \(channelString), group: \(groupString))"
            
        case .cc(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "cc(\(event.controller.number), val: \(event.value), chan: \(channelString), group: \(groupString))"
            
        case .programChange(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            switch event.bank {
            case .noBankSelect:
                return "prgChange(\(event.program), chan: \(channelString), group: \(groupString))"
            case .bankSelect(let bank):
                return "prgChange(\(event.program), bank: \(bank), chan: \(channelString), group: \(groupString))"
            }
            
        case .pressure(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "pressure(amount: \(event.amount), chan: \(channelString), group: \(groupString))"
            
        case .pitchBend(let event):
            let channelString = event.channel.value.hex.stringValue(prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "pitchBend(\(event.value), chan: \(channelString), group: \(groupString))"
            
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx7(let event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "sysEx7(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString))"
            
        case .universalSysEx7(let event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "universalSysEx7(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString))"
            
        case .sysEx8(let event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "sysEx8(mfr: \(event.manufacturer), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
            
        case .universalSysEx8(let event):
            let dataString = event.data.hex.stringValue(padTo: 2, prefix: true)
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "universalSysEx8(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(groupString), streamID: \(event.streamID))"
            
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(let event):
            let dataByteString = event.dataByte.uInt8Value
                .binary.stringValue(padTo: 8, splitEvery: 8, prefix: true)
            
            let groupString = event.group.value.hex.stringValue(prefix: true)
            
            return "timecodeQF(\(dataByteString), group: \(groupString))"
            
        case .songPositionPointer(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "songPositionPointer(beat: \(event.midiBeat), group: \(groupString))"
            
        case .songSelect(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "songSelect(number: \(event.number), group: \(groupString))"
            
        case .unofficialBusSelect(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "unofficialBusSelect(bus: \(event.bus), group: \(groupString))"
            
        case .tuneRequest(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "tuneRequest(group: \(groupString))"
            
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "timingClock(group: \(groupString))"
            
        case .start(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "start(group: \(groupString))"
            
        case .continue(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "continue(group: \(groupString))"
            
        case .stop(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "stop(group: \(groupString))"
            
        case .activeSensing(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "activeSensing(group: \(groupString))"
            
        case .systemReset(let event):
            let groupString = event.group.value.hex.stringValue(prefix: true)
            return "systemReset(group: \(groupString))"
            
        }
        
    }
    
    public var debugDescription: String {
        
        description
        
    }
    
}
