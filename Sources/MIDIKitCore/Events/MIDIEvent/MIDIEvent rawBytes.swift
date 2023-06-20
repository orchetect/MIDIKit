//
//  MIDIEvent rawBytes.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
    
        case let .noteOn(event):
            return event.midi1RawBytes()
    
        case let .noteOff(event):
            return event.midi1RawBytes()
    
        case .noteCC:
            return []
    
        case .notePitchBend:
            return []
    
        case let .notePressure(event):
            return event.midi1RawBytes()
    
        case .noteManagement:
            return []
    
        case let .cc(event):
            return event.midi1RawBytes()
    
        case let .programChange(event):
            return event.midi1RawBytes()
    
        case let .pressure(event):
            return event.midi1RawBytes()
    
        case let .pitchBend(event):
            return event.midi1RawBytes()
    
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case let .rpn(event):
            return event.midi1RawBytes()
            
        case let .nrpn(event):
            return event.midi1RawBytes()
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
    
        case let .sysEx7(event):
            return event.midi1RawBytes()
    
        case let .universalSysEx7(event):
            return event.midi1RawBytes()
    
        case .sysEx8:
            return []
    
        case .universalSysEx8:
            return []
    
        // -------------------
        // MARK: System Common
        // -------------------
    
        case let .timecodeQuarterFrame(event):
            return event.midi1RawBytes()
    
        case let .songPositionPointer(event):
            return event.midi1RawBytes()
    
        case let .songSelect(event):
            return event.midi1RawBytes()
    
        case let .unofficialBusSelect(event):
            return event.midi1RawBytes()
    
        case let .tuneRequest(event):
            return event.midi1RawBytes()
    
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
    
        case let .timingClock(event):
            return event.midi1RawBytes()
    
        case let .start(event):
            return event.midi1RawBytes()
    
        case let .continue(event):
            return event.midi1RawBytes()
    
        case let .stop(event):
            return event.midi1RawBytes()
    
        case let .activeSensing(event):
            return event.midi1RawBytes()
    
        case let .systemReset(event):
            return event.midi1RawBytes()
    
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
    
        case .noOp:
            return []
    
        case .jrClock:
            return []
    
        case .jrTimestamp:
            return []
        }
    }
    
    /// Returns the raw MIDI 1.0 status byte for the event if the event is compatible with MIDI 1.0.
    public func midi1RawStatusByte() -> UInt8? {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
            
        case let .noteOn(event):
            return event.midi1RawStatusByte()
            
        case let .noteOff(event):
            return event.midi1RawStatusByte()
            
        case .noteCC:
            return nil
            
        case .notePitchBend:
            return nil
            
        case let .notePressure(event):
            return event.midi1RawStatusByte()
            
        case .noteManagement:
            return nil
            
        case let .cc(event):
            return event.midi1RawStatusByte()
            
        case let .programChange(event):
            return event.midi1RawStatusByte()
            
        case let .pressure(event):
            return event.midi1RawStatusByte()
            
        case let .pitchBend(event):
            return event.midi1RawStatusByte()
            
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case .rpn:
            return nil // technically multiple events
            
        case .nrpn:
            return nil // technically multiple events
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
            
        case let .sysEx7(event):
            return event.midi1RawStatusByte()
            
        case let .universalSysEx7(event):
            return event.midi1RawStatusByte()
            
        case .sysEx8:
            return nil
            
        case .universalSysEx8:
            return nil
            
        // -------------------
        // MARK: System Common
        // -------------------
            
        case let .timecodeQuarterFrame(event):
            return event.midi1RawStatusByte()
            
        case let .songPositionPointer(event):
            return event.midi1RawStatusByte()
            
        case let .songSelect(event):
            return event.midi1RawStatusByte()
            
        case let .unofficialBusSelect(event):
            return event.midi1RawStatusByte()
            
        case let .tuneRequest(event):
            return event.midi1RawStatusByte()
            
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
            
        case let .timingClock(event):
            return event.midi1RawStatusByte()
            
        case let .start(event):
            return event.midi1RawStatusByte()
            
        case let .continue(event):
            return event.midi1RawStatusByte()
            
        case let .stop(event):
            return event.midi1RawStatusByte()
            
        case let .activeSensing(event):
            return event.midi1RawStatusByte()
            
        case let .systemReset(event):
            return event.midi1RawStatusByte()
            
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
            
        case .noOp:
            return nil
            
        case .jrClock:
            return nil
            
        case .jrTimestamp:
            return nil
        }
    }
    
    /// Returns the raw MIDI 1.0 data bytes for the event (excluding status byte) if the event is
    /// compatible with MIDI 1.0.
    public func midi1RawDataBytes() -> (data1: UInt8?, data2: UInt8?)? {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
            
        case let .noteOn(event):
            return event.midi1RawDataBytes()
            
        case let .noteOff(event):
            return event.midi1RawDataBytes()
            
        case .noteCC:
            return nil
            
        case .notePitchBend:
            return nil
            
        case let .notePressure(event):
            return event.midi1RawDataBytes()
            
        case .noteManagement:
            return nil
            
        case let .cc(event):
            return event.midi1RawDataBytes()
            
        case let .programChange(event):
            return (data1: event.midi1RawDataBytes(), data2: nil)
            
        case let .pressure(event):
            return (data1: event.midi1RawDataBytes(), data2: nil)
            
        case let .pitchBend(event):
            return event.midi1RawDataBytes()
            
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case .rpn:
            return nil // technically multiple events
            
        case .nrpn:
            return nil // technically multiple events
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
            
        case .sysEx7: // 'data' bytes are ambiguous/variable length; ignore
            return nil
            
        case .universalSysEx7: // 'data' bytes are ambiguous/variable length; ignore
            return nil
            
        case .sysEx8:
            return nil
            
        case .universalSysEx8:
            return nil
            
        // -------------------
        // MARK: System Common
        // -------------------
            
        case let .timecodeQuarterFrame(event):
            return (data1: event.midi1RawDataBytes(), data2: nil)
            
        case let .songPositionPointer(event):
            return event.midi1RawDataBytes()
            
        case let .songSelect(event):
            return (data1: event.midi1RawDataBytes(), data2: nil)
            
        case let .unofficialBusSelect(event):
            return (data1: event.midi1RawDataBytes(), data2: nil)
            
        case .tuneRequest:
            return (data1: nil, data2: nil) // no data bytes
            
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
            
        case .timingClock:
            return (data1: nil, data2: nil) // no data bytes
            
        case .start:
            return (data1: nil, data2: nil) // no data bytes
            
        case .continue:
            return (data1: nil, data2: nil) // no data bytes
            
        case .stop:
            return (data1: nil, data2: nil) // no data bytes
            
        case .activeSensing:
            return (data1: nil, data2: nil) // no data bytes
            
        case .systemReset:
            return (data1: nil, data2: nil) // no data bytes
            
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
            
        case .noOp:
            return nil
            
        case .jrClock:
            return nil
            
        case .jrTimestamp:
            return nil
        }
    }
}

