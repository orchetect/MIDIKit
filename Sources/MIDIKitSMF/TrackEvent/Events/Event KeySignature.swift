//
//  Event KeySignature.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

// MARK: - KeySignature

// ------------------------------------
// // NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Key Signature event.
    ///
    /// For a format 1 MIDI file, Key Signature Meta events should only occur within the first
    /// `MTrk` chunk.
    ///
    /// If there are no key signature events in a MIDI file, C major is assumed.
    public enum KeySignature {
        // No Sharps/Flats
        case cMajor
        case aMinor
        
        // Sharps 1 ... 7, Major
        case gMajor
        case dMajor
        case aMajor
        case eMajor
        case bMajor
        case fSharpMajor
        case cSharpMajor
        
        // Sharps 1 ... 7, Minor
        case eMinor
        case bMinor
        case fSharpMinor
        case cSharpMinor
        case gSharpMinor
        case dSharpMinor
        case aSharpMinor
        
        // Flats 1 ... 7, Major
        case fMajor
        case bFlatMajor
        case eFlatMajor
        case aFlatMajor
        case dFlatMajor
        case gFlatMajor
        case cFlatMajor
        
        // Flats 1 ... 7, Minor
        case dMinor
        case gMinor
        case cMinor
        case fMinor
        case bFlatMinor
        case eFlatMinor
        case aFlatMinor
    }
}

extension MIDIFileEvent.KeySignature: Equatable { }

extension MIDIFileEvent.KeySignature: Hashable { }

extension MIDIFileEvent.KeySignature: CaseIterable { }

extension MIDIFileEvent.KeySignature: Sendable { }

// MARK: - Init

extension MIDIFileEvent.KeySignature {
    /// Initialize from raw encoded values.
    public init?(
        flatsOrSharps: Int8,
        isMajor: Bool
    ) {
        guard let match = Self.allCases
            .filter({ $0.flatsOrSharps == flatsOrSharps })
            .filter({ $0.isMajor == isMajor })
            .first
        else { return nil }
        self = match
    }
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Key Signature event.
    ///
    /// For a format 1 MIDI file, Key Signature Meta events should only occur within the first
    /// `MTrk` chunk.
    ///
    /// If there are no key signature events in a MIDI file, C major is assumed.
    public static func keySignature(
        flatsOrSharps: Int8,
        isMajor: Bool
    ) -> Self? {
        guard let event = KeySignature(flatsOrSharps: flatsOrSharps, isMajor: isMajor) else { return nil }
        return .keySignature(event)
    }
}

extension MIDI1File.TrackChunk.Event {
    /// Key Signature event.
    ///
    /// For a format 1 MIDI file, Key Signature Meta events should only occur within the first
    /// `MTrk` chunk.
    ///
    /// If there are no key signature events in a MIDI file, C major is assumed.
    public static func keySignature(
        delta: DeltaTime = .none,
        key event: MIDIFileEvent.KeySignature
    ) -> Self {
        Self(delta: delta, event: .keySignature(event))
    }
    
    /// Key Signature event.
    ///
    /// For a format 1 MIDI file, Key Signature Meta events should only occur within the first
    /// `MTrk` chunk.
    ///
    /// If there are no key signature events in a MIDI file, C major is assumed.
    public static func keySignature(
        delta: DeltaTime = .none,
        flatsOrSharps: Int8,
        isMajor: Bool
    ) -> Self? {
        guard let event: MIDIFileEvent = .keySignature(flatsOrSharps: flatsOrSharps, isMajor: isMajor) else { return nil }
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileEvent.KeySignature {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x59, 0x02] }
}

// MARK: - Encoding

