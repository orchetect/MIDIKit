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
            return [0x90 + channel.uInt8Value, note.uInt8Value, velocity.uInt8Value]
            
        case .noteOff(note: let note, velocity: let velocity, channel: let channel):
            return [0x80 + channel.uInt8Value, note.uInt8Value, velocity.uInt8Value]
            
        case .polyAftertouch(note: let note, pressure: let pressure, channel: let channel):
            return [0xA0 + channel.uInt8Value, note.uInt8Value, pressure.uInt8Value]
            
        case .cc(controller: let controller, value: let value, channel: let channel):
            return [0xB0 + channel.uInt8Value, controller.uInt8Value, value.uInt8Value]
            
        case .programChange(program: let program, channel: let channel):
            return [0xC0 + channel.uInt8Value, program.uInt8Value]
            
        case .chanAftertouch(pressure: let pressure, channel: let channel):
            return [0xD0 + channel.uInt8Value, pressure.uInt8Value]
            
        case .pitchBend(value: let value, channel: let channel):
            let bytePair = value.bytePair
            return [0xE0 + channel.uInt8Value, bytePair.lsb, bytePair.msb]
            
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
            return [0xF0,
                    MIDI.Byte(universalType.rawValue),
                    deviceID.uInt8Value,
                    subID1.uInt8Value,
                    subID2.uInt8Value]
                + data
                + [0xF7]
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(byte: let byte):
            return [0xF1, byte]
            
        case .songPositionPointer(midiBeat: let midiBeat):
            let bytePair = midiBeat.bytePair
            return [0xF2, bytePair.lsb, bytePair.msb]
            
        case .songSelect(number: let number):
            return [0xF3, number.uInt8Value]
            
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
