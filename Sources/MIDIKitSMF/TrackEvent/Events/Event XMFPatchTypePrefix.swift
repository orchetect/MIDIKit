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
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
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

extension MIDIFileEvent.XMFPatchTypePrefix: Equatable { }

extension MIDIFileEvent.XMFPatchTypePrefix: Hashable { }

extension MIDIFileEvent.XMFPatchTypePrefix: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
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

extension MIDI1File.Track.Event {
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
        delta: DeltaTime = .none,
        patchSet: MIDIFileEvent.XMFPatchTypePrefix.PatchSet
    ) -> Self {
        let event: MIDIFileEvent = .xmfPatchTypePrefix(
            patchSet: patchSet
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileEvent.XMFPatchTypePrefix {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x60] }
}

// MARK: - Encoding

extension MIDIFileEvent.XMFPatchTypePrefix: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .xmfPatchTypePrefix }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .xmfPatchTypePrefix(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        // Step 1: Check required byte count
        let requiredStreamByteCount: Int
        do throws(MIDIFileDecodeError) {
            requiredStreamByteCount = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 2: Parse out required bytes
        let readParam: UInt8
        do throws(MIDIFileDecodeError) {
            readParam = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
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
                
                return readParam
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard let selectParam = PatchSet(rawValue: readParam) else {
                throw .malformed(
                    "Encountered unexpected param value: \(readParam). Param should be 0, 1 or 2."
                )
            }
            
            let newEvent = Self(
                patchSet: selectParam
            )
            
            return .event(
                payload: newEvent,
                byteLength: requiredStreamByteCount
            )
        } catch {
            return .recoverableError(
                payload: nil,
                byteLength: requiredStreamByteCount,
                error: error
            )
        }
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 60 <len> <param>
        // len should always be 1, param is always one byte
        
        D(Self.prefixBytes + [0x01, patchSet.rawValue])
    }
    
    static var midi1FileFixedRawBytesLength: Int { 4 }
    
    public var midiFileDescription: String {
        "patchPrefix:\(patchSet)"
    }
    
    public var midiFileDebugDescription: String {
        "XMFPatchTypePrefix(\(patchSet))"
    }
}

extension MIDIFileEvent.XMFPatchTypePrefix {
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

extension MIDIFileEvent.XMFPatchTypePrefix.PatchSet: Equatable { }

extension MIDIFileEvent.XMFPatchTypePrefix.PatchSet: Hashable { }

extension MIDIFileEvent.XMFPatchTypePrefix.PatchSet: CaseIterable { }

extension MIDIFileEvent.XMFPatchTypePrefix.PatchSet: CustomStringConvertible {
    public var description: String {
        switch self {
        case .generalMIDI1: "General MIDI 1"
        case .generalMIDI2: "General MIDI 2"
        case .DLS: "DLS"
        }
    }
}

extension MIDIFileEvent.XMFPatchTypePrefix.PatchSet: Sendable { }