extension MIDIFileEvent.KeySignature: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .keySignature }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .keySignature(self)
    }
    
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
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
        let readFlatsOrSharps: Int8
        let readIsMajor: UInt8
        do throws(MIDIFileDecodeError) {
            (readFlatsOrSharps, readIsMajor) = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
                // 3-byte preamble
                guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                      headerBytes.elementsEqual(Self.prefixBytes)
                else {
                    throw .malformed("Key Signature event does not start with expected bytes.")
                }
                
                // flats/sharps - two's complement signed Int8
                let readFlatsOrSharpsByte: UInt8 = try parser.toMIDIFileDecodeError(
                    malformedReason: "Key Signature flats/sharps byte is missing.",
                    try parser.readByte()
                )
                let readFlatsOrSharps: Int8 = readFlatsOrSharpsByte.toInt8(as: .twosComplement)
                
                // major/minor key - 1 or 0
                let readIsMajor: UInt8 = try parser.toMIDIFileDecodeError(
                    malformedReason: "Key Signature major/minor key byte is missing.",
                    try parser.readByte()
                )
                
                return (readFlatsOrSharps: readFlatsOrSharps, readIsMajor: readIsMajor)
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard (-7 ... 7).contains(readFlatsOrSharps) else {
                throw .malformed(
                    "Key Signature has invalid sharps/flats byte. Got \(readFlatsOrSharps) but value must be between -7 ... 7."
                )
            }
            
            guard (0 ... 1).contains(readIsMajor) else {
                throw .malformed(
                    "Key Signature has invalid major/minor key byte. Got \(readIsMajor) but value must be between 0 ... 1."
                )
            }
        } catch {
            return .recoverableError(payload: nil, byteLength: requiredStreamByteCount, error: error)
        }
        
        let isMajor = readIsMajor == 0
        
        guard let newEvent = Self(flatsOrSharps: readFlatsOrSharps, isMajor: isMajor) else {
            // This should never happen, as the values have already been validated, but throw an error just in case
            let error: MIDIFileDecodeError = .malformed(
                "Invalid key signature parameters: flats/sharps \(readFlatsOrSharps) and major/minor value \(readIsMajor)"
            )
            return .recoverableError(
                payload: nil,
                byteLength: requiredStreamByteCount,
                error: error
            )
        }
        
        return .event(
            payload: newEvent,
            byteLength: requiredStreamByteCount
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 59 02(length) sf mi
        // sf is a byte specifying the number of flats (-ve) or sharps (+ve) that identifies the
        // key signature (-7 = 7 flats, -1 = 1 flat, 0 = key of C, 1 = 1 sharp, etc).
        // mi is a byte specifying a major (0) or minor (1) key.
        
        D(
            Self.prefixBytes
                // flats/sharps - two's complement signed Int8
                + [flatsOrSharps.toUInt8(as: .twosComplement)]
                // major/minor key - 1 or 0
                + [isMajor ? 0x00 : 0x01]
        )
    }
    
    public var smfDescription: String {
        stringValue
    }
    
    public var smfDebugDescription: String {
        "KeySignature(" + smfDescription + ")"
    }
}

extension MIDIFileEvent.KeySignature {
    /// Returns the raw encoded value of the number of flats or sharps.
    /// `0` indicates no sharps or flats (C major or A minor).
    /// A positive integer represents the number of sharps (1 through 7), while a negative integer
    /// represents the number of flats (-1 through -7).
    /// Any values outside of the range `-7 ... 7` are invalid.
    public var flatsOrSharps: Int8 {
        get {
            // No Sharps/Flats
            switch self {
            case .cMajor: 0
            case .aMinor: 0
            // Sharps 1 ... 7, Major
            case .gMajor: 1
            case .dMajor: 2
            case .aMajor: 3
            case .eMajor: 4
            case .bMajor: 5
            case .fSharpMajor: 6
            case .cSharpMajor: 7
            // Sharps 1 ... 7, Minor
            case .eMinor: 1
            case .bMinor: 2
            case .fSharpMinor: 3
            case .cSharpMinor: 4
            case .gSharpMinor: 5
            case .dSharpMinor: 6
            case .aSharpMinor: 7
            // Flats 1 ... 7, Major
            case .fMajor: -1
            case .bFlatMajor: -2
            case .eFlatMajor: -3
            case .aFlatMajor: -4
            case .dFlatMajor: -5
            case .gFlatMajor: -6
            case .cFlatMajor: -7
            // Flats 1 ... 7, Minor
            case .dMinor: -1
            case .gMinor: -2
            case .cMinor: -3
            case .fMinor: -4
            case .bFlatMinor: -5
            case .eFlatMinor: -6
            case .aFlatMinor: -7
            }
        }
        set {
            guard let match = Self.allCases
                .filter( { $0.flatsOrSharps == newValue })
                .filter( { $0.isMajor == isMajor })
                .first
            else {
                return
            }
            self = match
        }
    }
    
