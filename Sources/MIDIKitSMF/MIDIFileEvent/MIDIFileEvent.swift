//
//  MIDIFileEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit
import MIDIKitCore

/// MIDI File Track Event.
public enum MIDIFileEvent: Equatable, Hashable {
    case cc(delta: DeltaTime, event: CC)
    case channelPrefix(delta: DeltaTime, event: ChannelPrefix)
    case keySignature(delta: DeltaTime, event: KeySignature)
    case noteOff(delta: DeltaTime, event: NoteOff)
    case noteOn(delta: DeltaTime, event: NoteOn)
    case notePressure(delta: DeltaTime, event: NotePressure)
    case pitchBend(delta: DeltaTime, event: PitchBend)
    case portPrefix(delta: DeltaTime, event: PortPrefix)
    case pressure(delta: DeltaTime, event: Pressure)
    case programChange(delta: DeltaTime, event: ProgramChange)
    case sequenceNumber(delta: DeltaTime, event: SequenceNumber)
    case sequencerSpecific(delta: DeltaTime, event: SequencerSpecific)
    case smpteOffset(delta: DeltaTime, event: SMPTEOffset)
    case sysEx(delta: DeltaTime, event: SysEx)
    case universalSysEx(delta: DeltaTime, event: UniversalSysEx)
    case tempo(delta: DeltaTime, event: Tempo)
    case text(delta: DeltaTime, event: Text)
    case timeSignature(delta: DeltaTime, event: TimeSignature)
    case unrecognizedMeta(delta: DeltaTime, event: UnrecognizedMeta)
    case xmfPatchTypePrefix(delta: DeltaTime, event: XMFPatchTypePrefix)
}

extension MIDIFileEvent {
    public static func cc(
        delta: DeltaTime = .none,
        controller: MIDIEvent.CC.Controller,
        value: MIDIEvent.CC.Value,
        channel: UInt4 = 0
    ) -> Self {
        .cc(
            delta: delta,
            event: .init(
                controller: controller,
                value: value,
                channel: channel
            )
        )
    }
    
    public static func cc(
        delta: DeltaTime = .none,
        controller: UInt7,
        value: MIDIEvent.CC.Value,
        channel: UInt4 = 0
    ) -> Self {
        .cc(
            delta: delta,
            event: .init(
                controller: controller,
                value: value,
                channel: channel
            )
        )
    }
    
    /// MIDI Channel Prefix event.
    ///
    /// - remark: Standard MIDI File Spec 1.0:
    ///
    /// "The MIDI channel (0-15) contained in this event may be used to associate a MIDI channel with all events which follow, including System Exclusive and meta-events. This channel is "effective" until the next normal MIDI event (which contains a channel) or the next MIDI Channel Prefix meta-event. If MIDI channels refer to "tracks", this message may help jam several tracks into a format 0 file, keeping their non-MIDI data associated with a track. This capability is also present in Yamaha's ESEQ file format."
    public static func channelPrefix(
        delta: DeltaTime = .none,
        channel: UInt4
    ) -> Self {
        .channelPrefix(
            delta: delta,
            event: .init(channel: channel)
        )
    }
    
    public static func keySignature(
        delta: DeltaTime = .none,
        flatsOrSharps: Int8,
        majorKey: Bool
    ) -> Self {
        .keySignature(
            delta: delta,
            event: .init(
                flatsOrSharps: flatsOrSharps,
                majorKey: majorKey
            )
        )
    }
    
    public static func noteOff(
        delta: DeltaTime = .none,
        note: MIDINote,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOff(
            delta: delta,
            event: .init(
                note: note,
                velocity: velocity,
                channel: channel
            )
        )
    }
    
    public static func noteOff(
        delta: DeltaTime = .none,
        note: UInt7,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOff(
            delta: delta,
            event: .init(
                note: note,
                velocity: velocity,
                channel: channel
            )
        )
    }
    
    public static func noteOn(
        delta: DeltaTime = .none,
        note: MIDINote,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOn(
            delta: delta,
            event: .init(
                note: note,
                velocity: velocity,
                channel: channel
            )
        )
    }
    
    public static func noteOn(
        delta: DeltaTime = .none,
        note: UInt7,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOn(
            delta: delta,
            event: .init(
                note: note,
                velocity: velocity,
                channel: channel
            )
        )
    }
    
    public static func notePressure(
        delta: DeltaTime = .none,
        note: MIDINote,
        amount: MIDIEvent.NotePressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .notePressure(
            delta: delta,
            event: .init(
                note: note,
                amount: amount,
                channel: channel
            )
        )
    }
    
