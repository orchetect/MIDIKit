//
//  Event Conversion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension MIDIEvent {
    /// Convert the MIDIKit I/O event case (``MIDIEvent``) to a MIDIKitSMF event case
    /// (``MIDIFileEvent``).
    ///
    /// Not all MIDI I/O events translate to MIDI File events, in which case `nil` will be returned.
    public func smfEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent? {
        switch self {
        case let .noteOn(event):
            return .noteOn(delta: delta, event: event)
            
        case let .noteOff(event):
            return .noteOff(delta: delta, event: event)
            
        case .noteCC:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            return nil
            
        case .notePitchBend:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            return nil
            
        case let .notePressure(event):
            return .notePressure(delta: delta, event: event)
            
        case .noteManagement:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            return nil
            
        case let .cc(event):
            return .cc(delta: delta, event: event)
            
        case let .programChange(event):
            return .programChange(delta: delta, event: event)
            
        case let .pitchBend(event):
            return .pitchBend(delta: delta, event: event)
            
        case let .pressure(event):
            return .pressure(delta: delta, event: event)
            
        case let .rpn(event):
            return .rpn(delta: delta, event: event)
            
        case let .nrpn(event):
            return .nrpn(delta: delta, event: event)
            
        case let .sysEx7(event):
            return .sysEx7(delta: delta, event: event)
            
        case let .universalSysEx7(event):
            return .universalSysEx7(delta: delta, event: event)
            
        case .sysEx8:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            return nil
            
        case .universalSysEx8:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
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
            // MIDI 2.0 only, also not applicable to MIDI files.
            return nil
        }
    }
}

extension MIDIFileEvent {
    /// Convert the MIDIKitSMF event case (``MIDIFileEvent``) to a MIDIKit I/O event case
    /// (``MIDIEvent``).
    ///
    /// Not all MIDI File events translate to MIDI I/O events, in which case `nil` will be returned.
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
            
        case let .sysEx7(_, event):
            return .sysEx7(event)
            
        case let .universalSysEx7(_, event):
            return .universalSysEx7(event)
            
        case let .rpn(_, event):
            return .rpn(event)
            
        case let .nrpn(_, event):
            return .nrpn(event)
            
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
