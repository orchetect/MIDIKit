//
//  Event Conversion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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
            .noteOn(delta: delta, event: event)
            
        case let .noteOff(event):
            .noteOff(delta: delta, event: event)
            
        case .noteCC:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            nil
            
        case .notePitchBend:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            nil
            
        case let .notePressure(event):
            .notePressure(delta: delta, event: event)
            
        case .noteManagement:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            nil
            
        case let .cc(event):
            .cc(delta: delta, event: event)
            
        case let .programChange(event):
            .programChange(delta: delta, event: event)
            
        case let .pitchBend(event):
            .pitchBend(delta: delta, event: event)
            
        case let .pressure(event):
            .pressure(delta: delta, event: event)
            
        case let .rpn(event):
            .rpn(delta: delta, event: event)
            
        case let .nrpn(event):
            .nrpn(delta: delta, event: event)
            
        case let .sysEx7(event):
            .sysEx7(delta: delta, event: event)
            
        case let .universalSysEx7(event):
            .universalSysEx7(delta: delta, event: event)
            
        case .sysEx8:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            nil
            
        case .universalSysEx8:
            // TODO: MIDI 2.0 only (Official MIDI File 2.0 Spec is not yet finished)
            nil
            
        case .timecodeQuarterFrame,
             .songPositionPointer,
             .songSelect,
             .tuneRequest,
             .timingClock,
             .start,
             .continue,
             .stop,
             .activeSensing,
             .systemReset:
            // Not applicable to MIDI files.
            nil
            
        case .noOp,
             .jrClock,
             .jrTimestamp:
            // MIDI 2.0 only, also not applicable to MIDI files.
            nil
        }
    }
}

extension MIDIFileEvent {
    /// Convert the MIDIKitSMF event case (``MIDIFileEvent``) to a MIDIKit I/O event case
    /// <doc://MIDIKitSMF/MIDIKitCore/MIDIEvent>.
    ///
    /// Not all MIDI File events translate to MIDI I/O events, in which case `nil` will be returned.
    public func event() -> MIDIEvent? {
        switch self {
        case let .cc(_, event):
            .cc(event)
            
        case let .noteOff(_, event):
            .noteOff(event)
            
        case let .noteOn(_, event):
            .noteOn(event)
            
        case let .notePressure(_, event):
            .notePressure(event)
            
        case let .pitchBend(_, event):
            .pitchBend(event)
            
        case let .pressure(_, event):
            .pressure(event)
            
        case let .programChange(_, event):
            .programChange(event)
            
        case let .sysEx7(_, event):
            .sysEx7(event)
            
        case let .universalSysEx7(_, event):
            .universalSysEx7(event)
            
        case let .rpn(_, event):
            .rpn(event)
            
        case let .nrpn(_, event):
            .nrpn(event)
            
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
            nil
        }
    }
}
