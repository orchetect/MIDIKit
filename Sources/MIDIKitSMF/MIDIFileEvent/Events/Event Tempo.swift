//
//  Event Tempo.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore

// MARK: - Tempo

extension MIDIFileEvent {
    /// Tempo event.
    /// For a format 1 MIDI file, Tempo events should only occur within the first MTrk chunk.
    /// If there are no tempo events in a MIDI file, 120 bpm is assumed.
    public struct Tempo: Equatable, Hashable {
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
        /// Returns current `bpm` property as it will be read from the MIDI file after encoding.
        /// This is the effective tempo that DAWs will read when importing the MIDI file.
        public var bpmEncoded: Double {
            Self.microsecondsToBPM(ms: Self.bpmToMicroseconds(bpm: bpm))
        }
        
        /// (Computed property, not stored.)
        ///
        /// - Get: Calculates microseconds-per-quarter note based on `bpm` property.
        ///
        /// - Set: Sets `bpm` property to the calculated tempo from the passed microseconds-per-quarter note value.
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

extension MIDIFileEvent.Tempo: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .tempo
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 3-byte preamble
        guard rawBytes.starts(with: MIDIFile.kEventHeaders[.tempo]!) else {
            throw MIDIFile.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readUInt32 = (UInt32(rawBytes[3]) << 16)
            + (UInt32(rawBytes[4]) << 8)
            + UInt32(rawBytes[5])
        
        microseconds = readUInt32
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // FF 51 03 xx xx xx
        // xx xx xx = 3-byte (24-bit) microseconds per MIDI quarter-note
        
        var data: [Byte] = []
        
        data += MIDIFile.kEventHeaders[.tempo]!
        
        var tempoUInt32 = microseconds
        data += Array(NSData(bytes: &tempoUInt32, length: 3) as Data)
            .reversed()
        
        return data
    }
    
    static let midi1SMFFixedRawBytesLength = 6
    
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
        "\(bpm.rounded(decimalPlaces: 3))bpm"
    }
    
    public var smfDebugDescription: String {
        "Tempo(\(bpm.stringValueHighPrecision)bpm)"
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
