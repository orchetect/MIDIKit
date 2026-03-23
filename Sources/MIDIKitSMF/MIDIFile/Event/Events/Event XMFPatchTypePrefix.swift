//
//  Event XMFPatchTypePrefix.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - XMFPatchTypePrefix

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// XMF Patch Type Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > XMF Type 0 and Type 1 files contain Standard MIDI Files (SMF). Each SMF Track in such XMF
    /// > files may be designated to use either standard General MIDI 1 or General MIDI 2
    /// > instruments supplied by the player, or custom DLS instruments supplied via the XMF
    /// > file. This document defines a new SMF Meta-Event to be used for this purpose.
    /// >
    /// > In a Type 0 or Type 1 XMF File, this meta-event specifies how to interpret subsequent
    /// > Program Change and Bank Select messages appearing in the same SMF Track: as General
    /// > MIDI 1, General MIDI 2, or DLS. In the absence of an initial XMF Patch Type Prefix
    /// > Meta-Event, General MIDI 1 (instrument set and system behavior) is chosen by default.
    /// >
    /// > In a Type 0 or Type 1 XMF File, no SMF Track may be reassigned to a different instrument
    /// > set (GM1, GM2, or DLS) at any time. Therefore, this meta-event should only be processed if
    /// > it appears as the first message in an SMF Track; if it appears anywhere else in an SMF
    /// > Track, it must be ignored.
    /// >
    /// > See [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).
    public struct XMFPatchTypePrefix {
        /// Patch type.
        /// (0: GM1, 1: GM2, 2: DLS instruments, supplied in the XMF file)
        public var patchSet: PatchSet = .generalMIDI1
        
        // MARK: - Init
        
        public init(patchSet: PatchSet) {
            self.patchSet = patchSet
        }
    }
}

extension MIDIFileTrackEvent.XMFPatchTypePrefix: Equatable { }

extension MIDIFileTrackEvent.XMFPatchTypePrefix: Hashable { }

extension MIDIFileTrackEvent.XMFPatchTypePrefix: Sendable { }

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// XMF Patch Type Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > XMF Type 0 and Type 1 files contain Standard MIDI Files (SMF). Each SMF Track in such XMF
    /// > files may be designated to use either standard General MIDI 1 or General MIDI 2
    /// > instruments supplied by the player, or custom DLS instruments supplied via the XMF
    /// > file. This document defines a new SMF Meta-Event to be used for this purpose.
    /// >
    /// > In a Type 0 or Type 1 XMF File, this meta-event specifies how to interpret subsequent
    /// > Program Change and Bank Select messages appearing in the same SMF Track: as General
    /// > MIDI 1, General MIDI 2, or DLS. In the absence of an initial XMF Patch Type Prefix
    /// > Meta-Event, General MIDI 1 (instrument set and system behavior) is chosen by default.
    /// >
    /// > In a Type 0 or Type 1 XMF File, no SMF Track may be reassigned to a different instrument
    /// > set (GM1, GM2, or DLS) at any time. Therefore, this meta-event should only be processed if
    /// > it appears as the first message in an SMF Track; if it appears anywhere else in an SMF
    /// > Track, it must be ignored.
    /// >
    /// > See [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).
    public static func xmfPatchTypePrefix(
        patchSet: XMFPatchTypePrefix.PatchSet
    ) -> Self {
        .xmfPatchTypePrefix(
            .init(patchSet: patchSet)
        )
    }
}

