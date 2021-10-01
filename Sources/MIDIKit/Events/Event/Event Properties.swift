//
//  Event Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Returns the event's channel, if one is associated with it.
    public var channel: MIDI.UInt4? {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(let event):
            return event.channel
            
        case .noteOff(let event):
            return event.channel
            
        case .noteCC(let event):
            return event.channel
            
        case .notePitchBend(let event):
            return event.channel
            
        case .notePressure(let event):
            return event.channel
            
        case .noteManagement(let event):
            return event.channel
            
        case .cc(let event):
            return event.channel
            
        case .programChange(let event):
            return event.channel
            
        case .pressure(let event):
            return event.channel
            
        case .pitchBend(let event):
            return event.channel
            
        default:
            return nil
            
        }
        
    }
    
    /// Returns the event's UMP group.
    public var group: MIDI.UInt4 {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(let event):
            return event.group
            
        case .noteOff(let event):
            return event.group
            
        case .noteCC(let event):
            return event.group
            
        case .notePitchBend(let event):
            return event.group
            
        case .notePressure(let event):
            return event.group
            
        case .noteManagement(let event):
            return event.group
            
        case .cc(let event):
            return event.group
            
        case .programChange(let event):
            return event.group
            
        case .pressure(let event):
            return event.group
            
        case .pitchBend(let event):
            return event.group
            
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(let event):
            return event.group
            
        case .universalSysEx(let event):
            return event.group
            
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(let event):
            return event.group
            
        case .songPositionPointer(let event):
            return event.group
            
        case .songSelect(let event):
            return event.group
            
        case .unofficialBusSelect(let event):
            return event.group
            
        case .tuneRequest(let event):
            return event.group
            
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        case .timingClock(let event):
            return event.group
            
        case .start(let event):
            return event.group
            
        case .continue(let event):
            return event.group
            
        case .stop(let event):
            return event.group
            
        case .activeSensing(let event):
            return event.group
            
        case .systemReset(let event):
            return event.group
            
        }
        
    }
    
}