extension MIDIEvent {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords(protocol midiProtocol: MIDIProtocolVersion) -> [[UMPWord]] {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
    
        case let .noteOn(event):
            return [event.umpRawWords(protocol: midiProtocol)]
    
        case let .noteOff(event):
            return [event.umpRawWords(protocol: midiProtocol)]
    
        case let .noteCC(event):
            return [event.umpRawWords()]
    
        case let .notePitchBend(event):
            return [event.umpRawWords()]
    
        case let .notePressure(event):
            return [event.umpRawWords(protocol: midiProtocol)]
    
        case let .noteManagement(event):
            return [event.umpRawWords()]
    
        case let .cc(event):
            return [event.umpRawWords(protocol: midiProtocol)]
    
        case let .programChange(event):
            return [event.umpRawWords(protocol: midiProtocol)]
    
        case let .pressure(event):
            return [event.umpRawWords(protocol: midiProtocol)]
    
        case let .pitchBend(event):
            return [event.umpRawWords(protocol: midiProtocol)]
    
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case let .rpn(event):
            return event.umpRawWords(protocol: midiProtocol)
        
        case let .nrpn(event):
            return event.umpRawWords(protocol: midiProtocol)
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
    
        case let .sysEx7(event):
            return event.umpRawWords()
    
        case let .universalSysEx7(event):
            return event.umpRawWords()
    
        case let .sysEx8(event):
            return event.umpRawWords()
    
        case let .universalSysEx8(event):
            return event.umpRawWords()
    
        // -------------------
        // MARK: System Common
        // -------------------
    
        case let .timecodeQuarterFrame(event):
            return [event.umpRawWords()]
    
        case let .songPositionPointer(event):
            return [event.umpRawWords()]
    
        case let .songSelect(event):
            return [event.umpRawWords()]
    
        case let .unofficialBusSelect(event):
            return [event.umpRawWords()]
    
        case let .tuneRequest(event):
            return [event.umpRawWords()]
    
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
    
        case let .timingClock(event):
            return [event.umpRawWords()]
    
        case let .start(event):
            return [event.umpRawWords()]
    
        case let .continue(event):
            return [event.umpRawWords()]
    
        case let .stop(event):
            return [event.umpRawWords()]
    
        case let .activeSensing(event):
            return [event.umpRawWords()]
    
        case let .systemReset(event):
            return [event.umpRawWords()]
    
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
    
        case let .noOp(event):
            return [event.umpRawWords()]
    
        case let .jrClock(event):
            return [event.umpRawWords()]
    
        case let .jrTimestamp(event):
            return [event.umpRawWords()]
        }
    }
}