    /// Returns `true` if the key signature is major key. Returns `false` if it is minor key.
    public var isMajor: Bool {
        get {
            // No Sharps/Flats
            switch self {
            case .cMajor: true
            case .aMinor: false
            // Sharps 1 ... 7, Major
            case .gMajor: true
            case .dMajor: true
            case .aMajor: true
            case .eMajor: true
            case .bMajor: true
            case .fSharpMajor: true
            case .cSharpMajor: true
            // Sharps 1 ... 7, Minor
            case .eMinor: false
            case .bMinor: false
            case .fSharpMinor: false
            case .cSharpMinor: false
            case .gSharpMinor: false
            case .dSharpMinor: false
            case .aSharpMinor: false
            // Flats 1 ... 7, Major
            case .fMajor: true
            case .bFlatMajor: true
            case .eFlatMajor: true
            case .aFlatMajor: true
            case .dFlatMajor: true
            case .gFlatMajor: true
            case .cFlatMajor: true
            // Flats 1 ... 7, Minor
            case .dMinor: false
            case .gMinor: false
            case .cMinor: false
            case .fMinor: false
            case .bFlatMinor: false
            case .eFlatMinor: false
            case .aFlatMinor: false
            }
        }
        set {
            guard let match = Self.allCases
                .filter( { $0.flatsOrSharps == flatsOrSharps })
                .filter( { $0.isMajor == newValue })
                .first
            else {
                return
            }
            self = match
        }
    }
    
    /// Returns the key signature description suitable for UI display.
    public var stringValue: String {
        // No Sharps/Flats
        switch self {
        case .cMajor: "C Major"
        case .aMinor: "A Minor"
        // Sharps 1 ... 7, Major
        case .gMajor: "G Major"
        case .dMajor: "D Major"
        case .aMajor: "A Major"
        case .eMajor: "E Major"
        case .bMajor: "B Major"
        case .fSharpMajor: "F♯ Major"
        case .cSharpMajor: "C♯ Major"
        // Sharps 1 ... 7, Minor
        case .eMinor: "E Minor"
        case .bMinor: "B Minor"
        case .fSharpMinor: "F♯ Minor"
        case .cSharpMinor: "C♯ Minor"
        case .gSharpMinor: "G♯ Minor"
        case .dSharpMinor: "D♯ Minor"
        case .aSharpMinor: "A♯ Minor"
        // Flats 1 ... 7, Major
        case .fMajor: "F Major"
        case .bFlatMajor: "B♭ Major"
        case .eFlatMajor: "E♭ Major"
        case .aFlatMajor: "A♭ Major"
        case .dFlatMajor: "D♭ Major"
        case .gFlatMajor: "G♭ Major"
        case .cFlatMajor: "C♭ Major"
        // Flats 1 ... 7, Minor
        case .dMinor: "D Minor"
        case .gMinor: "G Minor"
        case .cMinor: "C Minor"
        case .fMinor: "F Minor"
        case .bFlatMinor: "B♭ Minor"
        case .eFlatMinor: "E♭ Minor"
        case .aFlatMinor: "A♭ Minor"
        }
    }
}
