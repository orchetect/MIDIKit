//
//  MIDI1Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Parser for MIDI 1.0 events.
///
/// State is maintained internally. Use one parser class instance per MIDI endpoint for the lifecycle of that endpoint. (ie: Do not generate new parser classes on every event received, and do not use a single global parser class instance for all MIDI endpoints.)
public final class MIDI1Parser {
    // MARK: - Internal Default Instance
        
    /// Internal:
    /// Default static instance for MIDIKit objects that support parsing events without requiring a parser to be instanced first.
    internal static let `default` = MIDI1Parser()
        
    // MARK: - Parser State
        
    /// Interpret received Note On events with a velocity value of 0 as a Note Off event instead.
    internal var translateNoteOnZeroVelocityToNoteOff: Bool = true
        
    internal var runningStatus: Byte?
        
    // MARK: - Init
        
    public init() { }
        
    // MARK: - Public Parser Methods
        
    /// Parses raw packet data into an array of MIDI Events.
    public func parsedEvents(
        in packetData: MIDIPacketData,
        umpGroup: UInt4 = 0
    ) -> [MIDIEvent] {
        let result = Self.parsedEvents(
            in: packetData.bytes,
            runningStatus: runningStatus,
            translateNoteOnZeroVelocityToNoteOff: translateNoteOnZeroVelocityToNoteOff,
            umpGroup: umpGroup
        )
        runningStatus = result.runningStatus
        return result.events
    }
        
    /// Parses raw packet data into an array of MIDI Events.
    public func parsedEvents(
        in bytes: [Byte],
        umpGroup: UInt4 = 0
    ) -> [MIDIEvent] {
        let result = Self.parsedEvents(
            in: bytes,
            runningStatus: runningStatus,
            translateNoteOnZeroVelocityToNoteOff: translateNoteOnZeroVelocityToNoteOff,
            umpGroup: umpGroup
        )
        runningStatus = result.runningStatus
        return result.events
    }
        
    // MARK: - Internal Parser Methods
        
    internal enum ExpectedDataBytes {
        case none
        case exact(Int)
        case sysExOpenEnded
    }
        