    public static func notePressure(
        delta: DeltaTime = .none,
        note: UInt7,
        amount: MIDIEvent.NotePressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .notePressure(
            delta: delta,
            event: .init(
                note: note,
                amount: amount,
                channel: channel
            )
        )
    }
    
    public static func pitchBend(
        delta: DeltaTime = .none,
        lsb: UInt8,
        msb: UInt8,
        channel: UInt4 = 0
    ) -> Self {
        let value = MIDIEvent.PitchBend.Value.midi1(.init(bytePair: .init(msb: msb, lsb: lsb)))
        return .pitchBend(
            delta: delta,
            event: .init(value: value, channel: channel)
        )
    }
    
    public static func pitchBend(
        delta: DeltaTime = .none,
        value: MIDIEvent.PitchBend.Value,
        channel: UInt4 = 0
    ) -> Self {
        .pitchBend(
            delta: delta,
            event: .init(value: value, channel: channel)
        )
    }
    
    public static func portPrefix(
        delta: DeltaTime = .none,
        port: UInt7
    ) -> Self {
        .portPrefix(
            delta: delta,
            event: .init(port: port)
        )
    }
    
    public static func pressure(
        delta: DeltaTime = .none,
        amount: MIDIEvent.Pressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .pressure(
            delta: delta,
            event: .init(
                amount: amount,
                channel: channel
            )
        )
    }
    
    public static func programChange(
        delta: DeltaTime = .none,
        program: UInt7,
        channel: UInt4 = 0
    ) -> Self {
        .programChange(
            delta: delta,
            event: .init(
                program: program,
                bank: .noBankSelect,
                channel: channel
            )
        )
    }
    
    public static func sequenceNumber(
        delta: DeltaTime = .none,
        sequence: UInt16
    ) -> Self {
        .sequenceNumber(
            delta: delta,
            event: .init(sequence: sequence)
        )
    }
    
    public static func sequencerSpecific(
        delta: DeltaTime = .none,
        data: [Byte]
    ) -> Self {
        .sequencerSpecific(
            delta: delta,
            event: .init(data: data)
        )
    }
    
    public static func smpteOffset(
        delta: DeltaTime = .none,
        hr: UInt8,
        min: UInt8,
        sec: UInt8,
        fr: UInt8,
        subFr: UInt8,
        frRate: MIDIFile.SMPTEOffsetFrameRate = ._30fps
    ) -> Self {
        .smpteOffset(
            delta: delta,
            event: .init(
                hr: hr,
                min: min,
                sec: sec,
                fr: fr,
                subFr: subFr,
                frRate: frRate
            )
        )
    }
    
    public static func smpteOffset(
        delta: DeltaTime = .none,
        scaling: Timecode
    ) -> Self {
        .smpteOffset(
            delta: delta,
            event: .init(scaling: scaling)
        )
    }
    
    public static func sysEx(
        delta: DeltaTime = .none,
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [Byte]
    ) -> Self {
        .sysEx(
            delta: delta,
            event: .init(
                manufacturer: manufacturer,
                data: data
            )
        )
    }
    
    public static func tempo(
        delta: DeltaTime = .none,
        bpm: Double
    ) -> Self {
        .tempo(
            delta: delta,
            event: .init(bpm: bpm)
        )
    }
    
    public static func text(
        delta: DeltaTime = .none,
        type: Text.EventType,
        string: String
    ) -> Self {
        .text(
            delta: delta,
            event: .init(
                type: type,
                string: string
            )
        )
    }
    
    public static func timeSignature(
        delta: DeltaTime = .none,
        numerator: UInt8,
        denominator: UInt8
    ) -> Self {
        .timeSignature(
            delta: delta,
            event: .init(
                numerator: numerator,
                denominator: denominator
            )
        )
    }
    
    public static func unrecognizedMeta(
        delta: DeltaTime = .none,
        metaType: UInt8,
        data: [Byte]
    ) -> Self {
        .unrecognizedMeta(
            delta: delta,
            event: .init(
                metaType: metaType,
                data: data
            )
        )
    }
    
    public static func universalSysEx(
        delta: DeltaTime = .none,
        universalType: MIDIEvent.UniversalSysExType,
        deviceID: UInt7,
        subID1: UInt7,
        subID2: UInt7,
        data: [Byte]
    ) -> Self {
        .universalSysEx(
            delta: delta,
            event: .init(
                universalType: universalType,
                deviceID: deviceID,
                subID1: subID1,
                subID2: subID2,
                data: data
            )
        )
    }
    
    public static func xmfPatchTypePrefix(
        delta: DeltaTime = .none,
        patchSet: XMFPatchTypePrefix.PatchSet
    ) -> Self {
        .xmfPatchTypePrefix(
            delta: delta,
            event: .init(patchSet: patchSet)
        )
    }
}

