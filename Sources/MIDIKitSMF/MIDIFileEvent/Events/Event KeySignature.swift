//
//  Event KeySignature.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
@_implementationOnly import MIDIKitInternals

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
    public struct KeySignature: Equatable, Hashable {
        /// Number of flats that identifies the key signature
        /// (-7 = 7 flats, -1 = 1 flat, 0 = key of C, 1 = 1 sharp, etc).
        public var flatsOrSharps: Int8 = 0 {
            didSet {
                if oldValue != flatsOrSharps { flatsOrSharps_Validate() }
            }
        }

        private mutating func flatsOrSharps_Validate() {
            flatsOrSharps = flatsOrSharps.clamped(to: -7 ... 7)
        }

        /// Major (true) or Minor (false) key.
        public var majorKey: Bool = true
        
        // MARK: - Init
        
        public init(
            flatsOrSharps: Int8,
            majorKey: Bool
        ) {
            self.flatsOrSharps = flatsOrSharps
            self.majorKey = majorKey
        }
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
}

// MARK: - Encoding

extension MIDIFileEvent.KeySignature: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .keySignature
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        try rawBytes.withDataReader { dataReader in
            // 3-byte preamble
            guard try dataReader.read(bytes: 3).elementsEqual(
                MIDIFile.kEventHeaders[Self.smfEventType]!
            ) else {
                throw MIDIFile.DecodeError.malformed(
                    "Event does not start with expected bytes."
                )
            }
        
            // flats/sharps - two's complement signed Int8
            let readFlatsOrSharps = try Int8(bitPattern: dataReader.readByte())
            // major/minor key - 1 or 0
            let readMajMinKey = try dataReader.readByte()
        
            guard (-7 ... 7).contains(readFlatsOrSharps) else {
                throw MIDIFile.DecodeError.malformed(
                    "Illegal value found when reading Key Signature event sharps/flats byte. Got \(readFlatsOrSharps) but value must be between -7 ... 7."
                )
            }
        
            guard (0 ... 1).contains(readMajMinKey) else {
                throw MIDIFile.DecodeError.malformed(
                    "Illegal value found when reading Key Signature event major/minor key byte. Got \(readFlatsOrSharps) but value must be between 0 ... 1."
                )
            }
        
            flatsOrSharps = readFlatsOrSharps
            majorKey = readMajMinKey == 0
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // FF 59 02(length) sf mi
        // sf is a byte specifying the number of flats (-ve) or sharps (+ve) that identifies the
        // key signature (-7 = 7 flats, -1 = 1 flat, 0 = key of C, 1 = 1 sharp, etc).
        // mi is a byte specifying a major (0) or minor (1) key.
        
        D(
            MIDIFile.kEventHeaders[.keySignature]! +
                // flats/sharps - two's complement signed Int8
                [flatsOrSharps.twosComplement] +
                // major/minor key - 1 or 0
                [majorKey ? 0x00 : 0x01]
        )
    }
    
    static let midi1SMFFixedRawBytesLength = 5

    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws -> StreamDecodeResult {
        let requiredData = stream.prefix(midi1SMFFixedRawBytesLength)

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
        stringValue
    }
    
    public var smfDebugDescription: String {
        "KeySignature(" + smfDescription + ")"
    }
}

extension MIDIFileEvent.KeySignature {
    public var stringValue: String {
        var outputString = ""

        switch flatsOrSharps {
        case ..<0:
            outputString += "\(abs(flatsOrSharps))♭"
        case 0:
            outputString += "No signature"
        case 1...:
            outputString += "\(flatsOrSharps)♯"
        default:
            // this should never happen
            outputString += "?"
        }

        switch majorKey {
        case true:
            outputString += " Major"
        case false:
            outputString += " Minor"
        }

        return outputString
    }
}
