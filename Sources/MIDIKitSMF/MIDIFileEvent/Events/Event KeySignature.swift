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
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
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
        delta: DeltaTime = .none,
        flatsOrSharps: Int8,
        isMajor: Bool
    ) -> Self? {
        guard let event = KeySignature(flatsOrSharps: flatsOrSharps, isMajor: isMajor) else { return nil }
        return .keySignature(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIFileEvent.KeySignature: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .keySignature
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw .malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let (readFlatsOrSharps, readIsMajor) = try rawBytes.withDataParser { parser throws(MIDIFile.DecodeError) in
            // 3-byte preamble
            let header = MIDIFile.kEventHeaders[Self.smfEventType]!
            guard let headerBytes = try? parser.read(bytes: header.count),
                  headerBytes.elementsEqual(header)
            else {
                throw .malformed("Event does not start with expected bytes.")
            }
            
            // flats/sharps - two's complement signed Int8
            let readFlatsOrSharpsByte: UInt8 = try parser.toMIDIFileDecodeError(
                malformedReason: "Flats/sharps byte is missing.",
                try parser.readByte()
            )
            let readFlatsOrSharps: Int8 = readFlatsOrSharpsByte.toInt8(as: .twosComplement)
            
            // major/minor key - 1 or 0
            let readIsMajor: UInt8 = try parser.toMIDIFileDecodeError(
                malformedReason: "Major/minor key byte is missing.",
                try parser.readByte()
            )
            
            return (readFlatsOrSharps: readFlatsOrSharps, readIsMajor: readIsMajor)
        }
        
        guard (-7 ... 7).contains(readFlatsOrSharps) else {
            throw .malformed(
                "Illegal value found when reading Key Signature event sharps/flats byte. Got \(readFlatsOrSharps) but value must be between -7 ... 7."
            )
        }
        
        guard (0 ... 1).contains(readIsMajor) else {
            throw .malformed(
                "Illegal value found when reading Key Signature event major/minor key byte. Got \(readIsMajor) but value must be between 0 ... 1."
            )
        }
        
        let isMajor = readIsMajor == 0
        
        guard let keySignature = Self(flatsOrSharps: readFlatsOrSharps, isMajor: isMajor) else {
            // This should never happen, as the values have already been validated, but throw an error just in case
            throw .malformed("Invalid key signature parameters: flats/sharps \(readFlatsOrSharps) and major/minor value \(readIsMajor)")
        }
        self = keySignature
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
        let rawBytes = stream.prefix(midi1SMFFixedRawBytesLength)
        
        let newInstance = try Self(midi1SMFRawBytes: rawBytes, runningStatus: runningStatus)
        
        return (
            newEvent: newInstance,
            bufferLength: rawBytes.count
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 59 02(length) sf mi
        // sf is a byte specifying the number of flats (-ve) or sharps (+ve) that identifies the
        // key signature (-7 = 7 flats, -1 = 1 flat, 0 = key of C, 1 = 1 sharp, etc).
        // mi is a byte specifying a major (0) or minor (1) key.
        
        D(
            MIDIFile.kEventHeaders[.keySignature]!
                // flats/sharps - two's complement signed Int8
                + [flatsOrSharps.toUInt8(as: .twosComplement)]
                // major/minor key - 1 or 0
                + [isMajor ? 0x00 : 0x01]
        )
    }
    
    static let midi1SMFFixedRawBytesLength = 5
    
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
