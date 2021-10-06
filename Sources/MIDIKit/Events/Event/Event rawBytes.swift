//
//  Event rawBytes.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    @inline(__always)
    public var midi1RawBytes: [MIDI.Byte] {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(let event):
            return event.midi1RawBytes()
            
        case .noteOff(let event):
            return event.midi1RawBytes()
        
        case .noteCC:
            return []
            
        case .notePitchBend:
            return []
            
        case .notePressure(let event):
            return event.midi1RawBytes()
            
        case .noteManagement:
            return []
            
        case .cc(let event):
            return event.midi1RawBytes()
            
        case .programChange(let event):
            return event.midi1RawBytes()
            
        case .pressure(let event):
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
        
        case .timecodeQuarterFrame(let event):
            return event.midi1RawBytes()
            
        case .songPositionPointer(let event):
            return event.midi1RawBytes()
            
        case .songSelect(let event):
            return event.midi1RawBytes()
            
        case .unofficialBusSelect(let event):
            return event.midi1RawBytes()
            
        case .tuneRequest(let event):
            return event.midi1RawBytes()
            
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock(let event):
            return event.midi1RawBytes()
            
        case .start(let event):
            return event.midi1RawBytes()
            
        case .continue(let event):
            return event.midi1RawBytes()
            
        case .stop(let event):
            return event.midi1RawBytes()
            
        case .activeSensing(let event):
            return event.midi1RawBytes()
            
        case .systemReset(let event):
            return event.midi1RawBytes()
            
        }
        
    }
    
}

extension MIDI.Event {
    
    @inline(__always)
    public func umpRawWords(protocol midiProtocol: MIDI.IO.ProtocolVersion) -> [MIDI.UMPWord] {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(let event):
            return event.umpRawWords(protocol: midiProtocol)
            
        case .noteOff(let event):
            return event.umpRawWords(protocol: midiProtocol)
            
        case .noteCC(let event):
            return event.umpRawWords()
            
        case .notePitchBend(let event):
            return event.umpRawWords()
        
        case .notePressure(let event):
            return event.umpRawWords(protocol: midiProtocol)
        
        case .noteManagement(let event):
            return event.umpRawWords()
            
        case .cc(let event):
            return event.umpRawWords(protocol: midiProtocol)
            
        case .programChange(let event):
            return event.umpRawWords(protocol: midiProtocol)
            
        case .pressure(let event):
            return event.umpRawWords(protocol: midiProtocol)
            
        case .pitchBend(let event):
            return event.umpRawWords(protocol: midiProtocol)
            
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(let event):
            return event.umpRawWords()
            
        case .universalSysEx(let event):
            return event.umpRawWords()
            
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(let event):
            return event.umpRawWords()
            
        case .songPositionPointer(let event):
            return event.umpRawWords()
            
        case .songSelect(let event):
            return event.umpRawWords()
            
        case .unofficialBusSelect(let event):
            return event.umpRawWords()
            
        case .tuneRequest(let event):
            return event.umpRawWords()
            
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock(let event):
            return event.umpRawWords()
            
        case .start(let event):
            return event.umpRawWords()
            
        case .continue(let event):
            return event.umpRawWords()
            
        case .stop(let event):
            return event.umpRawWords()
            
        case .activeSensing(let event):
            return event.umpRawWords()
            
        case .systemReset(let event):
            return event.umpRawWords()
            
        }
        
    }
    
}
