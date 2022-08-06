//
//  MIDI2Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    /// Parser for MIDI 2.0 events.
    ///
    /// State is maintained internally. Use one parser class instance per MIDI endpoint for the lifecycle of that endpoint. (ie: Do not generate new parser classes on every event received, and do not use a single global parser class instance for all MIDI endpoints.)
    public class MIDI2Parser {
        // MARK: - Internal Default Instance
        
        /// Internal:
        /// Default static instance for MIDIKit objects that support parsing events without requiring a parser to be instanced first.
        internal static let `default` = MIDI2Parser()
        
        // MARK: - Parser State
        
        private var sysEx7MultiPartUMPBuffer: [MIDI.Byte] = []
        private var sysEx8MultiPartUMPBuffer: [UInt8: [MIDI.Byte]] = [:]
        
        // MARK: - Init
        
        public init() { }
        
        // MARK: - Public Parser Methods
        
        /// Parses raw packet data into an array of MIDI Events.
        public func parsedEvents(
            in packetData: MIDI.IO.Packet.UniversalPacketData
        ) -> [MIDI.Event] {
            parsedEvents(in: packetData.bytes)
        }
        
        /// Parses raw packet data into an array of MIDI Events.
        public func parsedEvents(
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
            
            guard let messageType = MIDI.IO.Packet.UniversalPacketData
                .MessageType(rawValue: byte0Nibbles.high)
            else { return events }
            let group = byte0Nibbles.low
            
            switch messageType {
            case .utility: // 0x0
                // These messages can be standalone 32-bit UMPs or prepend other UMP messages.
                // byte 0: [high nibble: message type, low nibble: group]
                // byte 1: [high nibble: status, low nibble: part of data or reserved segment]
                // bytes 2&3: [continuation of data or reserved]
                // + [potential additional words comprising a UMP such as channel voice etc.]
                
                let midiBytes = bytes[bytes.startIndex.advanced(by: 1)...]
                
                if let parsedEvent = parseMIDI2Utility(
                    bytes: midiBytes,
                    group: group
                ) {
                    events.append(parsedEvent.utilityEvent)
                    
                    // if bytes follow a utility UMP, it may be any non-utility UMP
                    // so attempt to parse it like any normal UMP and add the event(s)
                    if !parsedEvent.followingBytes.isEmpty {
                        let followingEvent = parsedEvents(in: Array(parsedEvent.followingBytes))
                        events.append(contentsOf: followingEvent)
                    }
                }
                
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
                
                let channel = bytes[1].nibbles.low
                
                if let parsedEvent = parseMIDI1ChannelVoice(
                    bytes: midiBytes,
                    channel: channel,
                    group: group
                ) {
                    events.append(parsedEvent)
                }
                
            case .data64bit: // 0x3
                // SysEx7
                
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
                
                let midiBytes = bytes[bytes.startIndex.advanced(by: 1)...]
                
                let channel = bytes[1].nibbles.low
                
                if let parsedEvent = parseMIDI2ChannelVoice(
                    bytes: midiBytes,
                    channel: channel,
                    group: group
                ) {
                    events.append(parsedEvent)
                }
                
            case .data128bit: // 0x5
                // can contain a SysEx8 message
                
                let midiBytes = bytes[bytes.startIndex.advanced(by: 1)...]
                
                if let parsedEvent = parseData128Bit(
                    bytes: midiBytes,
                    group: group
                ) {
                    events.append(parsedEvent)
                }
            }
            
            return events
        }
        
        // MARK: - Internal Parser Methods
        
        /// Internal sub-parser: Parse System RealTime/Common UMP message.
        ///
        /// - Parameters:
        ///   - bytes: 3 UMP bytes after the first byte ([1...3])
        ///   - group: UMP group
        internal func parseSystemRealTimeAndCommon(
            bytes: Array<MIDI.Byte>.SubSequence,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            // ensure packet is 32-bits (4 bytes / 1 UInt32 word) wide
            // (first byte is stripped when bytes are passed into this function so we expect 3 bytes here)
            guard bytes.count == 3 else { return nil }
            
            let statusByte = bytes[bytes.startIndex]
            // let dataByte1: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 1)]
            // let dataByte2: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 2)]
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
                // logger.debug("Unhandled System Status: \(statusByte)")
                return nil
            }
        }
        
        /// Internal sub-parser: Parse MIDI 1.0 Channel Voice UMP message.
        ///
        /// - Parameters:
        ///   - bytes: 3 UMP bytes after the first byte ([1...3])
        ///   - group: UMP group
        internal func parseMIDI1ChannelVoice(
            bytes: Array<MIDI.Byte>.SubSequence,
            channel: MIDI.UInt4,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            // ensure packet is 32-bits (4 bytes / 1 UInt32 word) wide
            // (first byte is stripped when bytes are passed into this function so we expect 3 bytes here)
            guard bytes.count == 3 else { return nil }
            
            let statusNibble = bytes[bytes.startIndex].nibbles.high
            let dataByte1: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 1)]
            let dataByte2: MIDI.Byte = bytes[bytes.startIndex.advanced(by: 2)]
            
            switch statusNibble {
            case 0x8: // note off
                guard let note = dataByte1.toMIDIUInt7Exactly,
                      let velocity = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .noteOff(
                    note,
                    velocity: .midi1(velocity),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0x9: // note on
                guard let note = dataByte1.toMIDIUInt7Exactly,
                      let velocity = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .noteOn(
                    note,
                    velocity: .midi1(velocity),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xA: // poly aftertouch
                guard let note = dataByte1.toMIDIUInt7Exactly,
                      let amount = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .notePressure(
                    note: note,
                    amount: .midi1(amount),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xB: // CC (incl. channel mode msgs 121-127)
                guard let cc = dataByte1.toMIDIUInt7Exactly,
                      let value = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .cc(
                    cc,
                    value: .midi1(value),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xC: // program change
                guard let program = dataByte1.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .programChange(
                    program: program,
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xD: // channel aftertouch
                guard let amount = dataByte1.toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .pressure(
                    amount: .midi1(amount),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xE: // pitch bend
                guard let unwrappedDataByte1 = dataByte1.toMIDIUInt7Exactly,
                      let unwrappedDataByte2 = dataByte2.toMIDIUInt7Exactly
                else { return nil }
                
                let uint14 = MIDI.UInt14(uInt7Pair: .init(
                    msb: unwrappedDataByte2,
                    lsb: unwrappedDataByte1
                ))
                
                let newEvent: MIDI.Event = .pitchBend(
                    value: .midi1(uint14),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            default:
                return nil
            }
        }
        
        /// Internal sub-parser: Parse MIDI 2.0 Channel Voice UMP message.
        ///
        /// - Parameters:
        ///   - bytes: 3 UMP bytes after the first byte ([1...3])
        ///   - channel: MIDI Channel
        ///   - group: UMP group
        internal func parseMIDI2ChannelVoice(
            bytes: Array<MIDI.Byte>.SubSequence,
            channel: MIDI.UInt4,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            // ensure packet is 64-bits (8 bytes / 2 UInt32 words) wide
            // (first byte is stripped when bytes are passed into this function so we expect 7 bytes here)
            guard bytes.count == 7 else { return nil }
            
            // byte 1: [status]
            // byte 2&3: [index]
            // byte 4...7: [data bytes]
            
            let statusNibble = bytes[bytes.startIndex].nibbles.high
            
            // helper methods
            func byte(_ offset: Int) -> MIDI.Byte {
                bytes[bytes.startIndex.advanced(by: offset)]
            }
            func word2() -> MIDI.UMPWord {
                MIDI.UMPWord(
                    bytes[bytes.startIndex.advanced(by: 3)],
                    bytes[bytes.startIndex.advanced(by: 4)],
                    bytes[bytes.startIndex.advanced(by: 5)],
                    bytes[bytes.startIndex.advanced(by: 6)]
                )
            }
            func word2A() -> UInt16 {
                (UInt16(bytes[bytes.startIndex.advanced(by: 3)]) << 8)
                    + UInt16(bytes[bytes.startIndex.advanced(by: 4)])
            }
            func word2B() -> UInt16 {
                (UInt16(bytes[bytes.startIndex.advanced(by: 5)]) << 8)
                    + UInt16(bytes[bytes.startIndex.advanced(by: 6)])
            }
            
            switch statusNibble {
            case 0x0, // Note CC (registered)
                 0x1: // Note CC (assignable)
                guard let note = byte(1).toMIDIUInt7Exactly
                else { return nil }
                
                let index = byte(2)
                
                let cc: MIDI.Event.Note.CC.Controller
                switch statusNibble {
                case 0x0:
                    cc = .registered(.init(number: index))
                    
                case 0x1:
                    cc = .assignable(index)
                    
                default:
                    // should never happen, since parent switch case guarantees 0x00 or 0x01
                    assertionFailure("Status nibble was unexpected.")
                    cc = .assignable(index)
                }
                
                let newEvent: MIDI.Event = .noteCC(
                    note: note,
                    controller: cc,
                    value: .midi2(word2()),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0x6: // note pitchbend
                guard let note = byte(1).toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .notePitchBend(
                    note: note,
                    value: .midi2(word2()),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0x8: // note off
                guard let note = byte(1).toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .noteOff(
                    note,
                    velocity: .midi2(word2A()),
                    attribute: .init(type: byte(2), data: word2B()),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0x9: // note on
                guard let note = byte(1).toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .noteOn(
                    note,
                    velocity: .midi2(word2A()),
                    attribute: .init(type: byte(2), data: word2B()),
                    channel: channel,
                    group: group,
                    midi1ZeroVelocityAsNoteOff: false
                )
                
                return newEvent
                
            case 0xA: // note pressure
                guard let note = byte(1).toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .notePressure(
                    note: note,
                    amount: .midi2(word2()),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xB: // note CC
                guard let index = byte(1).toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .cc(
                    index,
                    value: .midi2(word2()),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xC: // program change (with optional bank select)
                guard let program = byte(3).toMIDIUInt7Exactly,
                      let bankMSB = byte(5).toMIDIUInt7Exactly,
                      let bankLSB = byte(6).toMIDIUInt7Exactly
                else { return nil }
                
                let optionFlags = byte(2)
                let useBankSelect = (optionFlags & 0b0000_0001) == 0b1
                
                let bank: MIDI.Event.ProgramChange.Bank = useBankSelect
                    ? .bankSelect(.init(uInt7Pair: .init(msb: bankMSB, lsb: bankLSB)))
                    : .noBankSelect
                 
                let newEvent: MIDI.Event = .programChange(
                    program: program,
                    bank: bank,
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xD: // channel pressure
                let newEvent: MIDI.Event = .pressure(
                    amount: .midi2(word2()),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xE: // pitch bend
                let newEvent: MIDI.Event = .pitchBend(
                    value: .midi2(word2()),
                    channel: channel,
                    group: group
                )
                
                return newEvent
                
            case 0xF: // note management
                guard let note = byte(1).toMIDIUInt7Exactly
                else { return nil }
                
                let newEvent: MIDI.Event = .noteManagement(
                    note: note,
                    flags: .init(byte: byte(2)),
                    channel: channel,
                    group: group
                )
                
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
        internal func parseData64Bit(
            bytes: Array<MIDI.Byte>.SubSequence,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            // MIDI 2.0 Spec:
            // "The MIDI 1.0 Protocol bracketing method with 0xF0 Start and 0xF7 End Status bytes is not used in the UMP Format. Instead, the SysEx payload is carried in one or more 64-bit UMPs, discarding the 0xF0 and 0xF7 bytes. The standard ID Number (Manufacturer ID, Special ID 0x7D, or Universal System Exclusive ID), Device ID, and Sub-ID#1 & Sub-ID#2 (if applicable) are included in the initial data bytes, just as they are in MIDI 1.0 Protocol message equivalents."
            
            // ensure packet is 64-bits (8 bytes / 2 UInt32 words) wide
            // (first byte is stripped when bytes are passed into this function so we expect 7 bytes here)
            guard bytes.count == 7 else { return nil }
            
            let byte1Nibbles = bytes[bytes.startIndex].nibbles
            
            guard let sysExStatusField = MIDI.IO.Packet.UniversalPacketData
                .SysExStatusField(rawValue: byte1Nibbles.high)
            else { return nil }
            
            let numberOfBytes = byte1Nibbles.low.intValue
            guard (0 ... 6).contains(numberOfBytes) else { return nil }
            
            let payloadBytes = bytes[
                bytes.startIndex.advanced(by: 1)
                    ..<
                    bytes.startIndex.advanced(by: 1 + numberOfBytes)
            ]
            
            switch sysExStatusField {
            case .complete:
                guard let parsedSysEx = try? MIDI.Event.sysEx7(
                    rawBytes: [0xF0] + payloadBytes + [0xF7],
                    group: group
                )
                else { return nil }
                
                return parsedSysEx
                
            case .start:
                sysEx7MultiPartUMPBuffer.removeAll()
                sysEx7MultiPartUMPBuffer.append(contentsOf: payloadBytes)
                
                return nil
                
            case .continue:
                guard !sysEx7MultiPartUMPBuffer.isEmpty else { return nil }
                
                sysEx7MultiPartUMPBuffer.append(contentsOf: payloadBytes)
                return nil
                
            case .end:
                guard !sysEx7MultiPartUMPBuffer.isEmpty else { return nil }
                
                sysEx7MultiPartUMPBuffer.append(contentsOf: payloadBytes)
                
                let fullData = sysEx7MultiPartUMPBuffer
                
                // reset buffer
                sysEx7MultiPartUMPBuffer = []
                
                guard let parsedSysEx = try? MIDI.Event.sysEx7(
                    rawBytes: [0xF0] + fullData + [0xF7],
                    group: group
                )
                else { return nil }
                
                return parsedSysEx
            }
        }
        
        /// Internal sub-parser: Parse SysEx8 UMP message.
        ///
        /// - Parameters:
        ///   - bytes: 15 UMP bytes after the first byte ([1...15])
        ///   - group: UMP group
        internal func parseData128Bit(
            bytes: Array<MIDI.Byte>.SubSequence,
            group: MIDI.UInt4
        ) -> MIDI.Event? {
            // MIDI 2.0 Spec:
            // "System Exclusive 8 messages have many similarities to the MIDI 1.0 Protocol’s original System Exclusive messages, but with the added advantage of allowing all 8 bits of each data byte to be used. By contrast, MIDI 1.0 Protocol System Exclusive requires a 0 in the high bit of every data byte, leaving only 7 bits to carry actual data. A System Exclusive 8 Message is carried in one or more 128-bit UMPs with Message Type 0x5."
            
            // ensure packet is 128-bits (16 bytes / 4 UInt32 words) wide
            // (first byte is stripped when bytes are passed into this function so we expect 15 bytes here)
            guard bytes.count == 15 else { return nil }
            
            let byte1Nibbles = bytes[bytes.startIndex].nibbles
            
            guard let sysExStatusField = MIDI.IO.Packet.UniversalPacketData
                .SysExStatusField(rawValue: byte1Nibbles.high)
            else { return nil }
            
            let numberOfBytes = byte1Nibbles.low.intValue
            guard (1 ... 14).contains(numberOfBytes) else { return nil }
            
            switch sysExStatusField {
            case .complete:
                let payloadBytes = bytes[
                    bytes.startIndex.advanced(by: 1)
                        ..<
                        bytes.startIndex.advanced(by: 1 + numberOfBytes)
                ]
                
                guard let parsedSysEx = try? MIDI.Event.sysEx8(
                    rawBytes: Array(payloadBytes),
                    group: group
                )
                else { return nil }
                
                return parsedSysEx
                
            case .start:
                let streamID = bytes[bytes.startIndex.advanced(by: 1)]
                // include stream ID because MIDI.Event.sysEx8() expects it to be the first byte
                let payloadBytes = bytes[
                    bytes.startIndex.advanced(by: 1)
                        ..<
                        bytes.startIndex.advanced(by: 1 + numberOfBytes)
                ]
                
                sysEx8MultiPartUMPBuffer[streamID] = Array(payloadBytes)
                
                return nil
                
            case .continue:
                let streamID = bytes[bytes.startIndex.advanced(by: 1)]
                
                guard let buffer = sysEx8MultiPartUMPBuffer[streamID],
                      !buffer.isEmpty else { return nil }
                
                let payloadBytes = bytes[
                    bytes.startIndex.advanced(by: 2)
                        ..<
                        bytes.startIndex.advanced(by: 1 + numberOfBytes)
                ]
                
                sysEx8MultiPartUMPBuffer[streamID]?.append(contentsOf: payloadBytes)
                
                return nil
                
            case .end:
                let streamID = bytes[bytes.startIndex.advanced(by: 1)]
                
                guard let buffer = sysEx8MultiPartUMPBuffer[streamID],
                      !buffer.isEmpty else { return nil }
                
                let payloadBytes = bytes[
                    bytes.startIndex.advanced(by: 2)
                        ..<
                        bytes.startIndex.advanced(by: 1 + numberOfBytes)
                ]
                
                // reset buffer
                sysEx8MultiPartUMPBuffer[streamID] = nil
                
                let fullData = buffer + Array(payloadBytes)
                
                guard let parsedSysEx = try? MIDI.Event.sysEx8(
                    rawBytes: fullData,
                    group: group
                )
                else { return nil }
                
                return parsedSysEx
            }
        }
        
        /// Internal sub-parser: Parse MIDI 2.0 Utility message.
        ///
        /// - Parameters:
        ///   - bytes: all bytes after the first byte ([1...])
        ///   - group: UMP group
        internal func parseMIDI2Utility(
            bytes: Array<MIDI.Byte>.SubSequence,
            group: MIDI.UInt4
        ) -> (
            utilityEvent: MIDI.Event,
            followingBytes: Array<MIDI.Byte>.SubSequence
        )? {
            // MIDI 2.0 Spec:
            // "The UMP Format provides a set of Utility Messages. Utility Messages include but are not limited to NOOP and timestamps, and might in the future include UMP transport-related functions."
            // These messages can be standalone 32-bit UMPs or prepend other UMP messages.
            
            // byte 0: [high nibble: message type, low nibble: group]
            // byte 1: [high nibble: status, low nibble: part of data or reserved segment]
            // bytes 2&3: [continuation of data or reserved]
            // + [potential additional words comprising a UMP such as channel voice etc.]
            
            guard bytes.count >= 3 else {
                return nil
            }
            
            let byte1Nibbles = bytes[bytes.startIndex].nibbles
            
            guard let utilityStatusField = MIDI.IO.Packet.UniversalPacketData
                .UtilityStatusField(rawValue: byte1Nibbles.high)
            else { return nil }
            
            let utilityEvent: MIDI.Event
            
            switch utilityStatusField {
            case .noOp: // 0x0
                // NOOP expects 20-bit data portion to be all zeros (0x00000).
                // Technically the message is malformed if it isn't.
                // However there probably isn't any reason why this needs to be strict
                // since a status of 0x0 is NOOP and it carries no data
                // so we could skip checking these bytes.
                
                // NOOP is always a self-contained message and never prepends other UMPs like timestamps could.
                
                return (.noOp(group: group), [])
                
            case .jrClock: // 0x1
                let msb = bytes[bytes.startIndex.advanced(by: 1)]
                let lsb = bytes[bytes.startIndex.advanced(by: 2)]
                let ts = UInt16(bytePair: .init(msb: msb, lsb: lsb))
                
                utilityEvent = .jrClock(
                    time: ts,
                    group: group
                )
                
            case .jrTimestamp: // 0x2
                let msb = bytes[bytes.startIndex.advanced(by: 1)]
                let lsb = bytes[bytes.startIndex.advanced(by: 2)]
                let ts = UInt16(bytePair: .init(msb: msb, lsb: lsb))
                
                utilityEvent = .jrTimestamp(
                    time: ts,
                    group: group
                )
            }
            
            if bytes.count > 3 {
                let followingBytes = bytes[bytes.startIndex.advanced(by: 3)...]
                return (utilityEvent, followingBytes)
            } else {
                return (utilityEvent, [])
            }
        }
    }
}

// MARK: - MIDI.IO.Packet Extensions

extension MIDI.IO.Packet.UniversalPacketData {
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedEvents() -> [MIDI.Event] {
        MIDI.IO.MIDI2Parser.default.parsedEvents(in: bytes)
    }
    
    /// Parse this instance's raw packet data into an array of MIDI Events.
    internal func parsedEvents(using parser: MIDI.IO.MIDI2Parser) -> [MIDI.Event] {
        parser.parsedEvents(in: self)
    }
}

extension MIDI.IO.Packet {
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedMIDI2Events() -> [MIDI.Event] {
        MIDI.IO.MIDI2Parser.default.parsedEvents(in: bytes)
    }
}
