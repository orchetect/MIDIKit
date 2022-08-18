//
//  Event Conversion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension MIDIEvent {
    /// Convert the MIDIKit I/O event case (`MIDIEvent`) to a MIDIKitSMF event case (`MIDIFileEvent`).
    public func smfEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent? {
        switch self {
        case let .noteOn(event):
            return .noteOn(delta: delta, event: event)
            
        case let .noteOff(event):
            return .noteOff(delta: delta, event: event)
            
        case .noteCC:
            // MIDI 2.0 only
            return nil
            
        case .notePitchBend:
            // MIDI 2.0 only
            return nil
            
        case let .notePressure(event):
            return .notePressure(delta: delta, event: event)
            
        case .noteManagement:
            // MIDI 2.0 only
            return nil
            
        case let .cc(event):
            return .cc(delta: delta, event: event)
            
        case let .programChange(event):
            return .programChange(delta: delta, event: event)
            
        case let .pitchBend(event):
            return .pitchBend(delta: delta, event: event)
            
        case let .pressure(event):
            return .pressure(delta: delta, event: event)
            
        case let .sysEx7(event):
            return .sysEx(delta: delta, event: event)
            
        case let .universalSysEx7(event):
            return .universalSysEx(delta: delta, event: event)
            
        case .sysEx8:
            // MIDI 2.0 only
            return nil
            
        case .universalSysEx8:
            // MIDI 2.0 only
            return nil
            
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
            // Not applicable to MIDI files.
            return nil
            
        case .noOp,
             .jrClock,
             .jrTimestamp:
            // MIDI 2.0 only
            // Not applicable to MIDI files.
            return nil
        }
    }
}

extension MIDIFileEvent {
    /// Convert the MIDIKitSMF event case (`MIDIFileEvent`) to a MIDIKit I/O event case (`MIDIEvent`).
    public func event() -> MIDIEvent? {
        switch self {
        case let .cc(_, event):
            return .cc(event)
            
        case let .noteOff(_, event):
            return .noteOff(event)
            
        case let .noteOn(_, event):
            return .noteOn(event)
            
        case let .notePressure(_, event):
            return .notePressure(event)
            
        case let .pitchBend(_, event):
            return .pitchBend(event)
            
        case let .pressure(_, event):
            return .pressure(event)
            
        case let .programChange(_, event):
            return .programChange(event)
            
        case let .sysEx(_, event):
            return .sysEx7(event)
            
        case let .universalSysEx(_, event):
            return .universalSysEx7(event)
            
        case .channelPrefix,
             .keySignature,
             .portPrefix,
             .sequenceNumber,
             .sequencerSpecific,
             .smpteOffset,
             .tempo,
             .text,
             .timeSignature,
             .unrecognizedMeta,
             .xmfPatchTypePrefix:
            // Not applicable to MIDI I/O, only applicable to MIDI files.
            return nil
        }
    }
}
