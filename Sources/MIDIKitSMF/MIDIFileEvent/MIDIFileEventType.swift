//
//  MIDIFileEventType.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// Cases describing MIDI file event types.
public enum MIDIFileEventType: String, CaseIterable, Equatable, Hashable {
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
    case sequenceNumber
    case sequencerSpecific
    case smpteOffset
    case sysEx
    case tempo
    case text
    case timeSignature
    case universalSysEx
    case unrecognizedMeta
    case xmfPatchTypePrefix
}

extension MIDIFileEventType {
    public var concreteType: MIDIFileEventPayload.Type {
        switch self {
        case .cc: return MIDIFileEvent.CC.self
        case .channelPrefix: return MIDIFileEvent.ChannelPrefix.self
        case .keySignature: return MIDIFileEvent.KeySignature.self
        case .noteOff: return MIDIFileEvent.NoteOff.self
        case .noteOn: return MIDIFileEvent.NoteOn.self
        case .notePressure: return MIDIFileEvent.NotePressure.self
        case .pitchBend: return MIDIFileEvent.PitchBend.self
        case .portPrefix: return MIDIFileEvent.PortPrefix.self
        case .pressure: return MIDIFileEvent.Pressure.self
        case .programChange: return MIDIFileEvent.ProgramChange.self
        case .sequenceNumber: return MIDIFileEvent.SequenceNumber.self
        case .sequencerSpecific: return MIDIFileEvent.SequencerSpecific.self
        case .smpteOffset: return MIDIFileEvent.SMPTEOffset.self
        case .sysEx: return MIDIFileEvent.SysEx.self
        case .tempo: return MIDIFileEvent.Tempo.self
        case .text: return MIDIFileEvent.Text.self
        case .timeSignature: return MIDIFileEvent.TimeSignature.self
        case .universalSysEx: return MIDIFileEvent.UniversalSysEx.self
        case .unrecognizedMeta: return MIDIFileEvent.UnrecognizedMeta.self
        case .xmfPatchTypePrefix: return MIDIFileEvent.XMFPatchTypePrefix.self
        }
    }
}

extension Collection where Element == MIDIFileEventType {
    public var concreteTypes: [MIDIFileEventPayload.Type] {
        map(\.concreteType.self)
    }
}
