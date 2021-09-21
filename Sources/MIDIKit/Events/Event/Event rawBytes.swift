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
        
        case .noteOn(let event):
            return event.midi1RawBytes()
            
        case .noteOff(let event):
            return event.midi1RawBytes()
            
        case .polyAftertouch(let event):
            return event.midi1RawBytes()
            
        case .cc(let event):
            return event.midi1RawBytes()
            
        case .programChange(let event):
            return event.midi1RawBytes()
            
        case .chanAftertouch(let event):
            return event.midi1RawBytes()
            
        case .pitchBend(let event):
            return event.midi1RawBytes()
            
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(let event):
            return event.midi1RawBytes()
            
        case .universalSysEx(let event):
            return event.midi1RawBytes()
            
            
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
    
    public var umpRawWords: [MIDI.UMPWord] {
        
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
            
        case .sysEx, .universalSysEx:
            
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
        
        case .noteOn(let event):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0x90 + event.channel.uInt8Value,
                                    event.note.uInt8Value,
                                    event.velocity.uInt8Value)
            
            return [word]
            
        case .noteOff(let event):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0x80 + event.channel.uInt8Value,
                                    event.note.uInt8Value,
                                    event.velocity.uInt8Value)
            
            return [word]
            
        case .polyAftertouch(let event):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xA0 + event.channel.uInt8Value,
                                    event.note.uInt8Value,
                                    event.pressure.uInt8Value)
            
            return [word]
            
        case .cc(let event):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xB0 + event.channel.uInt8Value,
                                    event.controller.number.uInt8Value,
                                    event.value.uInt8Value)
            
            return [word]
            
        case .programChange(let event):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xC0 + event.channel.uInt8Value,
                                    event.program.uInt8Value,
                                    0x00) // pad an empty byte to fill 4 bytes
            
            return [word]
            
        case .chanAftertouch(let event):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xD0 + event.channel.uInt8Value,
                                    event.pressure.uInt8Value,
                                    0x00) // pad an empty byte to fill 4 bytes
            
            return [word]
            
        case .pitchBend(let event):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            let bytePair = event.value.bytePair
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xE0 + event.channel.uInt8Value,
                                    bytePair.lsb,
                                    bytePair.msb)
            
            return [word]
            
        // ----------------------
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(let event):
            
            #warning("> this needs proper UMP fomatting")
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            
            _ = event.manufacturer
            _ = event.data
            
            return []
            
        case .universalSysEx(let event):
            
            #warning("> this needs proper UMP fomatting")
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + event.group
            _ = event.subID1
            _ = event.universalType
            _ = event.deviceID
            _ = event.subID1
            _ = event.subID2
            _ = event.data
            
            return []
            
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(byte: let byte,
                                   group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xF1,
                                    byte,
                                    0x00) // pad an empty byte to fill 4 bytes
            
            return [word]
            
        case .songPositionPointer(midiBeat: let midiBeat,
                                  group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let bytePair = midiBeat.bytePair
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xF2,
                                    bytePair.lsb,
                                    bytePair.msb)
            
            return [word]
            
        case .songSelect(number: let number,
                         group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xF3,
                                    number.uInt8Value,
                                    0x00) // pad an empty byte to fill 4 bytes
            
            return [word]
            
        case .unofficialBusSelect(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xF5,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
        case .tuneRequest(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xF6,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xF8,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
        case .start(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xFA,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
        case .continue(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xFB,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
        case .stop(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xFC,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
        case .activeSensing(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xFE,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
        case .systemReset(group: let group):
            
            let mtAndGroup = (messageType.rawValue.uInt8Value << 4) + group
            
            let word = MIDI.UMPWord(mtAndGroup,
                                    0xFF,
                                    0x00, // pad empty bytes to fill 4 bytes
                                    0x00) // pad empty bytes to fill 4 bytes
            
            return [word]
            
        }
        
    }
    
}
