//
//  Event description.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(let event):
            
            return "noteOn(\(event.note), vel: \(event.velocity), chan: \(event.channel), group: \(event.group))"
            
        case .noteOff(let event):
            
            return "noteOff(\(event.note), vel: \(event.velocity), chan: \(event.channel), group: \(event.group))"
            
        case .noteCC(let event):
            
            return "noteCC(note: \(event.note), controller: \(event.controller), val: \(event.value), chan: \(event.channel), group: \(event.group))"
            
        case .notePitchBend(let event):
            
            return "notePitchBend(note: \(event.note), value: \(event.value), chan: \(event.channel), group: \(event.group))"
            
        case .notePressure(let event):
            
            return "notePressure(note:\(event.note), amount: \(event.amount), chan: \(event.channel), group: \(event.group))"
            
        case .noteManagement(let event):
            
            return "noteManagement(options: \(event.optionFlags), chan: \(event.channel), group: \(event.group))"
            
        case .cc(let event):
            
            return "cc(\(event.controller.number), val: \(event.value), chan: \(event.channel), group: \(event.group))"
            
        case .programChange(let event):
            
            switch event.bank {
            case .noBankSelect:
                return "prgChange(\(event.program), chan: \(event.channel), group: \(event.group))"
            case .bankSelect(let bank):
                return "prgChange(\(event.program), bank: \(bank), chan: \(event.channel), group: \(event.group))"
            }
            
        case .pressure(let event):
            
            return "pressure(amount: \(event.amount), chan: \(event.channel), group: \(event.group))"
            
        case .pitchBend(let event):
            
            return "pitchBend(\(event.value), chan: \(event.channel), group: \(event.group))"
            
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(let event):
            
            let dataString = event.data
                .hex.stringValue(padTo: 2, prefix: true)
            
            return "sysEx(mfr: \(event.manufacturer), data: [\(dataString)], group: \(event.group))"
            
        case .universalSysEx(let event):
            
            let dataString = event.data
                .hex.stringValue(padTo: 2, prefix: true)
            
            return "universalSysEx(\(event.universalType), deviceID: \(event.deviceID), subID1: \(event.subID1), subID2: \(event.subID2), data: [\(dataString)], group: \(event.group))"
            
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(let event):
            
            let dataByteString = event.dataByte.uInt8Value
                .binary.stringValue(padTo: 8, splitEvery: 8, prefix: true)
            
            return "timecodeQF(\(dataByteString), group: \(event.group))"
            
        case .songPositionPointer(let event):
            
            return "songPositionPointer(beat: \(event.midiBeat), group: \(event.group))"
            
        case .songSelect(let event):
            
            return "songSelect(number: \(event.number), group: \(event.group))"
            
        case .unofficialBusSelect(let event):
            
            return "unofficialBusSelect(bus: \(event.bus), group: \(event.group))"
            
        case .tuneRequest(let event):
            
            return "tuneRequest(group: \(event.group))"
            
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock(let event):
            
            return "timingClock(group: \(event.group))"
            
        case .start(let event):
            
            return "start(group: \(event.group))"
            
        case .continue(let event):
            
            return "continue(group: \(event.group))"
            
        case .stop(let event):
            
            return "stop(group: \(event.group))"
            
        case .activeSensing(let event):
            
            return "activeSensing(group: \(event.group))"
            
        case .systemReset(let event):
            
            return "systemReset(group: \(event.group))"
            
        }
        
    }
    
    public var debugDescription: String {
        
        description
        
    }
    
}
