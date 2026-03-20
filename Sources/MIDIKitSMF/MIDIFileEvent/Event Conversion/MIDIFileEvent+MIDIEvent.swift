//
//  MIDIFileEvent+MIDIEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

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
