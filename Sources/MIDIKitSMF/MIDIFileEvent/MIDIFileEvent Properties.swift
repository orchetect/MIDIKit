//
//  MIDIFileEvent Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFileEvent {
    /// Returns the ``MIDIFileEventType`` case describing the type of the MIDI File event.
    public var eventType: MIDIFileEventType {
        switch self {
        case .cc:                 return .cc
        case .channelPrefix:      return .channelPrefix
        case .keySignature:       return .keySignature
        case .noteOff:            return .noteOff
        case .noteOn:             return .noteOn
        case .notePressure:       return .notePressure
        case .pitchBend:          return .pitchBend
        case .portPrefix:         return .portPrefix
        case .pressure:           return .pressure
        case .programChange:      return .programChange
        case .sequenceNumber:     return .sequenceNumber
        case .sequencerSpecific:  return .sequencerSpecific
        case .smpteOffset:        return .smpteOffset
        case .sysEx7:             return .sysEx7
        case .tempo:              return .tempo
        case .text:               return .text
        case .timeSignature:      return .timeSignature
        case .universalSysEx7:    return .universalSysEx7
        case .unrecognizedMeta:   return .unrecognizedMeta
        case .xmfPatchTypePrefix: return .xmfPatchTypePrefix
        }
    }
}

extension MIDIFileEvent {
    /// Returns the concrete type that contains the event payload, typed as ``MIDIFileEventPayload``
    /// protocol.
    public var concreteType: MIDIFileEventPayload.Type {
        switch self {
        case .cc:                 return CC.self
        case .channelPrefix:      return ChannelPrefix.self
        case .keySignature:       return KeySignature.self
        case .noteOff:            return NoteOff.self
        case .noteOn:             return NoteOn.self
        case .notePressure:       return NotePressure.self
        case .pitchBend:          return PitchBend.self
        case .portPrefix:         return PortPrefix.self
        case .pressure:           return Pressure.self
        case .programChange:      return ProgramChange.self
        case .sequenceNumber:     return SequenceNumber.self
        case .sequencerSpecific:  return SequencerSpecific.self
        case .smpteOffset:        return SMPTEOffset.self
        case .sysEx7:             return SysEx7.self
        case .tempo:              return Tempo.self
        case .text:               return Text.self
        case .timeSignature:      return TimeSignature.self
        case .universalSysEx7:    return UniversalSysEx7.self
        case .unrecognizedMeta:   return UnrecognizedMeta.self
        case .xmfPatchTypePrefix: return XMFPatchTypePrefix.self
        }
    }
}

extension MIDIFileEvent {
    /// Unwraps the enum case and returns the ``MIDIFileEvent`` contained within, typed as
    /// ``MIDIFileEventPayload`` protocol.
    public var smfUnwrappedEvent: (
        delta: DeltaTime,
        event: MIDIFileEventPayload
    ) {
        switch self {
        case let .cc(delta, event):
            return (delta: delta, event: event)
        case let .channelPrefix(delta, event):
            return (delta: delta, event: event)
        case let .keySignature(delta, event):
            return (delta: delta, event: event)
        case let .noteOff(delta, event):
            return (delta: delta, event: event)
        case let .noteOn(delta, event):
            return (delta: delta, event: event)
        case let .notePressure(delta, event):
            return (delta: delta, event: event)
        case let .pitchBend(delta, event):
            return (delta: delta, event: event)
        case let .portPrefix(delta, event):
            return (delta: delta, event: event)
        case let .pressure(delta, event):
            return (delta: delta, event: event)
        case let .programChange(delta, event):
            return (delta: delta, event: event)
        case let .sequenceNumber(delta, event):
            return (delta: delta, event: event)
        case let .sequencerSpecific(delta, event):
            return (delta: delta, event: event)
        case let .smpteOffset(delta, event):
            return (delta: delta, event: event)
        case let .sysEx7(delta, event):
            return (delta: delta, event: event)
        case let .tempo(delta, event):
            return (delta: delta, event: event)
        case let .text(delta, event):
            return (delta: delta, event: event)
        case let .timeSignature(delta, event):
            return (delta: delta, event: event)
        case let .universalSysEx7(delta, event):
            return (delta: delta, event: event)
        case let .unrecognizedMeta(delta, event):
            return (delta: delta, event: event)
        case let .xmfPatchTypePrefix(delta, event):
            return (delta: delta, event: event)
        }
    }
}

extension MIDIFileEventPayload {
    /// Wraps the concrete struct in its corresponding ``MIDIFileEvent`` enum case wrapper.
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        switch self {
        case let event as MIDIFileEvent.CC:
            return .cc(delta: delta, event: event)
        case let event as MIDIFileEvent.ChannelPrefix:
            return .channelPrefix(delta: delta, event: event)
        case let event as MIDIFileEvent.KeySignature:
            return .keySignature(delta: delta, event: event)
        case let event as MIDIFileEvent.NoteOff:
            return .noteOff(delta: delta, event: event)
        case let event as MIDIFileEvent.NoteOn:
            return .noteOn(delta: delta, event: event)
        case let event as MIDIFileEvent.NotePressure:
            return .notePressure(delta: delta, event: event)
        case let event as MIDIFileEvent.PitchBend:
            return .pitchBend(delta: delta, event: event)
        case let event as MIDIFileEvent.PortPrefix:
            return .portPrefix(delta: delta, event: event)
        case let event as MIDIFileEvent.Pressure:
            return .pressure(delta: delta, event: event)
        case let event as MIDIFileEvent.ProgramChange:
            return .programChange(delta: delta, event: event)
        case let event as MIDIFileEvent.SequenceNumber:
            return .sequenceNumber(delta: delta, event: event)
        case let event as MIDIFileEvent.SequencerSpecific:
            return .sequencerSpecific(delta: delta, event: event)
        case let event as MIDIFileEvent.SMPTEOffset:
            return .smpteOffset(delta: delta, event: event)
        case let event as MIDIFileEvent.SysEx7:
            return .sysEx7(delta: delta, event: event)
        case let event as MIDIFileEvent.Tempo:
            return .tempo(delta: delta, event: event)
        case let event as MIDIFileEvent.Text:
            return .text(delta: delta, event: event)
        case let event as MIDIFileEvent.TimeSignature:
            return .timeSignature(delta: delta, event: event)
        case let event as MIDIFileEvent.UniversalSysEx7:
            return .universalSysEx7(delta: delta, event: event)
        case let event as MIDIFileEvent.UnrecognizedMeta:
            return .unrecognizedMeta(delta: delta, event: event)
        case let event as MIDIFileEvent.XMFPatchTypePrefix:
            return .xmfPatchTypePrefix(delta: delta, event: event)
            
        default:
            // TODO: refactor to avoid resorting to fatalError
            fatalError()
        }
    }
}
