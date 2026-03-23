//
//  MIDIFileTrackEventType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Cases describing MIDI file event types.
public enum MIDIFileTrackEventType: String {
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

extension MIDIFileTrackEventType: Equatable { }

extension MIDIFileTrackEventType: Hashable { }

extension MIDIFileTrackEventType: CaseIterable { }

extension MIDIFileTrackEventType: Sendable { }

// MARK: - Concrete Type

extension MIDIFileTrackEventType {
    /// Returns the concrete type associated with the MIDI file event.
    @inline(__always)
    public var concreteType: any MIDIFileTrackEventPayload.Type {
        switch self {
        case .cc:                 MIDIFileTrackEvent.CC.self
        case .channelPrefix:      MIDIFileTrackEvent.ChannelPrefix.self
        case .keySignature:       MIDIFileTrackEvent.KeySignature.self
        case .noteOff:            MIDIFileTrackEvent.NoteOff.self
        case .noteOn:             MIDIFileTrackEvent.NoteOn.self
        case .notePressure:       MIDIFileTrackEvent.NotePressure.self
        case .pitchBend:          MIDIFileTrackEvent.PitchBend.self
        case .portPrefix:         MIDIFileTrackEvent.PortPrefix.self
        case .pressure:           MIDIFileTrackEvent.Pressure.self
        case .programChange:      MIDIFileTrackEvent.ProgramChange.self
        case .rpn:                MIDIFileTrackEvent.RPN.self
        case .nrpn:               MIDIFileTrackEvent.NRPN.self
        case .sequenceNumber:     MIDIFileTrackEvent.SequenceNumber.self
        case .sequencerSpecific:  MIDIFileTrackEvent.SequencerSpecific.self
        case .smpteOffset:        MIDIFileTrackEvent.SMPTEOffset.self
        case .sysEx7:             MIDIFileTrackEvent.SysEx7.self
        case .tempo:              MIDIFileTrackEvent.Tempo.self
        case .text:               MIDIFileTrackEvent.Text.self
        case .timeSignature:      MIDIFileTrackEvent.TimeSignature.self
        case .universalSysEx7:    MIDIFileTrackEvent.UniversalSysEx7.self
        case .unrecognizedMeta:   MIDIFileTrackEvent.UnrecognizedMeta.self
        case .xmfPatchTypePrefix: MIDIFileTrackEvent.XMFPatchTypePrefix.self
        }
    }
}

extension Collection<MIDIFileTrackEventType> {
    /// Returns the collection mapped to concrete types.
    public var concreteTypes: [any MIDIFileTrackEventPayload.Type] {
        map(\.concreteType.self)
    }
}

// MARK: - Parsing

extension MIDIFileTrackEventType {
    init?(
        atStartOf data: some DataProtocol,
        runningStatus: UInt8?,
        detectParameterNumberSequence: Bool
    ) {
        guard let eventType = Self.eventType(
            atStartOf: data,
            runningStatus: runningStatus,
            detectParameterNumberSequence: detectParameterNumberSequence
        ) else { return nil }
        
        self = eventType
    }
    
    private static func eventType(
        atStartOf data: some DataProtocol,
        runningStatus: UInt8?,
        detectParameterNumberSequence: Bool
    ) -> Self? {
        // event types here are checked in order of most commonly used first
        
        // status nibble (top 4 bits) of the event's status byte.
        // running status only applies to events with a top nibble in `0x8 ... 0xE`
        guard let statusNibble = (runningStatus ?? data.first)?.nibbles.high else { return nil }
        
        switch statusNibble {
        case 0x8:
            return .noteOff
        case 0x9:
            return .noteOn
        case 0xA:
            return .notePressure
        case 0xB:
            if detectParameterNumberSequence {
                // (this could be the start of an RPN/NRPN message sequence)
                let controllerByte: UInt8? = runningStatus != nil
                    ? data.first
                    : (data.count > 1 ? data[atOffset: 1] : nil)
                if let controllerByte {
                    if controllerByte == MIDIEvent.CC.Controller.rpnMSB { return .rpn }
                    if controllerByte == MIDIEvent.CC.Controller.nrpnMSB { return .nrpn }
                } else {
                    return .cc
                }
            } else {
                return .cc
            }
        case 0xC:
            return .programChange
        case 0xD:
            return .pressure
        case 0xE:
            return .pitchBend
        default:
            break
        }
        
        if data.starts(with: [0xF0]) { // (could be a sysex or universal sysex)
            if let len = data.decodeVariableLengthValue()?.byteLength {
                let firstMsgByteOffset = len + 1
                if firstMsgByteOffset < data.count {
                    let manufacturerByte1 = data[atOffset: firstMsgByteOffset]
                    if MIDIEvent.UniversalSysExType.allCases.map(\.rawValue.uInt8Value).contains(manufacturerByte1) {
                        return .universalSysEx7
                    } else {
                        return .sysEx7
                    }
                }
            } else {
                // type of sysex could not be determined, which means it may be malformed.
                // return the default sysEx7 type instead of returning nil.
                return .sysEx7
            }
        }
        
        switch data.prefix(3) {
        // 0xFF events
        case let d where d.starts(with: MIDIFileTrackEvent.SequenceNumber.prefixBytes): return .sequenceNumber
        case let d where d.starts(with: MIDIFileTrackEvent.ChannelPrefix.prefixBytes): return .channelPrefix
        case let d where d.starts(with: MIDIFileTrackEvent.PortPrefix.prefixBytes): return .portPrefix
        case let d where d.starts(with: MIDIFileTrackEvent.Tempo.prefixBytes): return .tempo
        case let d where d.starts(with: MIDIFileTrackEvent.SMPTEOffset.prefixBytes): return .smpteOffset
        case let d where d.starts(with: MIDIFileTrackEvent.TimeSignature.prefixBytes): return .timeSignature
        case let d where d.starts(with: MIDIFileTrackEvent.KeySignature.prefixBytes): return .keySignature
        case let d where d.starts(with: MIDIFileTrackEvent.XMFPatchTypePrefix.prefixBytes): return .xmfPatchTypePrefix
        case let d where d.starts(with: MIDIFileTrackEvent.SequencerSpecific.prefixBytes): return .sequencerSpecific
        // text events
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.text.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.copyright.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.trackOrSequenceName.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.instrumentName.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.lyric.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.marker.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.cuePoint.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.programName.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileTrackEvent.Text.EventType.deviceName.prefixBytes): return .text
        default: break
        }
        
        // this check should be last
        if data.starts(with: [0xFF]) {
            return .unrecognizedMeta
        }
        
        return nil
    }
}
