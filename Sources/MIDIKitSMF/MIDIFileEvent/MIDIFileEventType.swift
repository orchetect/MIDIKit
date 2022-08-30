//
//  MIDIFileEventType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
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
    case sysEx7
    case tempo
    case text
    case timeSignature
    case universalSysEx7
    case unrecognizedMeta
    case xmfPatchTypePrefix
}

extension MIDIFileEventType {
    /// Returns the concrete type associated with the MIDI file event.
    public var concreteType: MIDIFileEventPayload.Type {
        switch self {
        case .cc:                 return MIDIFileEvent.CC.self
        case .channelPrefix:      return MIDIFileEvent.ChannelPrefix.self
        case .keySignature:       return MIDIFileEvent.KeySignature.self
        case .noteOff:            return MIDIFileEvent.NoteOff.self
        case .noteOn:             return MIDIFileEvent.NoteOn.self
        case .notePressure:       return MIDIFileEvent.NotePressure.self
        case .pitchBend:          return MIDIFileEvent.PitchBend.self
        case .portPrefix:         return MIDIFileEvent.PortPrefix.self
        case .pressure:           return MIDIFileEvent.Pressure.self
        case .programChange:      return MIDIFileEvent.ProgramChange.self
        case .sequenceNumber:     return MIDIFileEvent.SequenceNumber.self
        case .sequencerSpecific:  return MIDIFileEvent.SequencerSpecific.self
        case .smpteOffset:        return MIDIFileEvent.SMPTEOffset.self
        case .sysEx7:             return MIDIFileEvent.SysEx7.self
        case .tempo:              return MIDIFileEvent.Tempo.self
        case .text:               return MIDIFileEvent.Text.self
        case .timeSignature:      return MIDIFileEvent.TimeSignature.self
        case .universalSysEx7:    return MIDIFileEvent.UniversalSysEx7.self
        case .unrecognizedMeta:   return MIDIFileEvent.UnrecognizedMeta.self
        case .xmfPatchTypePrefix: return MIDIFileEvent.XMFPatchTypePrefix.self
        }
    }
}

extension Collection where Element == MIDIFileEventType {
    /// Returns the collection mapped to concrete types.
    public var concreteTypes: [MIDIFileEventPayload.Type] {
        map(\.concreteType.self)
    }
}
