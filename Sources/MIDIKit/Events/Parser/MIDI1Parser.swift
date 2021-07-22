//
//  MIDI1Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

@_implementationOnly import OTCore

extension MIDI {
    
    /// Parser for MIDI 1.0 events.
    ///
    /// Running status is maintained internally. Use one parser class instance per MIDI endpoint for the lifecycle of that endpoint. (ie: Do not generate new parser classes on every event received, and do not use a single global parser class instance for all MIDI endpoints.)
    public class MIDI1Parser {
        
        internal var runningStatus: MIDI.Byte? = nil
        
        /// Parse
        public func parsedEvents(in packetData: MIDI.PacketData) -> [MIDI.Event] {
            
            let result = Self.parsedEvents(in: packetData.data,
                                           runningStatus: runningStatus)
            runningStatus = result.runningStatus
            return result.events
            
        }
        
        /// Parses raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
        ///
        /// Persisted status data is normally the role of the parser class, but this method gives access to an abstracted parsing method by way of injecting and emitting persistent state (ie: running status).
        public static func parsedEvents(
            in data: Data,
            runningStatus: MIDI.Byte? = nil
        ) -> (events: [MIDI.Event],
              runningStatus: MIDI.Byte?)
        {
            
            guard !data.isEmpty else {
                return (events: [],
                        runningStatus: runningStatus)
            }
            
            // MIDI 1.0 Spec Parser
            
            var events: [MIDI.Event] = []
            
            var runningStatus: MIDI.Byte? = runningStatus
            var currentMessage: [MIDI.Byte] = []
            var queuedMessages: [MIDI.Event] = []
            var currentPos = 0
            
            func resetCurrentMessage() {
                currentMessage = []
                currentMessage.reserveCapacity(data.count)
            }
            
            func parseCurrentMessage() {
                if currentMessage.isEmpty && queuedMessages.isEmpty { return }
                events += parseSingleMessageOrUniformRunningStatusMessages(currentMessage)
                events += queuedMessages
                queuedMessages.removeAll()
                resetCurrentMessage()
            }
            
            while currentPos < data.count {
                
                let currentByte = data[currentPos]
                
                // look for status byte as first message byte
                switch currentByte.nibbles.high {
                case 0x8...0xE: // status byte
                    if currentPos > 0 { parseCurrentMessage() }
                    switch currentByte.nibbles.high {
                    case 0x8, 0x9, 0xB: // note off, note on, CC/mode
                        runningStatus = currentByte
                    default:
                        runningStatus = nil
                    }
                    currentMessage += currentByte
                    currentPos += 1
                    continue
                    
                case 0xF: // system status byte
                    // MIDI 1.0 Spec: "Real Time messages can be sent at any time and may be inserted anywhere in a MIDI data stream, including between Status and Data bytes of any other MIDI messages."
                    
                    switch currentByte.nibbles.low {
                    case 0x0: // System Exclusive - Start
                        currentMessage += currentByte
                    case 0x1: // System Common - timecode quarter-frame
                        currentMessage += currentByte
                    case 0x2: // System Common - Song Position Pointer
                        currentMessage += currentByte
                    case 0x3: // System Common - Song Select
                        currentMessage += currentByte
                    case 0x4, 0x5: // undefined System Common bytes
                        // MIDI 1.0 Spec: ignore these events, but we should clear running status
                        runningStatus = nil
                    case 0x6: // System Common - Tune Request
                        currentMessage += currentByte
                    case 0x7: // System Common - System Exclusive End (EOX / End Of Exclusive)
                        // 0xF7 is not always present at the end of a SysEx message. A SysEx message can end in any one of several cases:
                        //   - byte 0xF7
                        //   - parsing reaches the end of the MIDI message bytes
                        //   - another Status byte, thus starting a new message
                        runningStatus = nil
                        currentMessage += currentByte
                    case 0x8: // System Real Time - Timing Clock
                        runningStatus = nil
                        queuedMessages += .timingClock
                    case 0x9: // Real Time - undefined
                        // MIDI 1.0 Spec: "Real-Time messages should not affect Running Status."
                        break
                    case 0xA: // System Real Time - Start
                        // MIDI 1.0 Spec: "Real-Time messages should not affect Running Status."
                        queuedMessages += .start
                    case 0xB: // System Real Time - Continue
                        // MIDI 1.0 Spec: "Real-Time messages should not affect Running Status."
                        queuedMessages += .continue
                    case 0xC: // System Real Time - Stop
                        // MIDI 1.0 Spec: "Real-Time messages should not affect Running Status."
                        queuedMessages += .stop
                    case 0xD: // Real Time - undefined
                        // MIDI 1.0 Spec: "Real-Time messages should not affect Running Status."
                        break
                    case 0xE:
                        runningStatus = nil
                        queuedMessages += .activeSensing
                    case 0xF:
                        runningStatus = nil
                        queuedMessages += .systemReset
                    default:
                        break // should never happen
                    }
                    
                    currentPos += 1
                    continue
                    
                default: // data byte
                    if currentMessage.isEmpty {
                        if let runningStatus = runningStatus {
                            // byte is a running status data byte, following a previously received (and cached) running status byte
                            // set the status byte to the start of the message before appending data bytes
                            currentMessage += runningStatus
                            currentMessage += currentByte
                            currentPos += 1
                            continue
                        } else {
                            // unless running status is active, data bytes should never be the first byte in a message
                            currentPos = data.count
                            continue
                        }
                    } else {
                        currentMessage += currentByte
                        currentPos += 1
                        continue
                    }
                    
                }
                
            }
            
            parseCurrentMessage()
            
            if !currentMessage.isEmpty {
                assertionFailure("MIDI Event Parsing ended with residual data in the MIDI packet that was not parsed.")
            }
            
            return (events: events,
                    runningStatus: runningStatus)
            
        }
        
