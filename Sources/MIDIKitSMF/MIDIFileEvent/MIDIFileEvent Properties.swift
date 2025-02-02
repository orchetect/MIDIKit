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
}

extension MIDIFileEvent {
    /// Returns the concrete type that contains the event payload, typed as ``MIDIFileEventPayload``
    /// protocol.
    @inline(__always)
    public var concreteType: MIDIFileEventPayload.Type {
        switch self {
        case .cc:                 CC.self
        case .channelPrefix:      ChannelPrefix.self
        case .keySignature:       KeySignature.self
        case .noteOff:            NoteOff.self
        case .noteOn:             NoteOn.self
        case .notePressure:       NotePressure.self
        case .pitchBend:          PitchBend.self
        case .portPrefix:         PortPrefix.self
        case .pressure:           Pressure.self
        case .programChange:      ProgramChange.self
        case .rpn:                RPN.self
        case .nrpn:               NRPN.self
        case .sequenceNumber:     SequenceNumber.self
        case .sequencerSpecific:  SequencerSpecific.self
        case .smpteOffset:        SMPTEOffset.self
        case .sysEx7:             SysEx7.self
        case .tempo:              Tempo.self
        case .text:               Text.self
        case .timeSignature:      TimeSignature.self
        case .universalSysEx7:    UniversalSysEx7.self
        case .unrecognizedMeta:   UnrecognizedMeta.self
        case .xmfPatchTypePrefix: XMFPatchTypePrefix.self
        }
    }
}

extension MIDIFileEvent {
    /// Unwraps the enum case and returns the ``MIDIFileEvent`` contained within, typed as
    /// ``MIDIFileEventPayload`` protocol. (Convenience)
    /// To unwrap the concrete event type, use switch case unwrapping instead.
    @inlinable
    public var smfUnwrappedEvent: (
        delta: DeltaTime,
        event: MIDIFileEventPayload
    ) {
        switch self {
        case let .cc(delta, event):
            (delta: delta, event: event)
        case let .channelPrefix(delta, event):
            (delta: delta, event: event)
        case let .keySignature(delta, event):
            (delta: delta, event: event)
        case let .noteOff(delta, event):
            (delta: delta, event: event)
        case let .noteOn(delta, event):
            (delta: delta, event: event)
        case let .notePressure(delta, event):
            (delta: delta, event: event)
        case let .pitchBend(delta, event):
            (delta: delta, event: event)
        case let .portPrefix(delta, event):
            (delta: delta, event: event)
        case let .pressure(delta, event):
            (delta: delta, event: event)
        case let .programChange(delta, event):
            (delta: delta, event: event)
        case let .rpn(delta, event):
            (delta: delta, event: event)
        case let .nrpn(delta, event):
            (delta: delta, event: event)
        case let .sequenceNumber(delta, event):
            (delta: delta, event: event)
        case let .sequencerSpecific(delta, event):
            (delta: delta, event: event)
        case let .smpteOffset(delta, event):
            (delta: delta, event: event)
        case let .sysEx7(delta, event):
            (delta: delta, event: event)
        case let .tempo(delta, event):
            (delta: delta, event: event)
        case let .text(delta, event):
            (delta: delta, event: event)
        case let .timeSignature(delta, event):
            (delta: delta, event: event)
        case let .universalSysEx7(delta, event):
            (delta: delta, event: event)
        case let .unrecognizedMeta(delta, event):
            (delta: delta, event: event)
        case let .xmfPatchTypePrefix(delta, event):
            (delta: delta, event: event)
        }
    }
    
    /// Returns the delta time from the unwrapped event. (Convenience)
    public var delta: DeltaTime {
        smfUnwrappedEvent.delta
    }
}

extension MIDIFileEventPayload {
    /// Wraps the concrete struct in its corresponding ``MIDIFileEvent`` enum case wrapper.
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        switch self {
        case let event as MIDIFileEvent.CC:
            .cc(delta: delta, event: event)
        case let event as MIDIFileEvent.ChannelPrefix:
            .channelPrefix(delta: delta, event: event)
        case let event as MIDIFileEvent.KeySignature:
            .keySignature(delta: delta, event: event)
        case let event as MIDIFileEvent.NoteOff:
            .noteOff(delta: delta, event: event)
        case let event as MIDIFileEvent.NoteOn:
            .noteOn(delta: delta, event: event)
        case let event as MIDIFileEvent.NotePressure:
            .notePressure(delta: delta, event: event)
        case let event as MIDIFileEvent.PitchBend:
            .pitchBend(delta: delta, event: event)
        case let event as MIDIFileEvent.PortPrefix:
            .portPrefix(delta: delta, event: event)
        case let event as MIDIFileEvent.Pressure:
            .pressure(delta: delta, event: event)
        case let event as MIDIFileEvent.ProgramChange:
            .programChange(delta: delta, event: event)
        case let event as MIDIFileEvent.SequenceNumber:
            .sequenceNumber(delta: delta, event: event)
        case let event as MIDIFileEvent.SequencerSpecific:
            .sequencerSpecific(delta: delta, event: event)
        case let event as MIDIFileEvent.SMPTEOffset:
            .smpteOffset(delta: delta, event: event)
        case let event as MIDIFileEvent.SysEx7:
            .sysEx7(delta: delta, event: event)
        case let event as MIDIFileEvent.Tempo:
            .tempo(delta: delta, event: event)
        case let event as MIDIFileEvent.Text:
            .text(delta: delta, event: event)
        case let event as MIDIFileEvent.TimeSignature:
            .timeSignature(delta: delta, event: event)
        case let event as MIDIFileEvent.UniversalSysEx7:
            .universalSysEx7(delta: delta, event: event)
        case let event as MIDIFileEvent.UnrecognizedMeta:
            .unrecognizedMeta(delta: delta, event: event)
        case let event as MIDIFileEvent.XMFPatchTypePrefix:
            .xmfPatchTypePrefix(delta: delta, event: event)
        default:
            // TODO: refactor to avoid resorting to fatalError
            fatalError()
        }
    }
}
