//
//  Event XMFPatchTypePrefix.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore

// MARK: - XMFPatchTypePrefix

extension MIDIFileEvent {
    /// XMF Patch Type Prefix event.
    ///
    /// - remark: Standard MIDI File Spec 1.0:
    ///
    /// "XMF Type 0 and Type 1 files contain Standard MIDI Files (SMF). Each SMF Track in such XMF files may be designated to use either standard General MIDI 1 or General MIDI 2 instruments supplied by the player, or custom DLS instruments supplied via the XMF file. This document defines a new SMF Meta-Event to be used for this purpose.
    ///
    /// In a Type 0 or Type 1 XMF File, this meta-event specifies how to interpret subsequent Program Change and Bank Select messages appearing in the same SMF Track: as General MIDI 1, General MIDI 2, or DLS. In the absence of an initial XMF Patch Type Prefix Meta-Event, General MIDI 1 (instrument set and system behavior) is chosen by default.
    ///
    /// In a Type 0 or Type 1 XMF File, no SMF Track may be reassigned to a different instrument set (GM1, GM2, or DLS) at any time. Therefore, this meta-event should only be processed if it appears as the first message in an SMF Track; if it appears anywhere else in an SMF Track, it must be ignored."
    ///
    /// See RP-032.
    public struct XMFPatchTypePrefix: Equatable, Hashable {
        /// Patch type.
        /// (0: GM1, 1: GM2, 2: DLS instruments, supplied in the XMF file)
        public var patchSet: PatchSet = .generalMIDI1
        
        // MARK: - Init
        
        public init(patchSet: MIDIFileEvent.XMFPatchTypePrefix.PatchSet) {
            self.patchSet = patchSet
        }
    }
}

extension MIDIFileEvent.XMFPatchTypePrefix: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .xmfPatchTypePrefix
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 2-byte preamble
        guard rawBytes.starts(with: MIDIFile.kEventHeaders[.xmfPatchTypePrefix]!) else {
            throw MIDIFile.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readLength = rawBytes[2]
        
        guard readLength == 1 else {
            throw MIDIFile.DecodeError.malformed(
                "Param length should always be 1."
            )
        }
        
        let readParam = rawBytes[3]
        
        guard let selectParam = PatchSet(rawValue: readParam) else {
            throw MIDIFile.DecodeError.malformed(
                "Encountered unexpected param value: \(readParam). Param should be 0, 1 or 2."
            )
        }
        
        patchSet = selectParam
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // FF 60 <len> <param>
        // len should always be 1, param is always one byte
        
        MIDIFile.kEventHeaders[.xmfPatchTypePrefix]! + [0x01, patchSet.rawValue]
    }
    
    static let midi1SMFFixedRawBytesLength = 4
    
    public static func initFrom(
        midi1SMFRawBytesStream rawBuffer: Data
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes
        
        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Unexpected byte length."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: requiredData)
        
        return (
            newEvent: newInstance,
            bufferLength: midi1SMFFixedRawBytesLength
        )
    }
    
    public var smfDescription: String {
        "patchPrefix:\(patchSet)"
    }
    
    public var smfDebugDescription: String {
        "XMFPatchTypePrefix(\(patchSet))"
    }
}

extension MIDIFileEvent.XMFPatchTypePrefix {
    public enum PatchSet: UInt8, CaseIterable, Equatable, Hashable, CustomStringConvertible {
        /// General MIDI 1.
        ///
        /// - remark: Standard MIDI File Spec 1.0 RP-032:
        ///
        /// "GM1 is chosen by default, so starting an SMF Track with this meta-event selecting GM1 is redundant, but still permitted. Instruments will be automatically supplied and managed by the player, not supplied in the XMF file."
        case generalMIDI1 = 0x01
        
        /// General MIDI 2.
        ///
        /// - remark: Standard MIDI File Spec 1.0 RP-032:
        ///
        /// "The SMF Track has been written to take advantage of the General MIDI 2 instrument set and/or controller responses. Instruments will be automatically supplied and managed by the player, not supplied in the XMF file. If GM2 is not available, GM1 will be used."
        case generalMIDI2 = 0x02
        
        /// DLS.
        ///
        /// - remark: Standard MIDI File Spec 1.0 RP-032:
        ///
        /// "The SMF Track has been written for the custom DLS instruments supplied via the XMF file. Instruments will be supplied via the XMF file, not supplied by the player."
        case DLS = 0x03
        
        public var description: String {
            switch self {
            case .generalMIDI1: return "General MIDI 1"
            case .generalMIDI2: return "General MIDI 2"
            case .DLS: return "DLS"
            }
        }
    }
}
