//
//  Event rawBytes.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    public var rawBytes: [MIDI.Byte] {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(note: let note, velocity: let velocity, channel: let channel):
            return [0x90 + channel.uint8, note.uint8, velocity.uint8]
            
        case .noteOff(note: let note, velocity: let velocity, channel: let channel):
            return [0x80 + channel.uint8, note.uint8, velocity.uint8]
            
        case .polyAftertouch(note: let note, pressure: let pressure, channel: let channel):
            return [0xA0 + channel.uint8, note.uint8, pressure.uint8]
            
        case .cc(controller: let controller, value: let value, channel: let channel):
            return [0xB0 + channel.uint8, controller.uint8, value.uint8]
            
        case .programChange(program: let program, channel: let channel):
            return [0xC0 + channel.uint8, program.uint8]
            
        case .chanAftertouch(pressure: let pressure, channel: let channel):
            return [0xD0 + channel.uint8, pressure.uint8]
            
        case .pitchBend(value: let value, channel: let channel):
            let bytePair = value.bytePair
            return [0xE0 + channel.uint8, bytePair.lsb, bytePair.msb]
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(manufacturer: let manufacturer, data: let data):
            return [0xF0] + manufacturer.bytes + data + [0xF7]
            
        case .sysExUniversal(universalType: let universalType,
                             deviceID: let deviceID,
                             subID1: let subID1,
                             subID2: let subID2,
                             data: let data):
            return [0xF0, universalType.rawValue.uint8, deviceID.uint8, subID1.uint8, subID2.uint8] + data + [0xF7]
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(byte: let byte):
            return [0xF1, byte]
            
        case .songPositionPointer(midiBeat: let midiBeat):
            let bytePair = midiBeat.bytePair
            return [0xF2, bytePair.lsb, bytePair.msb]
            
        case .songSelect(number: let number):
            return [0xF3, number.uint8]
            
        case .unofficialBusSelect:
            return [0xF5]
            
        case .tuneRequest:
            return [0xF6]
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock:
            return [0xF8]
            
        case .start:
            return [0xFA]
            
        case .continue:
            return [0xFB]
            
        case .stop:
            return [0xFC]
            
        case .activeSensing:
            return [0xFE]
            
        case .systemReset:
            return [0xFF]
            
        }
        
    }
    
}