    /// Parses raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    ///
    /// Persisted status data is normally the role of the parser class, but this method gives access to an abstracted parsing method by way of injecting and emitting persistent state (ie: running status).
    internal static func parsedEvents(
        in bytes: [Byte],
        runningStatus: Byte? = nil,
        translateNoteOnZeroVelocityToNoteOff: Bool = true,
        umpGroup: UInt4 = 0
    ) -> (
        events: [MIDIEvent],
        runningStatus: Byte?
    ) {
        guard !bytes.isEmpty else {
            return (
                events: [],
                runningStatus: runningStatus
            )
        }
            
        // MIDI 1.0 Spec Parser
            
        var events: [MIDIEvent] = []
            
        var runningStatus: Byte? = runningStatus
        var currentMessageBuffer: [Byte] = []
        var currentPos = 0
            
        var expectedDataBytes: ExpectedDataBytes = .none
            
        func setExpectedBytes(fromNibble: Nibble?) {
            switch fromNibble {
            case 0x8:
                expectedDataBytes = .exact(2)
            case 0x9:
                expectedDataBytes = .exact(2)
            case 0xA:
                expectedDataBytes = .exact(2)
            case 0xB:
                expectedDataBytes = .exact(2)
            case 0xC:
                expectedDataBytes = .exact(1)
            case 0xD:
                expectedDataBytes = .exact(1)
            case 0xE:
                expectedDataBytes = .exact(2)
            case .none:
                expectedDataBytes = .none
            default:
                // should never happen
                expectedDataBytes = .none
            }
        }
            
        setExpectedBytes(fromNibble: runningStatus?.nibbles.high)
            
        func resetCurrentMessage() {
            currentMessageBuffer = []
            currentMessageBuffer.reserveCapacity(bytes.count)
        }
            
        func parseCurrentMessage() {
            if currentMessageBuffer.isEmpty { return }
            events += parseSingleMessage(
                currentMessageBuffer,
                translateNoteOnZeroVelocityToNoteOff: translateNoteOnZeroVelocityToNoteOff,
                umpGroup: umpGroup
            )
            resetCurrentMessage()
        }
            
        while currentPos < bytes.count {
            let currentByte = bytes[currentPos]
                
            let currentByteHighNibble = currentByte.nibbles.high
                
            // look for status byte as first message byte
            switch currentByteHighNibble {
            case 0x8 ... 0xE:
                // channel voice status byte
                    
                // update running status byte
                runningStatus = currentByte
                    
                if !currentMessageBuffer.isEmpty { parseCurrentMessage() }
                    
                // unbounded because these statuses can accept Running Status messages
                setExpectedBytes(fromNibble: currentByteHighNibble)
                    
                currentMessageBuffer.append(currentByte)
                    
            case 0xF:
                // system status byte
                    
                let currentByteLowNibble = currentByte.nibbles.low
                    
                if !currentMessageBuffer.isEmpty,
                   currentByteLowNibble < 0x8
                { parseCurrentMessage() }
                    
                switch currentByteLowNibble {
                case 0x0:
                    // System Exclusive - Start
                    // [0xF0, ... variable number of SysEx bytes]
                        
                    expectedDataBytes = .sysExOpenEnded
                    runningStatus = nil
                    currentMessageBuffer = [currentByte]
                        
                case 0x1:
                    // System Common - timecode quarter-frame
                    // [0xF1, byte]
                        
                    expectedDataBytes = .exact(1)
                    runningStatus = nil
                    currentMessageBuffer = [currentByte]
                        
                case 0x2:
                    // System Common - Song Position Pointer
                    // [0xF2, lsb byte, msb byte]
                        
                    expectedDataBytes = .exact(2)
                    runningStatus = nil
                    currentMessageBuffer = [currentByte]
                        
                case 0x3:
                    // System Common - Song Select
                    // [0xF3, byte]
                        
                    expectedDataBytes = .exact(1)
                    runningStatus = nil
                    currentMessageBuffer = [currentByte]
                        
                case 0x4, 0x5:
                    // System Common - Undefined
                    // [0xF4] / [0xF5]
                        
                    // MIDI 1.0 Spec: ignore these undefined statuses, but we should clear running status
                        
                    expectedDataBytes = .none
                    runningStatus = nil
                    currentMessageBuffer = []
                        
                case 0x6:
                    // System Common - Tune Request
                    // [0xF6]
                        
                    expectedDataBytes = .none
                    runningStatus = nil
                    currentMessageBuffer = [currentByte]
                        
                case 0x7:
                    // System Common - System Exclusive End (EOX / End Of Exclusive)
                    // [variable number of SysEx bytes ... , 0xF7]
                        
                    // 0xF7 is not always present at the end of a SysEx message. A SysEx message can end in any one of several cases:
                    //   - byte 0xF7
                    //   - parsing reaches the end of the MIDI message bytes
                    //   - another Status byte, thus starting a new message
                        
                    expectedDataBytes = .none
                    runningStatus = nil
                    currentMessageBuffer.append(currentByte)
                        
                case 0x8:
                    // System Real Time - Timing Clock
                    // [0xF8]
                        
                    // MIDI 1.0 Spec:
                    //   "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    //   "Real-Time messages should not affect Running Status."
                        
                    // don't change expectedExactNumberOfDataBytes here!
                    events.append(.timingClock(group: umpGroup))
                        
                case 0x9:
                    // System Real Time - Undefined
                    // [0xF9]
                        
                    // MIDI 1.0 Spec:
                    //   "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    //   "Real-Time messages should not affect Running Status."
                        
                    // don't change expectedExactNumberOfDataBytes here!
                    // don't change runningStatus here!
                    break
                        
                case 0xA:
                    // System Real Time - Start
                    // [0xFA]
                        
                    // MIDI 1.0 Spec:
                    //   "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    //   "Real-Time messages should not affect Running Status."
                        
                    // don't change expectedExactNumberOfDataBytes here!
                    // don't change runningStatus here!
                    events.append(.start(group: umpGroup))
                        
                case 0xB:
                    // System Real Time - Continue
                    // [0xFB]
                        
                    // MIDI 1.0 Spec:
                    // "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    // "Real-Time messages should not affect Running Status."
                        
                    // don't change expectedExactNumberOfDataBytes here!
                    // don't change runningStatus here!
                    events.append(.continue(group: umpGroup))
                        
                case 0xC:
                    // System Real Time - Stop
                    // [0xFC]
                        
                    // MIDI 1.0 Spec:
                    //   "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    //   "Real-Time messages should not affect Running Status."
                        
                    // don't change expectedExactNumberOfDataBytes here!
                    // don't change runningStatus here!
                    events.append(.stop(group: umpGroup))
                        
                case 0xD:
                    // System Real Time - Undefined
                    // [0xFD]
                        
                    // MIDI 1.0 Spec:
                    //   "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    //   "Real-Time messages should not affect Running Status."
                        
                    break
                        
                case 0xE:
                    // System Real Time - Active Sensing
                    // [0xFE]
                        
                    // MIDI 1.0 Spec:
                    //   "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    //   "Real-Time messages should not affect Running Status."
                        
                    // don't change expectedExactNumberOfDataBytes here!
                    // don't change runningStatus here!
                    events.append(.activeSensing(group: umpGroup))
                        
                case 0xF:
                    // System Real Time - System Reset
                    // [0xFF]
                        
                    // MIDI 1.0 Spec:
                    // "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    // "Real-Time messages should not affect Running Status."
                        
                    // don't change expectedExactNumberOfDataBytes here!
                    // don't change runningStatus here!
                    events.append(.systemReset(group: umpGroup))
                        
                default:
                    // should never happen
                    assertionFailure("Unhandled MIDI System Status Byte")
                }
                    
            default:
                // data byte
                    
                // if current message is empty, we assume the Running Status byte should be used if it's cached
                if currentMessageBuffer.isEmpty,
                   let runningStatus = runningStatus
                {
                    currentMessageBuffer.append(runningStatus)
                }
                    
                switch expectedDataBytes {
                case .none:
                    // Got a data byte when it was not expected.
                    // This is not an error condition necessarily, just continue parsing
                    break
                        
                case let .exact(numberOfDataBytes):
                    currentMessageBuffer.append(currentByte)
                        
                    if currentMessageBuffer.count == 1 + numberOfDataBytes {
                        parseCurrentMessage()
                    }
                        
                case .sysExOpenEnded:
                    currentMessageBuffer.append(currentByte)
                }
            }
                
            currentPos += 1
        }
            
        // handle remainder of buffer
        parseCurrentMessage()
            
        if !currentMessageBuffer.isEmpty {
            assertionFailure(
                "MIDI Event Parsing ended with residual data in the MIDI packet that was not parsed."
            )
        }
            
        return (
            events: events,
            runningStatus: runningStatus
        )
    }
        
