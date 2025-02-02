//
//  MIDIFileEventType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// Cases describing MIDI file event types.
public enum MIDIFileEventType: String {
    case cc
    case channelPrefix
    case keySignature
    case noteOff
    case noteOn
    case notePressure // polyphonic (per-note) pressure
    case pitchBend
    case portPrefix
    case pressure // channel pressure
    case programChange
    case rpn
    case nrpn
    case sequenceNumber
    case sequencerSpecific
    case smpteOffset
    case sysEx7
    case tempo
    case text
    case timeSignature
    case universalSysEx7
    case unrecognizedMeta
    case xmfPatchTypePrefix
}

extension MIDIFileEventType: Equatable { }

extension MIDIFileEventType: Hashable { }

extension MIDIFileEventType: CaseIterable { }

extension MIDIFileEventType: Sendable { }

extension MIDIFileEventType {
    /// Returns the concrete type associated with the MIDI file event.
    @inline(__always)
    public var concreteType: MIDIFileEventPayload.Type {
        switch self {
        case .cc:                 MIDIFileEvent.CC.self
        case .channelPrefix:      MIDIFileEvent.ChannelPrefix.self
        case .keySignature:       MIDIFileEvent.KeySignature.self
        case .noteOff:            MIDIFileEvent.NoteOff.self
        case .noteOn:             MIDIFileEvent.NoteOn.self
        case .notePressure:       MIDIFileEvent.NotePressure.self
        case .pitchBend:          MIDIFileEvent.PitchBend.self
        case .portPrefix:         MIDIFileEvent.PortPrefix.self
        case .pressure:           MIDIFileEvent.Pressure.self
        case .programChange:      MIDIFileEvent.ProgramChange.self
        case .rpn:                MIDIFileEvent.RPN.self
        case .nrpn:               MIDIFileEvent.NRPN.self
        case .sequenceNumber:     MIDIFileEvent.SequenceNumber.self
        case .sequencerSpecific:  MIDIFileEvent.SequencerSpecific.self
        case .smpteOffset:        MIDIFileEvent.SMPTEOffset.self
        case .sysEx7:             MIDIFileEvent.SysEx7.self
        case .tempo:              MIDIFileEvent.Tempo.self
        case .text:               MIDIFileEvent.Text.self
        case .timeSignature:      MIDIFileEvent.TimeSignature.self
        case .universalSysEx7:    MIDIFileEvent.UniversalSysEx7.self
        case .unrecognizedMeta:   MIDIFileEvent.UnrecognizedMeta.self
        case .xmfPatchTypePrefix: MIDIFileEvent.XMFPatchTypePrefix.self
        }
    }
}

extension Collection<MIDIFileEventType> {
    /// Returns the collection mapped to concrete types.
    public var concreteTypes: [MIDIFileEventPayload.Type] {
        map(\.concreteType.self)
    }
}