        /// Parse MIDI Event(s) from raw bytes.
        ///
        /// Bytes passed into this method should be guaranteed to be a single valid MIDI message, or in the event of Running Status, a series of events sharing the same MIDI status byte.
        /// In the event of Running Status, this may return more than one event.
        ///
        /// - note: This is a helper method only intended to be called internally from within `MIDI.PacketData.parseEvents()`.
        internal static func parseSingleMessageOrUniformRunningStatusMessages(
            _ bytes: [MIDI.Byte]
        ) -> [MIDI.Event] {

            var events: [MIDI.Event] = []
            
            guard let statusByte = bytes[safe: 0] else { return events }
            var currentPos = 0
            
            while currentPos < bytes.count {
                
                let dataByte1 = bytes[safe: currentPos + (currentPos == 0 ? 1 : 0)]
                let dataByte2 = bytes[safe: currentPos + (currentPos == 0 ? 2 : 1)]
                
                switch statusByte.nibbles.high {
                case 0x8: // note off
                    let channel = statusByte.nibbles.low
                    guard let note = dataByte1?.midiUInt7,
                          let velocity = dataByte2?.midiUInt7
                    else { return events }
                    
                    events += .noteOff(note: note, velocity: velocity, channel: channel)
                    currentPos += currentPos == 0 ? 3 : 2
                    
                case 0x9: // note on
                    let channel = statusByte.nibbles.low
                    guard let note = dataByte1?.midiUInt7,
                          let velocity = dataByte2?.midiUInt7
                    else { return events }
                    
                    events += .noteOn(note: note, velocity: velocity, channel: channel)
                    currentPos += currentPos == 0 ? 3 : 2
                    
                case 0xA: // poly aftertouch
                    let channel = statusByte.nibbles.low
                    guard let note = dataByte1?.midiUInt7,
                          let pressure = dataByte2?.midiUInt7
                    else { return events }
                    
                    events += .polyAftertouch(note: note, pressure: pressure, channel: channel)
                    currentPos += currentPos == 0 ? 3 : 2
                    
                case 0xB: // CC (incl. channel mode msgs 121-127)
                    let channel = statusByte.nibbles.low
                    guard let cc = dataByte1?.midiUInt7,
                          let value = dataByte2?.midiUInt7
                    else { return events }
                    
                    events += .cc(controller: cc, value: value, channel: channel)
                    currentPos += currentPos == 0 ? 3 : 2
                    
                case 0xC: // program change
                    let channel = statusByte.nibbles.low
                    guard let program = dataByte1?.midiUInt7
                    else { return events }
                    
                    events += .programChange(program: program, channel: channel)
                    currentPos += currentPos == 0 ? 2 : 1
                    
                case 0xD: // channel aftertouch
                    let channel = statusByte.nibbles.low
                    guard let pressure = dataByte1?.midiUInt7
                    else { return events }
                    
                    events += .chanAftertouch(pressure: pressure, channel: channel)
                    currentPos += currentPos == 0 ? 2 : 1
                    
                case 0xE: // pitch bend
                    let channel = statusByte.nibbles.low
                    guard let dataByte1 = dataByte1,
                          let dataByte2 = dataByte2
                    else { return events }
                    
                    let uint14 = MIDI.UInt14(bytePair: .init(msb: dataByte2, lsb: dataByte1))
                    events += .pitchBend(value: uint14, channel: channel)
                    currentPos += currentPos == 0 ? 3 : 2
                    
                case 0xF: // system message
                    switch statusByte.nibbles.low {
                    case 0x0: // SysEx Start
                        guard let parsedSysEx = try? MIDI.Event.SysEx.parsed(from: bytes)
                        else { return events }
                        
                        events += parsedSysEx
                        
                        // MIDI 1.0 Spec: if a MIDI packet contains a SysEx, the entire packet is guaranteed to only be the single SysEx and not contain additional MIDI messages or SysEx messages.
                        currentPos = bytes.count
                        
                    case 0x1: // System Common - timecode quarter-frame
                        guard let dataByte = dataByte1
                        else { return events }
                        
                        events += .timecodeQuarterFrame(byte: dataByte)
                        currentPos += currentPos == 0 ? 2 : 1
                     
                    case 0x2: // System Common - Song Position Pointer
                        guard let dataByte1 = dataByte1,
                              let dataByte2 = dataByte2
                        else { return events }
                        
                        let uint14 = MIDI.UInt14(bytePair: .init(msb: dataByte2, lsb: dataByte1))
                        events += .songPositionPointer(midiBeat: uint14)
                        currentPos += currentPos == 0 ? 3 : 2
                        
                    case 0x3: // System Common - Song Select
                        guard let songNumber = dataByte1?.midiUInt7
                        else { return events }
                        
                        events += .songSelect(number: songNumber)
                        currentPos += currentPos == 0 ? 2 : 1
                        
                    case 0x4, 0x5: // undefined System Common bytes
                        // MIDI 1.0 Spec: ignore these events
                        currentPos += 1
                        
                    case 0x6: // System Common - Tune Request
                        events += .tuneRequest
                        currentPos += 1
                        
                    case 0x7: // System Common - System Exclusive End (EOX / End Of Exclusive)
                        // on its own, 0xF7 is ignored
                        currentPos += 1
                        
                    case 0x8: // System Real Time - Timing Clock
                        events += .timingClock
                        currentPos += 1
                        
                    case 0x9: // Real Time - undefined
                        currentPos += 1
                        
                    case 0xA: // System Real Time - Start
                        events += .start
                        currentPos += 1
                        
                    case 0xB: // System Real Time - Continue
                        events += .continue
                        currentPos += 1
                        
                    case 0xC: // System Real Time - Stop
                        events += .stop
                        currentPos += 1
                        
                    case 0xD: // Real Time - undefined
                        currentPos += 1
                        
                    case 0xE:
                        events += .activeSensing
                        currentPos += 1
                        
                    case 0xF:
                        events += .systemReset
                        currentPos += 1
                        
                    default:
                        // should never happen, but just in case we will increment the position to avoid infinite loops if the code above ever changes
                        Log.debug("Unhandled System Status: \(statusByte)")
                        currentPos += 1
                    }
                    
                default:
                    // should never happen, but just in case we will increment the position to avoid infinite loops if the code above ever changes
                    Log.debug("Unhandled Status: \(statusByte)")
                    currentPos += 1
                }
                
            }
            
            return events

        }
        
    }
    
}

extension MIDI.PacketData {
    
    /// Parse this instance's raw packet data into an array of MIDI Events.
    internal func parsedEvents(using parser: MIDI.MIDI1Parser) -> [MIDI.Event] {
        
        parser.parsedEvents(in: self)
        
    }
    
    /// Parse raw packet data into an array of MIDI Events, without instancing a MIDI parser object.
    ///
    /// Persisted status data is normally the role of the parser class, but this method gives access to an abstracted parsing method by way of injecting and emitting persistent state (ie: running status).
    internal func parsedMIDI1Events(
        runningStatus: MIDI.Byte? = nil
    ) -> (events: [MIDI.Event],
          runningStatus: MIDI.Byte?) {
        
        MIDI.MIDI1Parser.parsedEvents(in: data, runningStatus: runningStatus)
        
    }
    
}
