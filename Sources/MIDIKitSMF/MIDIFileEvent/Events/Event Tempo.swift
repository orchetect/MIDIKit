//
//  Event Tempo.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Tempo

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Tempo event.
    /// For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.
    /// If there are no tempo events in a MIDI file, 120 bpm is assumed.
    public struct Tempo {
        /// Tempo.
        /// Defaults to 120 bpm. Minimum possible is 3.58 bpm and maximum is 60,000,000 bpm.
        public var bpm: Double = 120.0 {
            didSet {
                if oldValue != bpm { bpm_Validate() }
            }
        }
        
        private mutating func bpm_Validate() {
            bpm = bpm.clamped(to: 3.58 ... 60_000_000.0)
        }
        
        /// (Computed property)
        /// Returns current ``bpm`` property as it will be read from the MIDI file after encoding.
        /// This is the effective tempo that DAWs will read when importing the MIDI file.
        public var bpmEncoded: Double {
            Self.microsecondsToBPM(ms: Self.bpmToMicroseconds(bpm: bpm))
        }
        
        /// (Computed property, not stored.)
        ///
        /// - Get: Calculates microseconds-per-quarter note based on `bpm` property.
        ///
        /// - Set: Sets ``bpm`` property to the calculated tempo from the passed
        /// microseconds-per-quarter note value.
        public var microseconds: UInt32 {
            get {
                Self.bpmToMicroseconds(bpm: bpm)
            }
            set {
                bpm = Self.microsecondsToBPM(ms: newValue)
            }
        }
        
        public init(bpm: Double) {
            self.bpm = bpm
        }
    }
}

extension MIDIFileEvent.Tempo: Equatable { }

extension MIDIFileEvent.Tempo: Hashable { }

extension MIDIFileEvent.Tempo: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Tempo event.
    /// For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.
    /// If there are no tempo events in a MIDI file, 120 bpm is assumed.
    public static func tempo(
        delta: DeltaTime = .none,
        bpm: Double
    ) -> Self {
        .tempo(
            delta: delta,
            event: .init(bpm: bpm)
        )
    }
}

// MARK: - Encoding

extension MIDIFileEvent.Tempo: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .tempo
    
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
            
            let byte3 = try UInt32(dataReader.readByte())
            let byte4 = try UInt32(dataReader.readByte())
            let byte5 = try UInt32(dataReader.readByte())
            
            let readUInt32 = (byte3 << 16)
                + (byte4 << 8)
                + byte5
        
            microseconds = readUInt32
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // FF 51 03 xx xx xx
        // xx xx xx = 3-byte (24-bit) microseconds per MIDI quarter-note
        
        var data = D()
        
        data += MIDIFile.kEventHeaders[.tempo]!
        
        var tempoUInt32 = microseconds
        data += Array(NSData(bytes: &tempoUInt32, length: 3) as Data)
            .reversed()
        
        return data
    }
    
    static let midi1SMFFixedRawBytesLength = 6
    
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
        "\(bpm.rounded(decimalPlaces: 3))bpm"
    }
    
    public var smfDebugDescription: String {
        "Tempo(\(bpm)bpm)"
    }
}

// MARK: - Utility methods

extension MIDIFileEvent.Tempo {
    private static func bpmToMicroseconds(bpm fromTempo: Double) -> UInt32 {
        let tempoCalc: Double = (60 / fromTempo) * 1_000_000
        return UInt32(tempoCalc)
    }

    private static func microsecondsToBPM(ms fromMicroseconds: UInt32) -> Double {
        (60 * 1_000_000) / Double(fromMicroseconds)
    }
}
