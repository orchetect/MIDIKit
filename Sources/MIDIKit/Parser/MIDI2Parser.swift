//
//  MIDI2Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// Parser for MIDI 2.0 events.
    public class MIDI2Parser {
        
        internal static let midi1Parser: MIDI.MIDI1Parser = .init()
        
        public init() {
            
        }
        
        /// Parse
        public func parsedEvents(in packetData: MIDI.Packet.UniversalPacketData) -> [MIDI.Event] {
            
            Self.parsedEvents(in: packetData.bytes)
            
        }
        
        /// Parses raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
        public static func parsedEvents(
            in bytes: [MIDI.Byte]
        ) -> [MIDI.Event] {
            
            // UMP packet will never be empty and will always be 4-byte aligned (UInt32 words)
            guard !bytes.isEmpty,
                  bytes.count % 4 == 0
            else { return [] }
            
            // MIDI 2.0 Spec Parser
            
            var events: [MIDI.Event] = []
            
            let byte0 = bytes[bytes.startIndex]
            let byte0Nibbles = byte0.nibbles
            
            guard let messageType = MIDI.Packet.UniversalPacketData
                    .MessageType(rawValue: byte0Nibbles.high)
            else { return events }
            let group = byte0Nibbles.low
            
            switch messageType {
            case .utility: // 0x0
                // TODO: nothing implemented here yet
                break
                
            case .systemRealTimeAndCommon: // 0x1
                // always 32 bits (4 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [status]
                // byte 2: [MIDI1 data byte 1, or 0x00 if not applicable]
                // byte 3: [MIDI1 data byte 2, or 0x00 if not applicable]
                
                let midiBytes = bytes[bytes.startIndex.advanced(by: 1)...]
                
                if let parsedEvent = parseSystemRealTimeAndCommon(
                    bytes: midiBytes,
                    group: group
                ) {
                    events.append(parsedEvent)
                }
                
            case .midi1ChannelVoice: // 0x2
                // always 32 bits (4 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [MIDI1 status & channel]
                // byte 2: [MIDI1 data byte 1, or 0x00 if not applicable]
                // byte 3: [MIDI1 data byte 2, or 0x00 if not applicable]
                
                let midiBytes = bytes[bytes.startIndex.advanced(by: 1)...]
                
                if let parsedEvent = parseMIDI1ChannelVoice(
                    bytes: midiBytes,
                    group: group
                ) {
                    events.append(parsedEvent)
                }
                
            case .data64bit: // 0x3
                // SysEx 7
                
                let midiBytes = bytes[bytes.startIndex.advanced(by: 1)...]
                
                if let parsedEvent = parseData64Bit(
                    bytes: midiBytes,
                    group: group
                ) {
                    events.append(parsedEvent)
                }
                
            case .midi2ChannelVoice: // 0x4
                // always 64 bits (8 bytes)
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [status]
                // byte 2&3: [index]
                // byte 4...7: [data bytes]
                
                // TODO: currently MIDIKit can only receive MIDI 1.0 events because
                // we are forcing Protocol 1.0 since MIDI 2.0 events are not
                // implemented yet, so this should never happen (for the time being)
                break
                
            case .data128bit: // 0x5
                // can contain a SysEx 8 message
                
                // TODO: needs implementation
                
                break
                
            }
            
            return events
            
        }
        
        /// Internal sub-parser: Parse System RealTime/Common UMP message.
        ///
        /// - Parameters:
        ///   - bytes: 3 UMP bytes after the first byte ([1...3])
        ///   - group: UMP group
        internal static func parseSystemRealTimeAndCommon(
            bytes: Array<MIDI.Byte>.SubSequence,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            
            // ensure packet is 32-bits (4 bytes / 1 UInt32 word) wide
            // (first byte is stripped when bytes are passed into this function so we expect 3 bytes here)
            guard bytes.count == 3 else { return nil }
            
            let statusByte = bytes[bytes.startIndex]
            //let dataByte1: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 1)]
            //let dataByte2: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 2)]
            func dataByte1() -> MIDI.Byte { bytes[bytes.startIndex.advanced(by: 1)] }
            func dataByte2() -> MIDI.Byte { bytes[bytes.startIndex.advanced(by: 2)] }
            
            switch statusByte {
            case 0xF0: // System Common - SysEx Start
                return nil
                
            case 0xF1: // System Common - timecode quarter-frame
                guard let dataByte = dataByte1().toMIDIUInt7Exactly
                else { return nil }
                
                return .timecodeQuarterFrame(dataByte: dataByte, group: group)
                
            case 0xF2: // System Common - Song Position Pointer
                guard let dataByte1 = dataByte1().toMIDIUInt7Exactly,
                      let dataByte2 = dataByte2().toMIDIUInt7Exactly
                else { return nil }
                
                let uint14 = MIDI.UInt14(uInt7Pair: .init(msb: dataByte2, lsb: dataByte1))
                return .songPositionPointer(midiBeat: uint14, group: group)
                
            case 0xF3: // System Common - Song Select
                guard let songNumber = dataByte1().toMIDIUInt7Exactly
                else { return nil }
                
                return .songSelect(number: songNumber, group: group)
                
            case 0xF4, 0xF5: // System Common - Undefined
                // MIDI 1.0 Spec: ignore these events
                return nil
                
            case 0xF6: // System Common - Tune Request
                return .tuneRequest(group: group)
                
            case 0xF7: // System Common - System Exclusive End (EOX / End Of Exclusive)
                // on its own, 0xF7 is ignored
                return nil
                
            case 0xF8: // System Real Time - Timing Clock
                return .timingClock(group: group)
                
            case 0xF9: // Real Time - undefined
                return nil
                
            case 0xFA: // System Real Time - Start
                return .start(group: group)
                
            case 0xFB: // System Real Time - Continue
                return .continue(group: group)
                
            case 0xFC: // System Real Time - Stop
                return .stop(group: group)
                
            case 0xFD: // Real Time - undefined
                return nil
                
            case 0xFE:
                return .activeSensing(group: group)
                
            case 0xFF:
                return .systemReset(group: group)
                
            default:
                // should never happen
                //Log.debug("Unhandled System Status: \(statusByte)")
                return nil
            }
            
        }
        
        /// Internal sub-parser: Parse MIDI 1.0 Channel Voice UMP message.
        ///
        /// - Parameters:
        ///   - bytes: 3 UMP bytes after the first byte ([1...3])
        ///   - group: UMP group
        internal static func parseMIDI1ChannelVoice(
            bytes: Array<MIDI.Byte>.SubSequence,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            
            // ensure packet is 32-bits (4 bytes / 1 UInt32 word) wide
            // (first byte is stripped when bytes are passed into this function so we expect 3 bytes here)
            guard bytes.count == 3 else { return nil }
            
            let statusByte = bytes[bytes.startIndex]
            let dataByte1: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 1)]
            let dataByte2: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 2)]
            
            switch statusByte.nibbles.high {
            case 0x8: // note off
                let channel = statusByte.nibbles.low
                guard let note = dataByte1.toMIDIUInt7Exactly,
                      let velocity = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .noteOff(note,
                                                    velocity: .midi1(velocity),
                                                    channel: channel,
                                                    group: group)
                
                return newEvent
                
            case 0x9: // note on
                let channel = statusByte.nibbles.low
                guard let note = dataByte1.toMIDIUInt7Exactly,
                      let velocity = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .noteOn(note,
                                                   velocity: .midi1(velocity),
                                                   channel: channel,
                                                   group: group)
                
                return newEvent
                
            case 0xA: // poly aftertouch
                let channel = statusByte.nibbles.low
                guard let note = dataByte1.toMIDIUInt7Exactly,
                      let pressure = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .polyAftertouch(note: note,
                                                           pressure: pressure,
                                                           channel: channel,
                                                           group: group)
                
                return newEvent
                
            case 0xB: // CC (incl. channel mode msgs 121-127)
                let channel = statusByte.nibbles.low
                guard let cc = dataByte1.toMIDIUInt7Exactly,
                      let value = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .cc(cc,
                                               value: .midi1(value),
                                               channel: channel,
                                               group: group)
                
                return newEvent
                
            case 0xC: // program change
                let channel = statusByte.nibbles.low
                guard let program = dataByte1.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .programChange(program: program,
                                                          channel: channel,
                                                          group: group)
                
                return newEvent
                
            case 0xD: // channel aftertouch
                let channel = statusByte.nibbles.low
                guard let pressure = dataByte1.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .chanAftertouch(pressure: pressure,
                                                           channel: channel,
                                                           group: group)
                
                return newEvent
                
            case 0xE: // pitch bend
                let channel = statusByte.nibbles.low
                guard let unwrappedDataByte1 = dataByte1.toMIDIUInt7Exactly,
                      let unwrappedDataByte2 = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let uint14 = MIDI.UInt14(uInt7Pair: .init(msb: unwrappedDataByte2,
                                                          lsb: unwrappedDataByte1))
                
                let newEvent: MIDI.Event = .pitchBend(value: uint14,
                                                      channel: channel,
                                                      group: group)
                
                return newEvent
                
            default:
                return nil
                
            }
            
        }
        
        /// Internal sub-parser: Parse SysEx7 UMP message.
        ///
        /// - Parameters:
        ///   - bytes: 7 UMP bytes after the first byte ([1...7])
        ///   - group: UMP group
        internal static func parseData64Bit(
            bytes: Array<MIDI.Byte>.SubSequence,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            
            // MIDI 2.0 Spec:
            // "The MIDI 1.0 Protocol bracketing method with 0xF0 Start and 0xF7 End Status bytes is not used in the UMP Format. Instead, the SysEx payload is carried in one or more 64-bit UMPs, discarding the 0xF0 and 0xF7 bytes. The standard ID Number (Manufacturer ID, Special ID 0x7D, or Universal System Exclusive ID), Device ID, and Sub-ID#1 & Sub-ID#2 (if applicable) are included in the initial data bytes, just as they are in MIDI 1.0 Protocol message equivalents."
            
            // ensure packet is 64-bits (8 bytes / 2 UInt32 words) wide
            // (first byte is stripped when bytes are passed into this function so we expect 7 bytes here)
            guard bytes.count == 7 else { return nil }
            
            let byte1Nibbles = bytes[bytes.startIndex].nibbles
            
            guard let sysExStatusField = MIDI.Packet.UniversalPacketData
                    .SysExStatusField(rawValue: byte1Nibbles.high)
            else {
                return nil
            }
            
            let numberOfBytes = byte1Nibbles.low.intValue
            
            switch sysExStatusField {
            case .complete:
                guard bytes.count >= numberOfBytes + 2
                else { return nil }
                
                let payloadBytes = bytes[
                    bytes.startIndex.advanced(by: 1)
                        ..<
                        bytes.startIndex.advanced(by: 1 + numberOfBytes)
                ]
                
                guard let parsedSysEx = try? MIDI.Event.sysEx(
                    from: [0xF0] + payloadBytes + [0xF7],
                    group: group
                )
                else { return nil }
                
                return parsedSysEx
                
            case .start:
                #warning("> handle multi-packet SysEx Messages")
                return nil
                
            case .continue:
                #warning("> handle multi-packet SysEx Messages")
                return nil
                
            case .end:
                #warning("> handle multi-packet SysEx Messages")
                return nil
                
            }
            
        }
        
    }
    
}

extension MIDI.Packet.UniversalPacketData {
    
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedEvents() -> [MIDI.Event] {
        
        MIDI.MIDI2Parser.parsedEvents(in: bytes)
        
    }
    
    /// Parse this instance's raw packet data into an array of MIDI Events.
    internal func parsedEvents(using parser: MIDI.MIDI2Parser) -> [MIDI.Event] {
        
        parser.parsedEvents(in: self)
        
    }
    
}

extension MIDI.Packet {
    
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedMIDI2Events() -> [MIDI.Event] {
        
        MIDI.MIDI2Parser.parsedEvents(in: bytes)
        
    }
    
}
