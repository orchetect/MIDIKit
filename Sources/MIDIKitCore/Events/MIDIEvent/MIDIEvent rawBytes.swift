//
//  MIDIEvent rawBytes.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - MIDI 1.0

extension MIDIEvent {
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    ///   of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
    
        case let .noteOn(event):
            event.midi1RawBytes()
    
        case let .noteOff(event):
            event.midi1RawBytes()
    
        case .noteCC:
            []
    
        case .notePitchBend:
            []
    
        case let .notePressure(event):
            event.midi1RawBytes()
    
        case .noteManagement:
            []
    
        case let .cc(event):
            event.midi1RawBytes()
    
        case let .programChange(event):
            event.midi1RawBytes()
    
        case let .pressure(event):
            event.midi1RawBytes()
    
        case let .pitchBend(event):
            event.midi1RawBytes()
    
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case let .rpn(event):
            event.midi1RawBytes()
            
        case let .nrpn(event):
            event.midi1RawBytes()
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
    
        case let .sysEx7(event):
            event.midi1RawBytes()
    
        case let .universalSysEx7(event):
            event.midi1RawBytes()
    
        case .sysEx8:
            []
    
        case .universalSysEx8:
            []
    
        // -------------------
        // MARK: System Common
        // -------------------
    
        case let .timecodeQuarterFrame(event):
            event.midi1RawBytes()
    
        case let .songPositionPointer(event):
            event.midi1RawBytes()
    
        case let .songSelect(event):
            event.midi1RawBytes()
    
        case let .tuneRequest(event):
            event.midi1RawBytes()
    
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
    
        case let .timingClock(event):
            event.midi1RawBytes()
    
        case let .start(event):
            event.midi1RawBytes()
    
        case let .continue(event):
            event.midi1RawBytes()
    
        case let .stop(event):
            event.midi1RawBytes()
    
        case let .activeSensing(event):
            event.midi1RawBytes()
    
        case let .systemReset(event):
            event.midi1RawBytes()
    
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
    
        case .noOp:
            []
    
        case .jrClock:
            []
    
        case .jrTimestamp:
            []
        }
    }
    
    /// Returns the raw MIDI 1.0 status byte for the event if the event is compatible with MIDI 1.0.
    public func midi1RawStatusByte() -> UInt8? {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
            
        case let .noteOn(event):
            event.midi1RawStatusByte()
            
        case let .noteOff(event):
            event.midi1RawStatusByte()
            
        case .noteCC:
            nil
            
        case .notePitchBend:
            nil
            
        case let .notePressure(event):
            event.midi1RawStatusByte()
            
        case .noteManagement:
            nil
            
        case let .cc(event):
            event.midi1RawStatusByte()
            
        case let .programChange(event):
            event.midi1RawStatusByte()
            
        case let .pressure(event):
            event.midi1RawStatusByte()
            
        case let .pitchBend(event):
            event.midi1RawStatusByte()
            
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case .rpn:
            nil // technically multiple events
            
        case .nrpn:
            nil // technically multiple events
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
            
        case let .sysEx7(event):
            event.midi1RawStatusByte()
            
        case let .universalSysEx7(event):
            event.midi1RawStatusByte()
            
        case .sysEx8:
            nil
            
        case .universalSysEx8:
            nil
            
        // -------------------
        // MARK: System Common
        // -------------------
            
        case let .timecodeQuarterFrame(event):
            event.midi1RawStatusByte()
            
        case let .songPositionPointer(event):
            event.midi1RawStatusByte()
            
        case let .songSelect(event):
            event.midi1RawStatusByte()
            
        case let .tuneRequest(event):
            event.midi1RawStatusByte()
            
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
            
        case let .timingClock(event):
            event.midi1RawStatusByte()
            
        case let .start(event):
            event.midi1RawStatusByte()
            
        case let .continue(event):
            event.midi1RawStatusByte()
            
        case let .stop(event):
            event.midi1RawStatusByte()
            
        case let .activeSensing(event):
            event.midi1RawStatusByte()
            
        case let .systemReset(event):
            event.midi1RawStatusByte()
            
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
            
        case .noOp:
            nil
            
        case .jrClock:
            nil
            
        case .jrTimestamp:
            nil
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
            event.midi1RawDataBytes()
            
        case let .noteOff(event):
            event.midi1RawDataBytes()
            
        case .noteCC:
            nil
            
        case .notePitchBend:
            nil
            
        case let .notePressure(event):
            event.midi1RawDataBytes()
            
        case .noteManagement:
            nil
            
        case let .cc(event):
            event.midi1RawDataBytes()
            
        case let .programChange(event):
            (data1: event.midi1RawDataBytes(), data2: nil)
            
        case let .pressure(event):
            (data1: event.midi1RawDataBytes(), data2: nil)
            
        case let .pitchBend(event):
            event.midi1RawDataBytes()
            
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case .rpn:
            nil // technically multiple events
            
        case .nrpn:
            nil // technically multiple events
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
            
        case .sysEx7: // 'data' bytes are ambiguous/variable length; ignore
            nil
            
        case .universalSysEx7: // 'data' bytes are ambiguous/variable length; ignore
            nil
            
        case .sysEx8:
            nil
            
        case .universalSysEx8:
            nil
            
        // -------------------
        // MARK: System Common
        // -------------------
            
        case let .timecodeQuarterFrame(event):
            (data1: event.midi1RawDataBytes(), data2: nil)
            
        case let .songPositionPointer(event):
            event.midi1RawDataBytes()
            
        case let .songSelect(event):
            (data1: event.midi1RawDataBytes(), data2: nil)
            
        case .tuneRequest:
            (data1: nil, data2: nil) // no data bytes
            
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
            
        case .timingClock:
            (data1: nil, data2: nil) // no data bytes
            
        case .start:
            (data1: nil, data2: nil) // no data bytes
            
        case .continue:
            (data1: nil, data2: nil) // no data bytes
            
        case .stop:
            (data1: nil, data2: nil) // no data bytes
            
        case .activeSensing:
            (data1: nil, data2: nil) // no data bytes
            
        case .systemReset:
            (data1: nil, data2: nil) // no data bytes
            
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
            
        case .noOp:
            nil
            
        case .jrClock:
            nil
            
        case .jrTimestamp:
            nil
        }
    }
}

