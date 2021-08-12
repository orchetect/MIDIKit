//
//  Event rawBytes.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    public var midi1RawBytes: [MIDI.Byte] {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(note: let note,
                     velocity: let velocity,
                     channel: let channel,
                     group: _):
            
            return [0x90 + channel.uInt8Value, note.uInt8Value, velocity.uInt8Value]
            
        case .noteOff(note: let note,
                      velocity: let velocity,
                      channel: let channel,
                      group: _):
            
            return [0x80 + channel.uInt8Value, note.uInt8Value, velocity.uInt8Value]
            
        case .polyAftertouch(note: let note,
                             pressure: let pressure,
                             channel: let channel,
                             group: _):
            
            return [0xA0 + channel.uInt8Value, note.uInt8Value, pressure.uInt8Value]
            
        case .cc(controller: let controller,
                 value: let value,
                 channel: let channel,
                 group: _):
            
            return [0xB0 + channel.uInt8Value, controller.uInt8Value, value.uInt8Value]
            
        case .programChange(program: let program,
                            channel: let channel,
                            group: _):
            
            return [0xC0 + channel.uInt8Value, program.uInt8Value]
            
        case .chanAftertouch(pressure: let pressure,
                             channel: let channel,
                             group: _):
            
            return [0xD0 + channel.uInt8Value, pressure.uInt8Value]
            
        case .pitchBend(value: let value,
                        channel: let channel,
                        group: _):
            
            let bytePair = value.bytePair
            return [0xE0 + channel.uInt8Value, bytePair.lsb, bytePair.msb]
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(manufacturer: let manufacturer,
                    data: let data,
                    group: _):
            
            return [0xF0] + manufacturer.bytes + data + [0xF7]
            
        case .sysExUniversal(universalType: let universalType,
                             deviceID: let deviceID,
                             subID1: let subID1,
                             subID2: let subID2,
                             data: let data,
                             group: _):
            
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
        
        case .timecodeQuarterFrame(byte: let byte,
                                   group: _):
            
            return [0xF1, byte]
            
        case .songPositionPointer(midiBeat: let midiBeat,
                                  group: _):
            
            let bytePair = midiBeat.bytePair
            return [0xF2, bytePair.lsb, bytePair.msb]
            
        case .songSelect(number: let number,
                         group: _):
            
            return [0xF3, number.uInt8Value]
            
        case .unofficialBusSelect(group: _):
            
            return [0xF5]
            
        case .tuneRequest(group: _):
            
            return [0xF6]
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock(group: _):
            
            return [0xF8]
            
        case .start(group: _):
            
            return [0xFA]
            
        case .continue(group: _):
            
            return [0xFB]
            
        case .stop(group: _):
            
            return [0xFC]
            
        case .activeSensing(group: _):
            
            return [0xFE]
            
        case .systemReset(group: _):
            
            return [0xFF]
            
        }
        
    }
    
}

extension MIDI.Event {
    
    public var umpRawBytes: [MIDI.Byte] {
        
        #warning("> this is incomplete and needs testing; for the time being MIDIKit will only use MIDI 1.0 event raw bytes")
        
        let messageType: MIDI.Packet.UniversalPacketData.MessageType
        
        switch self {
        case .noteOn,
                .noteOff,
                .polyAftertouch,
                .cc,
                .programChange,
                .chanAftertouch,
                .pitchBend:
            
            messageType = .midi1ChannelVoice
            
        case .sysEx, .sysExUniversal:
            
            #warning("> this needs specializing")
            messageType = .data64bit
            
        case .timecodeQuarterFrame,
                .songPositionPointer,
                .songSelect,
                .unofficialBusSelect,
                .tuneRequest,
                .timingClock,
                .start,
                .continue,
                .stop,
                .activeSensing,
                .systemReset:
            
            messageType = .systemRealTimeAndCommon
            
        }
        
        switch self {
            
            // -------------------
            // MARK: Channel Voice
            // -------------------
            
        case .noteOn(note: let note,
                     velocity: let velocity,
                     channel: let channel,
                     group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0x90 + channel.uInt8Value,
                    note.uInt8Value,
                    velocity.uInt8Value]
            
        case .noteOff(note: let note,
                      velocity: let velocity,
                      channel: let channel,
                      group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0x80 + channel.uInt8Value,
                    note.uInt8Value,
                    velocity.uInt8Value]
            
        case .polyAftertouch(note: let note,
                             pressure: let pressure,
                             channel: let channel,
                             group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xA0 + channel.uInt8Value,
                    note.uInt8Value,
                    pressure.uInt8Value]
            
        case .cc(controller: let controller,
                 value: let value,
                 channel: let channel,
                 group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xB0 + channel.uInt8Value,
                    controller.uInt8Value,
                    value.uInt8Value]
            
        case .programChange(program: let program,
                            channel: let channel,
                            group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xC0 + channel.uInt8Value,
                    program.uInt8Value,
                    0x00] // pad an empty byte to fill 4 bytes
            
        case .chanAftertouch(pressure: let pressure,
                             channel: let channel,
                             group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xD0 + channel.uInt8Value,
                    pressure.uInt8Value,
                    0x00] // pad an empty byte to fill 4 bytes
            
        case .pitchBend(value: let value,
                        channel: let channel,
                        group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let bytePair = value.bytePair
            
            return [mtAndGroup,
                    0xE0 + channel.uInt8Value,
                    bytePair.lsb,
                    bytePair.msb]
            
            // ----------------------
            // MARK: System Exclusive
            // ----------------------
            
        case .sysEx(manufacturer: let manufacturer,
                    data: let data,
                    group: let group):
            
            #warning("> this needs proper UMP fomatting")
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup, 0xF0] + manufacturer.bytes + data + [0xF7]
            
        case .sysExUniversal(universalType: let universalType,
                             deviceID: let deviceID,
                             subID1: let subID1,
                             subID2: let subID2,
                             data: let data,
                             group: let group):
            
            #warning("> this needs proper UMP fomatting")
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xF0,
                    MIDI.Byte(universalType.rawValue),
                    deviceID.uInt8Value,
                    subID1.uInt8Value,
                    subID2.uInt8Value]
            + data
            + [0xF7]
            
            // -------------------
            // MARK: System Common
            // -------------------
            
        case .timecodeQuarterFrame(byte: let byte,
                                   group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xF1,
                    byte,
                    0x00] // pad an empty byte to fill 4 bytes
            
        case .songPositionPointer(midiBeat: let midiBeat,
                                  group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let bytePair = midiBeat.bytePair
            
            return [mtAndGroup,
                    0xF2,
                    bytePair.lsb,
                    bytePair.msb]
            
        case .songSelect(number: let number,
                         group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xF3,
                    number.uInt8Value,
                    0x00] // pad an empty byte to fill 4 bytes
            
        case .unofficialBusSelect(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xF5,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
        case .tuneRequest(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xF6,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
            // ----------------------
            // MARK: System Real Time
            // ----------------------
            
        case .timingClock(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xF8,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
        case .start(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xFA,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
        case .continue(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xFB,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
        case .stop(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xFC,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
        case .activeSensing(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xFE,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
        case .systemReset(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            return [mtAndGroup,
                    0xFF,
                    0x00, 0x00] // pad empty bytes to fill 4 bytes
            
        }
        
    }
    
}
