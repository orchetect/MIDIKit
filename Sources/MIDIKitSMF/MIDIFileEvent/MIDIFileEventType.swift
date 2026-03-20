//
//  MIDIFileEventType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
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

// MARK: - Concrete Type

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

// MARK: - Parsing

extension MIDIFileEventType {
    static func eventType(
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
            if let len = MIDIFile.decodeVariableLengthValue(from: data)?.byteLength {
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
        case let d where d.starts(with: MIDIFileEvent.SequenceNumber.prefixBytes): return .sequenceNumber
        case let d where d.starts(with: MIDIFileEvent.ChannelPrefix.prefixBytes): return .channelPrefix
        case let d where d.starts(with: MIDIFileEvent.PortPrefix.prefixBytes): return .portPrefix
        case let d where d.starts(with: MIDIFileEvent.Tempo.prefixBytes): return .tempo
        case let d where d.starts(with: MIDIFileEvent.SMPTEOffset.prefixBytes): return .smpteOffset
        case let d where d.starts(with: MIDIFileEvent.TimeSignature.prefixBytes): return .timeSignature
        case let d where d.starts(with: MIDIFileEvent.KeySignature.prefixBytes): return .keySignature
        case let d where d.starts(with: MIDIFileEvent.XMFPatchTypePrefix.prefixBytes): return .xmfPatchTypePrefix
        case let d where d.starts(with: MIDIFileEvent.SequencerSpecific.prefixBytes): return .sequencerSpecific
        // text events
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.text.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.copyright.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.trackOrSequenceName.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.instrumentName.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.lyric.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.marker.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.cuePoint.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.programName.prefixBytes): return .text
        case let d where d.starts(with: MIDIFileEvent.Text.EventType.deviceName.prefixBytes): return .text
        default: break
        }
        
        // this check should be last
        if data.starts(with: [0xFF]) {
            return .unrecognizedMeta
        }
        
        return nil
    }
}
