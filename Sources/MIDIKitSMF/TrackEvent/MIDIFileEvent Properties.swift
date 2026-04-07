//
//  MIDIFileEvent Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFileEvent {
    /// Returns the ``MIDIFileEventType`` case describing the type of the MIDI File event.
    @inline(__always)
    public var eventType: MIDIFileEventType {
        switch self {
        case .cc:                 .cc
        case .channelPrefix:      .channelPrefix
        case .keySignature:       .keySignature
        case .noteOff:            .noteOff
        case .noteOn:             .noteOn
        case .notePressure:       .notePressure
        case .pitchBend:          .pitchBend
        case .portPrefix:         .portPrefix
        case .pressure:           .pressure
        case .programChange:      .programChange
        case .rpn:                .rpn
        case .nrpn:               .nrpn
        case .sequenceNumber:     .sequenceNumber
        case .sequencerSpecific:  .sequencerSpecific
        case .smpteOffset:        .smpteOffset
        case .sysEx7:             .sysEx7
        case .tempo:              .tempo
        case .text:               .text
        case .timeSignature:      .timeSignature
        case .universalSysEx7:    .universalSysEx7
        case .unrecognizedMeta:   .unrecognizedMeta
        case .xmfPatchTypePrefix: .xmfPatchTypePrefix
        }
    }
    
    /// Returns the unwrapped enum payload as `any` ``MIDIFileEventPayload``.
    public var wrapped: any MIDIFileEventPayload {
        switch self {
        case let .cc(payload):                 payload
        case let .channelPrefix(payload):      payload
        case let .keySignature(payload):       payload
        case let .noteOff(payload):            payload
        case let .noteOn(payload):             payload
        case let .notePressure(payload):       payload
        case let .pitchBend(payload):          payload
        case let .portPrefix(payload):         payload
        case let .pressure(payload):           payload
        case let .programChange(payload):      payload
        case let .rpn(payload):                payload
        case let .nrpn(payload):               payload
        case let .sequenceNumber(payload):     payload
        case let .sequencerSpecific(payload):  payload
        case let .smpteOffset(payload):        payload
        case let .sysEx7(payload):             payload
        case let .tempo(payload):              payload
        case let .text(payload):               payload
        case let .timeSignature(payload):      payload
        case let .universalSysEx7(payload):    payload
        case let .unrecognizedMeta(payload):   payload
        case let .xmfPatchTypePrefix(payload): payload
        }
    }
}
