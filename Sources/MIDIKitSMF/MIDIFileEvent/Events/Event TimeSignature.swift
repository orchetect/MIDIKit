//
//  Event TimeSignature.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - TimeSignature

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Time Signature event.
    /// For a format 1 MIDI file, Time Signature meta events should only occur within the first
    /// `MTrk` chunk.
    /// If there are no Time Signature events in a MIDI file, 4/4 is assumed.
    public struct TimeSignature {
        /// Numerator in time signature fraction: Literal numerator
        public var numerator: UInt8 = 4

        /// Denominator in time signature fraction.
        /// Expressed as a power of 2. (ie: 2 = 2^2 = 4, 3 = 2^3 = 8, etc.)
        public var denominator: UInt8 = 2

        /// Number of MIDI clocks between metronome clicks.
        public var midiClocksBetweenMetronomeClicks: UInt8 = 0x18

        /// Number of notated 32nd-notes in a MIDI quarter-note.
        /// The usual value for this parameter is 8, though some sequencers allow the user to
        /// specify that what MIDI thinks of as a quarter note, should be notated as something else.
        public var numberOf32ndNotesInAQuarterNote: UInt8 = 8
        
        // MARK: - Init
        
        public init() { }
        
        /// Time Signature Event.
        ///
        /// - Parameters:
        ///   - numerator: Numerator in time signature fraction: Literal numerator.
        ///   - denominator: Denominator in time signature fraction. Expressed as a power of 2. (ie: 2 = 2^2 = 4, 3 = 2^3 = 8, etc.)
        ///   - midiClocksBetweenMetronomeClicks: Number of MIDI clocks between metronome clicks.
        ///   - numberOf32ndNotesInAQuarterNote: Number of notated 32nd-notes in a MIDI quarter-note.
        public init(
            numerator: UInt8,
            denominator: UInt8,
            midiClocksBetweenMetronomeClicks: UInt8 = 0x18,
            numberOf32ndNotesInAQuarterNote: UInt8 = 8
        ) {
            self.numerator = numerator
            self.denominator = denominator
            self.midiClocksBetweenMetronomeClicks = midiClocksBetweenMetronomeClicks
            self.numberOf32ndNotesInAQuarterNote = numberOf32ndNotesInAQuarterNote
        }
    }
}

extension MIDIFileEvent.TimeSignature: Equatable { }

extension MIDIFileEvent.TimeSignature: Hashable { }

extension MIDIFileEvent.TimeSignature: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Time Signature event.
    /// For a format 1 MIDI file, Time Signature meta events should only occur within the first
    /// `MTrk` chunk.
    /// If there are no Time Signature events in a MIDI file, 4/4 is assumed.
    ///
    /// - Parameters:
    ///   - delta: Delta time since the last event.
    ///   - numerator: Numerator in time signature fraction: Literal numerator.
    ///   - denominator: Denominator in time signature fraction. Expressed as a power of 2. (ie: 2 = 2^2 = 4, 3 = 2^3 = 8, etc.)
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
}

// MARK: - Encoding

extension MIDIFileEvent.TimeSignature: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .timeSignature
    
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
            
            numerator = try dataReader.readByte()
            denominator = try dataReader.readByte()
            midiClocksBetweenMetronomeClicks = try dataReader.readByte()
            numberOf32ndNotesInAQuarterNote = try dataReader.readByte()
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // FF 58 04 nn dd cc bb
        
        var data = D()
        
        data += MIDIFile.kEventHeaders[.timeSignature]!
        
        data += [numerator, denominator]
        
        // number of MIDI Clocks in a metronome click
        data += [midiClocksBetweenMetronomeClicks]
        
        // number of notated 32nd-notes in a MIDI quarter-note (24 MIDI Clocks)
        // The usual value for this parameter is 8, though some sequencers allow the user to specify
        // that what MIDI thinks of as a quarter note, should be notated as something else.
        data += [numberOf32ndNotesInAQuarterNote] // 8 32nd-notes
        
        return data
    }
    
    static let midi1SMFFixedRawBytesLength = 7

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
        let denom = pow(2 as Decimal, Int(denominator))

        return "timeSig: \(numerator)/\(denom)"
    }

    public var smfDebugDescription: String {
        "TimeSignature(" + smfDescription +
            ". clocks:\(midiClocksBetweenMetronomeClicks), 32ndsToAQuarter:\(numberOf32ndNotesInAQuarterNote))"
    }
}