extension MIDIFile.TrackChunk.Event {
    /// XMF Patch Type Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > XMF Type 0 and Type 1 files contain Standard MIDI Files (SMF). Each SMF Track in such XMF
    /// > files may be designated to use either standard General MIDI 1 or General MIDI 2
    /// > instruments supplied by the player, or custom DLS instruments supplied via the XMF
    /// > file. This document defines a new SMF Meta-Event to be used for this purpose.
    /// >
    /// > In a Type 0 or Type 1 XMF File, this meta-event specifies how to interpret subsequent
    /// > Program Change and Bank Select messages appearing in the same SMF Track: as General
    /// > MIDI 1, General MIDI 2, or DLS. In the absence of an initial XMF Patch Type Prefix
    /// > Meta-Event, General MIDI 1 (instrument set and system behavior) is chosen by default.
    /// >
    /// > In a Type 0 or Type 1 XMF File, no SMF Track may be reassigned to a different instrument
    /// > set (GM1, GM2, or DLS) at any time. Therefore, this meta-event should only be processed if
    /// > it appears as the first message in an SMF Track; if it appears anywhere else in an SMF
    /// > Track, it must be ignored.
    /// >
    /// > See [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).
    public static func xmfPatchTypePrefix(
        delta: MIDIFile.TrackChunk.DeltaTime = .none,
        patchSet: MIDIFileTrackEvent.XMFPatchTypePrefix.PatchSet
    ) -> Self {
        let event: MIDIFileTrackEvent = .xmfPatchTypePrefix(
            patchSet: patchSet
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileTrackEvent.XMFPatchTypePrefix {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x60] }
}

// MARK: - Encoding

extension MIDIFileTrackEvent.XMFPatchTypePrefix: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .xmfPatchTypePrefix }
    
    public var wrapped: MIDIFileTrackEvent {
        .xmfPatchTypePrefix(self)
    }
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw .malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        try rawBytes.withDataParser { parser throws(MIDIFileDecodeError) in
            // 2-byte preamble
            guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                  headerBytes.elementsEqual(Self.prefixBytes)
            else {
                throw .malformed("Event does not start with expected bytes.")
            }
            
            let readLength = try parser.toMIDIFileDecodeError(
                malformedReason: "Param length byte is missing.",
                try parser.readByte()
            )
            guard readLength == 1 else {
                throw .malformed(
                    "Param length should always be 1."
                )
            }
            
            let readParam = try parser.toMIDIFileDecodeError(
                malformedReason: "Param value byte is missing.",
                try parser.readByte()
            )
            
            guard let selectParam = PatchSet(rawValue: readParam) else {
                throw .malformed(
                    "Encountered unexpected param value: \(readParam). Param should be 0, 1 or 2."
                )
            }
            
            patchSet = selectParam
        }
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) -> StreamDecodeResult {
        let rawBytes = stream.prefix(midi1SMFFixedRawBytesLength)
        
        let newInstance = try Self(midi1SMFRawBytes: rawBytes, runningStatus: runningStatus)
        
        return (
            newEvent: newInstance,
            bufferLength: rawBytes.count
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 60 <len> <param>
        // len should always be 1, param is always one byte
        
        D(Self.prefixBytes + [0x01, patchSet.rawValue])
    }
    
    static var midi1SMFFixedRawBytesLength: Int { 4 }
    
    public var smfDescription: String {
        "patchPrefix:\(patchSet)"
    }
    
    public var smfDebugDescription: String {
        "XMFPatchTypePrefix(\(patchSet))"
    }
}

extension MIDIFileTrackEvent.XMFPatchTypePrefix {
    /// XMF Patch Set.
    public enum PatchSet: UInt8 {
        /// General MIDI 1.
        ///
        /// > Standard MIDI File 1.0 Spec, RP-032:
        /// >
        /// > GM1 is chosen by default, so starting an SMF Track with this meta-event selecting GM1
        /// > is redundant, but still permitted. Instruments will be automatically supplied and
        /// > managed by the player, not supplied in the XMF file.
        /// >
        /// > See
        /// > [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).
        case generalMIDI1 = 0x01
        
        /// General MIDI 2.
        ///
        /// > Standard MIDI File 1.0 Spec, RP-032:
        /// >
        /// > The SMF Track has been written to take advantage of the General MIDI 2 instrument set
        /// > and/or controller responses. Instruments will be automatically supplied and managed by
        /// > the player, not supplied in the XMF file. If GM2 is not available, GM1 will be used.
        /// >
        /// > See
        /// > [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).
        case generalMIDI2 = 0x02
        
        /// DLS.
        ///
        /// > Standard MIDI File 1.0 Spec, RP-032:
        /// >
        /// > The SMF Track has been written for the custom DLS instruments supplied via the XMF
        /// > file. Instruments will be supplied via the XMF file, not supplied by the player.
        /// >
        /// > See
        /// > [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).
        case DLS = 0x03
    }
}

extension MIDIFileTrackEvent.XMFPatchTypePrefix.PatchSet: Equatable { }

extension MIDIFileTrackEvent.XMFPatchTypePrefix.PatchSet: Hashable { }

extension MIDIFileTrackEvent.XMFPatchTypePrefix.PatchSet: CaseIterable { }

extension MIDIFileTrackEvent.XMFPatchTypePrefix.PatchSet: CustomStringConvertible {
    public var description: String {
        switch self {
        case .generalMIDI1: "General MIDI 1"
        case .generalMIDI2: "General MIDI 2"
        case .DLS: "DLS"
        }
    }
}

extension MIDIFileTrackEvent.XMFPatchTypePrefix.PatchSet: Sendable { }