    /// Parse a single MIDI Event from raw bytes.
    ///
    /// Bytes passed into this method should be guaranteed to be a single valid MIDI message.
    ///
    /// - note: This is a helper method only intended to be called internally from within `MIDIPacketData.parseEvents()`.
    internal static func parseSingleMessage(
        _ bytes: [Byte],
        translateNoteOnZeroVelocityToNoteOff: Bool = true,
        umpGroup: UInt4 = 0
    ) -> [MIDIEvent] {
        var events: [MIDIEvent] = []
            
        guard !bytes.isEmpty else { return events }
            
        let statusByte = bytes[0]
            
        let dataByte1: Byte? = bytes.count > 1 ? bytes[1] : nil
        let dataByte2: Byte? = bytes.count > 2 ? bytes[2] : nil
            
        switch statusByte.nibbles.high {
        case 0x8: // note off
            let channel = statusByte.nibbles.low
            guard let note = dataByte1?.toUInt7Exactly,
                  let velocity = dataByte2?.toUInt7Exactly
            else { return events }
                
            let newEvent: MIDIEvent = .noteOff(
                note,
                velocity: .midi1(velocity),
                channel: channel,
                group: umpGroup
            )
                
            events.append(newEvent)
                
        case 0x9: // note on
            let channel = statusByte.nibbles.low
            guard let note = dataByte1?.toUInt7Exactly,
                  let velocity = dataByte2?.toUInt7Exactly
            else { return events }
                
            let newEvent: MIDIEvent
                
            if velocity == 0,
               translateNoteOnZeroVelocityToNoteOff
            {
                // interpret Note On with velocity 0 as a Note Off event instead
                newEvent = .noteOff(
                    note,
                    velocity: .midi1(velocity),
                    channel: channel,
                    group: umpGroup
                )
            } else {
                newEvent = .noteOn(
                    note,
                    velocity: .midi1(velocity),
                    channel: channel,
                    group: umpGroup
                )
            }
                
            events.append(newEvent)
                
        case 0xA: // poly aftertouch
            let channel = statusByte.nibbles.low
            guard let note = dataByte1?.toUInt7Exactly,
                  let amount = dataByte2?.toUInt7Exactly
            else { return events }
                
            let newEvent: MIDIEvent = .notePressure(
                note: note,
                amount: .midi1(amount),
                channel: channel,
                group: umpGroup
            )
                
            events.append(newEvent)
                
        case 0xB: // CC (incl. channel mode msgs 121-127)
            let channel = statusByte.nibbles.low
            guard let cc = dataByte1?.toUInt7Exactly,
                  let value = dataByte2?.toUInt7Exactly
            else { return events }
                
            let newEvent: MIDIEvent = .cc(
                cc,
                value: .midi1(value),
                channel: channel,
                group: umpGroup
            )
                
            events.append(newEvent)
                
        case 0xC: // program change
            let channel = statusByte.nibbles.low
            guard let program = dataByte1?.toUInt7Exactly
            else { return events }
                
            let newEvent: MIDIEvent = .programChange(
                program: program,
                channel: channel,
                group: umpGroup
            )
                
            events.append(newEvent)
                
        case 0xD: // channel aftertouch
            let channel = statusByte.nibbles.low
            guard let amount = dataByte1?.toUInt7Exactly
            else { return events }
                
            let newEvent: MIDIEvent = .pressure(
                amount: .midi1(amount),
                channel: channel,
                group: umpGroup
            )
                
            events.append(newEvent)
                
        case 0xE: // pitch bend
            let channel = statusByte.nibbles.low
            guard let unwrappedDataByte1 = dataByte1,
                  let unwrappedDataByte2 = dataByte2
            else { return events }
                
            let uint14 = UInt14(bytePair: .init(
                msb: unwrappedDataByte2,
                lsb: unwrappedDataByte1
            ))
                
            let newEvent: MIDIEvent = .pitchBend(
                value: .midi1(uint14),
                channel: channel,
                group: umpGroup
            )
                
            events.append(newEvent)
                
        case 0xF: // system message
            switch statusByte.nibbles.low {
            case 0x0: // System Common - SysEx Start
                guard let parsedSysEx = try? MIDIEvent.sysEx7(rawBytes: bytes)
                else { return events }
                    
                events.append(parsedSysEx)
                    
            case 0x1: // System Common - timecode quarter-frame
                guard let unwrappedDataByte1 = dataByte1?.toUInt7Exactly
                else { return events }
                    
                events.append(.timecodeQuarterFrame(dataByte: unwrappedDataByte1))
                    
            case 0x2: // System Common - Song Position Pointer
                guard let unwrappedDataByte1 = dataByte1,
                      let unwrappedDataByte2 = dataByte2
                else { return events }
                    
                let uint14 = UInt14(bytePair: .init(
                    msb: unwrappedDataByte2,
                    lsb: unwrappedDataByte1
                ))
                events.append(.songPositionPointer(midiBeat: uint14))
                    
            case 0x3: // System Common - Song Select
                guard let songNumber = dataByte1?.toUInt7Exactly
                else { return events }
                    
                events.append(.songSelect(number: songNumber))
                    
            case 0x4, 0x5: // System Common - Undefined
                // MIDI 1.0 Spec: ignore these events
                break
                    
            case 0x6: // System Common - Tune Request
                events.append(.tuneRequest(group: umpGroup))
                    
            case 0x7: // System Common - System Exclusive End (EOX / End Of Exclusive)
                // on its own, 0xF7 is ignored
                break
                    
            case 0x8: // System Real Time - Timing Clock
                events.append(.timingClock(group: umpGroup))
                    
            case 0x9: // Real Time - undefined
                break
                    
            case 0xA: // System Real Time - Start
                events.append(.start(group: umpGroup))
                    
            case 0xB: // System Real Time - Continue
                events.append(.continue(group: umpGroup))
                    
            case 0xC: // System Real Time - Stop
                events.append(.stop(group: umpGroup))
                    
            case 0xD: // Real Time - undefined
                break
                    
            case 0xE:
                events.append(.activeSensing(group: umpGroup))
                    
            case 0xF:
                events.append(.systemReset(group: umpGroup))
                    
            default:
                // should never happen
                // logger.debug("Unhandled System Status: \(statusByte)")
                break
            }
                
        default:
            // should never happen
            // logger.debug("Unhandled Status: \(statusByte)")
            break
        }
            
        return events
    }
}

// MARK: - MIDIPacket Extensions

extension MIDIPacketData {
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedEvents() -> [MIDIEvent] {
        MIDI1Parser.default.parsedEvents(in: bytes)
    }
    
    /// Parse this instance's raw packet data into an array of MIDI Events.
    internal func parsedEvents(using parser: MIDI1Parser) -> [MIDIEvent] {
        parser.parsedEvents(in: self)
    }
}

extension AnyMIDIPacket {
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    internal func parsedMIDI1Events() -> [MIDIEvent] {
        MIDI1Parser.default.parsedEvents(in: bytes)
    }
}
