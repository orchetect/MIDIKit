//
//  Event TimeSignature.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - TimeSignature

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileTrackEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
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

extension MIDIFileTrackEvent.TimeSignature: Equatable { }

extension MIDIFileTrackEvent.TimeSignature: Hashable { }

extension MIDIFileTrackEvent.TimeSignature: Sendable { }

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// Time Signature event.
    /// For a format 1 MIDI file, Time Signature meta events should only occur within the first
    /// `MTrk` chunk.
    /// If there are no Time Signature events in a MIDI file, 4/4 is assumed.
    ///
    /// - Parameters:
    ///   - numerator: Numerator in time signature fraction: Literal numerator.
    ///   - denominator: Denominator in time signature fraction. Expressed as a power of 2. (ie: 2 = 2^2 = 4, 3 = 2^3 = 8, etc.)
    public static func timeSignature(
        numerator: UInt8,
        denominator: UInt8
    ) -> Self {
        .timeSignature(
            .init(
                numerator: numerator,
                denominator: denominator
            )
        )
    }
}

extension MIDIFile.TrackChunk.Event {
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
        let event: MIDIFileTrackEvent = .timeSignature(
            numerator: numerator,
            denominator: denominator
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileTrackEvent.TimeSignature {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x58, 0x04] }
}

// MARK: - Encoding

extension MIDIFileTrackEvent.TimeSignature: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .timeSignature }
    
    public var wrapped: MIDIFileTrackEvent {
        .timeSignature(self)
    }
    
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileTrackEventDecodeResult<Self> {
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
        let num, den, clocks, thirtySeconds: UInt8
        do throws(MIDIFileDecodeError) {
            (num, den, clocks, thirtySeconds) = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
                // 3-byte preamble
                guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                      headerBytes.elementsEqual(Self.prefixBytes)
                else {
                    throw .malformed("Time Signature does not start with expected bytes.")
                }
                
                do {
                    let numerator = try parser.readByte()
                    let denominator = try parser.readByte()
                    let midiClocksBetweenMetronomeClicks = try parser.readByte()
                    let numberOf32ndNotesInAQuarterNote = try parser.readByte()
                    
                    return (
                        numerator,
                        denominator,
                        midiClocksBetweenMetronomeClicks,
                        numberOf32ndNotesInAQuarterNote
                    )
                } catch {
                    throw .malformed("Time Signature does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        let newEvent = Self(
            numerator: num,
            denominator: den,
            midiClocksBetweenMetronomeClicks: clocks,
            numberOf32ndNotesInAQuarterNote: thirtySeconds
        )
        
        return .event(
            payload: newEvent,
            byteLength: requiredStreamByteCount
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 58 04 nn dd cc bb
        
        var data = D()
        
        data += Self.prefixBytes
        
        data += [numerator, denominator]
        
        // number of MIDI Clocks in a metronome click
        data += [midiClocksBetweenMetronomeClicks]
        
        // number of notated 32nd-notes in a MIDI quarter-note (24 MIDI Clocks)
        // The usual value for this parameter is 8, though some sequencers allow the user to specify
        // that what MIDI thinks of as a quarter note, should be notated as something else.
        data += [numberOf32ndNotesInAQuarterNote] // 8 32nd-notes
        
        return data
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