extension MIDIFileEvent {
    public var eventType: MIDIFileEventType {
        switch self {
        case .cc: return .cc
        case .channelPrefix: return .channelPrefix
        case .keySignature: return .keySignature
        case .noteOff: return .noteOff
        case .noteOn: return .noteOn
        case .notePressure: return .notePressure
        case .pitchBend: return .pitchBend
        case .portPrefix: return .portPrefix
        case .pressure: return .pressure
        case .programChange: return .programChange
        case .sequenceNumber: return .sequenceNumber
        case .sequencerSpecific: return .sequencerSpecific
        case .smpteOffset: return .smpteOffset
        case .sysEx: return .sysEx
        case .tempo: return .tempo
        case .text: return .text
        case .timeSignature: return .timeSignature
        case .universalSysEx: return .universalSysEx
        case .unrecognizedMeta: return .unrecognizedMeta
        case .xmfPatchTypePrefix: return .xmfPatchTypePrefix
        }
    }
}

extension MIDIFileEvent {
    public var concreteType: MIDIFileEventPayload.Type {
        switch self {
        case .cc: return CC.self
        case .channelPrefix: return ChannelPrefix.self
        case .keySignature: return KeySignature.self
        case .noteOff: return NoteOff.self
        case .noteOn: return NoteOn.self
        case .notePressure: return NotePressure.self
        case .pitchBend: return PitchBend.self
        case .portPrefix: return PortPrefix.self
        case .pressure: return Pressure.self
        case .programChange: return ProgramChange.self
        case .sequenceNumber: return SequenceNumber.self
        case .sequencerSpecific: return SequencerSpecific.self
        case .smpteOffset: return SMPTEOffset.self
        case .sysEx: return SysEx.self
        case .tempo: return Tempo.self
        case .text: return Text.self
        case .timeSignature: return TimeSignature.self
        case .universalSysEx: return UniversalSysEx.self
        case .unrecognizedMeta: return UnrecognizedMeta.self
        case .xmfPatchTypePrefix: return XMFPatchTypePrefix.self
        }
    }
}

extension MIDIFileEvent {
    /// Unwraps the enum case and returns the `MIDIFileEvent` contained within, typed as `MIDIFileEvent` protocol.
    public var smfUnwrappedEvent: (delta: DeltaTime, event: MIDIFileEventPayload) {
        switch self {
        case let .cc(delta, event): return (delta: delta, event: event)
        case let .channelPrefix(delta, event): return (delta: delta, event: event)
        case let .keySignature(delta, event): return (delta: delta, event: event)
        case let .noteOff(delta, event): return (delta: delta, event: event)
        case let .noteOn(delta, event): return (delta: delta, event: event)
        case let .notePressure(delta, event): return (delta: delta, event: event)
        case let .pitchBend(delta, event): return (delta: delta, event: event)
        case let .portPrefix(delta, event): return (delta: delta, event: event)
        case let .pressure(delta, event): return (delta: delta, event: event)
        case let .programChange(delta, event): return (delta: delta, event: event)
        case let .sequenceNumber(delta, event): return (delta: delta, event: event)
        case let .sequencerSpecific(delta, event): return (delta: delta, event: event)
        case let .smpteOffset(delta, event): return (delta: delta, event: event)
        case let .sysEx(delta, event): return (delta: delta, event: event)
        case let .tempo(delta, event): return (delta: delta, event: event)
        case let .text(delta, event): return (delta: delta, event: event)
        case let .timeSignature(delta, event): return (delta: delta, event: event)
        case let .universalSysEx(delta, event): return (delta: delta, event: event)
        case let .unrecognizedMeta(delta, event): return (delta: delta, event: event)
        case let .xmfPatchTypePrefix(delta, event): return (delta: delta, event: event)
        }
    }
}

extension MIDIFileEventPayload {
    /// Wraps the concrete struct in its corresponding `MIDIFileEvent` enum case wrapper.
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
        case let event as MIDIFileEvent.SysEx:
            return .sysEx(delta: delta, event: event)
        case let event as MIDIFileEvent.Tempo:
            return .tempo(delta: delta, event: event)
        case let event as MIDIFileEvent.Text:
            return .text(delta: delta, event: event)
        case let event as MIDIFileEvent.TimeSignature:
            return .timeSignature(delta: delta, event: event)
        case let event as MIDIFileEvent.UniversalSysEx:
            return .universalSysEx(delta: delta, event: event)
        case let event as MIDIFileEvent.UnrecognizedMeta:
            return .unrecognizedMeta(delta: delta, event: event)
        case let event as MIDIFileEvent.XMFPatchTypePrefix:
            return .xmfPatchTypePrefix(delta: delta, event: event)
            
        default:
            fatalError()
        }
    }
}