// MARK: - UMP

extension MIDIEvent {
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    ///   of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords(protocol midiProtocol: MIDIProtocolVersion) -> [[UMPWord]] {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
    
        case let .noteOn(event):
            [event.umpRawWords(protocol: midiProtocol)]
    
        case let .noteOff(event):
            [event.umpRawWords(protocol: midiProtocol)]
    
        case let .noteCC(event):
            [event.umpRawWords()]
    
        case let .notePitchBend(event):
            [event.umpRawWords()]
    
        case let .notePressure(event):
            [event.umpRawWords(protocol: midiProtocol)]
    
        case let .noteManagement(event):
            [event.umpRawWords()]
    
        case let .cc(event):
            [event.umpRawWords(protocol: midiProtocol)]
    
        case let .programChange(event):
            [event.umpRawWords(protocol: midiProtocol)]
    
        case let .pressure(event):
            [event.umpRawWords(protocol: midiProtocol)]
    
        case let .pitchBend(event):
            [event.umpRawWords(protocol: midiProtocol)]
    
        // -----------------------------------------------
        // MARK: Channel Voice - Parameter Number Messages
        // -----------------------------------------------
            
        case let .rpn(event):
            event.umpRawWords(protocol: midiProtocol)
        
        case let .nrpn(event):
            event.umpRawWords(protocol: midiProtocol)
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
    
        case let .sysEx7(event):
            event.umpRawWords()
    
        case let .universalSysEx7(event):
            event.umpRawWords()
    
        case let .sysEx8(event):
            event.umpRawWords()
    
        case let .universalSysEx8(event):
            event.umpRawWords()
    
        // -------------------
        // MARK: System Common
        // -------------------
    
        case let .timecodeQuarterFrame(event):
            [event.umpRawWords()]
    
        case let .songPositionPointer(event):
            [event.umpRawWords()]
    
        case let .songSelect(event):
            [event.umpRawWords()]
    
        case let .tuneRequest(event):
            [event.umpRawWords()]
    
        // ----------------------
        // MARK: System Real-Time
        // ----------------------
    
        case let .timingClock(event):
            [event.umpRawWords()]
    
        case let .start(event):
            [event.umpRawWords()]
    
        case let .continue(event):
            [event.umpRawWords()]
    
        case let .stop(event):
            [event.umpRawWords()]
    
        case let .activeSensing(event):
            [event.umpRawWords()]
    
        case let .systemReset(event):
            [event.umpRawWords()]
    
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
    
        case let .noOp(event):
            [event.umpRawWords()]
    
        case let .jrClock(event):
            [event.umpRawWords()]
    
        case let .jrTimestamp(event):
            [event.umpRawWords()]
        }
    }
}
