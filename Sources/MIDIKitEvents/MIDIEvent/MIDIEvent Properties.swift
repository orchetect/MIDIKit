//
//  MIDIEvent Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Returns the event's channel, if one is associated with it.
    @inline(__always)
    public var channel: UInt4? {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
    
        case let .noteOn(event):
            return event.channel
    
        case let .noteOff(event):
            return event.channel
    
        case let .noteCC(event):
            return event.channel
    
        case let .notePitchBend(event):
            return event.channel
    
        case let .notePressure(event):
            return event.channel
    
        case let .noteManagement(event):
            return event.channel
    
        case let .cc(event):
            return event.channel
    
        case let .programChange(event):
            return event.channel
    
        case let .pressure(event):
            return event.channel
    
        case let .pitchBend(event):
            return event.channel
    
        default:
            return nil
        }
    }
    
    /// Returns the event's UMP group.
    @inline(__always)
    public var group: UInt4 {
        switch self {
        // -------------------
        // MARK: Channel Voice
        // -------------------
    
        case let .noteOn(event):
            return event.group
    
        case let .noteOff(event):
            return event.group
    
        case let .noteCC(event):
            return event.group
    
        case let .notePitchBend(event):
            return event.group
    
        case let .notePressure(event):
            return event.group
    
        case let .noteManagement(event):
            return event.group
    
        case let .cc(event):
            return event.group
    
        case let .programChange(event):
            return event.group
    
        case let .pressure(event):
            return event.group
    
        case let .pitchBend(event):
            return event.group
    
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
    
        case let .sysEx7(event):
            return event.group
    
        case let .universalSysEx7(event):
            return event.group
    
        case let .sysEx8(event):
            return event.group
    
        case let .universalSysEx8(event):
            return event.group
    
        // -------------------
        // MARK: System Common
        // -------------------
    
        case let .timecodeQuarterFrame(event):
            return event.group
    
        case let .songPositionPointer(event):
            return event.group
    
        case let .songSelect(event):
            return event.group
    
        case let .unofficialBusSelect(event):
            return event.group
    
        case let .tuneRequest(event):
            return event.group
    
        // ----------------------
        // MARK: System Real Time
        // ----------------------
    
        case let .timingClock(event):
            return event.group
    
        case let .start(event):
            return event.group
    
        case let .continue(event):
            return event.group
    
        case let .stop(event):
            return event.group
    
        case let .activeSensing(event):
            return event.group
    
        case let .systemReset(event):
            return event.group
    
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
    
        case let .noOp(event):
            return event.group
    
        case let .jrClock(event):
            return event.group
    
        case let .jrTimestamp(event):
            return event.group
        }
    }
}
