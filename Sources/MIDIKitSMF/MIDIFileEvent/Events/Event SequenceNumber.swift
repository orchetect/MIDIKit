//
//  Event SequenceNumber.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - SequenceNumber

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Sequence Number event.
    ///
    /// - For MIDI file type 0/1, this should only be on the first track. This is used to identify
    /// each track. If omitted, the sequences are numbered sequentially in the order the tracks
    /// appear.
    ///
    /// - For MIDI file type 2, each track can contain a sequence number event.
    public struct SequenceNumber {
        /// Sequence number (`0 ... 32767`)
        public var sequence: UInt16 = 0 {
            didSet {
                if oldValue != sequence { sequence_Validate() }
            }
        }
        
        private mutating func sequence_Validate() {
            sequence = sequence.clamped(to: 0x0 ... 0x7FFF)
        }
        
        // MARK: - Init
        
        public init(sequence: UInt16) {
            self.sequence = sequence
        }
    }
}

extension MIDIFileEvent.SequenceNumber: Equatable { }

extension MIDIFileEvent.SequenceNumber: Hashable { }

extension MIDIFileEvent.SequenceNumber: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Sequence Number event.
    ///
    /// - For MIDI file type 0/1, this should only be on the first track. This is used to identify
    /// each track. If omitted, the sequences are numbered sequentially in the order the tracks
    /// appear.
    ///
    /// - For MIDI file type 2, each track can contain a sequence number event.
    public static func sequenceNumber(
        delta: DeltaTime = .none,
        sequence: UInt16
    ) -> Self {
        .sequenceNumber(
            delta: delta,
            event: .init(sequence: sequence)
        )
    }
}

// MARK: - Static

extension MIDIFileEvent.SequenceNumber {
    /// The prefix bytes that define the start of the event.
    public static let prefixBytes: [UInt8] = [0xFF, 0x00, 0x02]
}

// MARK: - Encoding

extension MIDIFileEvent.SequenceNumber: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .sequenceNumber
    
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
        
        try rawBytes.withDataParser { parser throws(MIDIFile.DecodeError) in
            // 3-byte preamble
            guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                  headerBytes.elementsEqual(Self.prefixBytes)
            else {
                throw .malformed("Event does not start with expected bytes.")
            }
        
            guard let readSequenceNumber = (try? parser.read(bytes: 2))?
                .toUInt16(from: .bigEndian)
            else {
                throw .malformed(
                    "Could not read sequence number as integer."
                )
            }
        
            guard (0x0 ... 0x7FFF).contains(readSequenceNumber) else {
                throw .malformed(
                    "Sequence number is out of bounds: \(readSequenceNumber)"
                )
            }
        
            sequence = readSequenceNumber
        }
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
        // FF 00 02 ssss
        // ssss is UIn16 big-endian sequence number
        
        D(Self.prefixBytes + sequence.toData(.bigEndian))
    }
    
    static let midi1SMFFixedRawBytesLength = 5
    
    public var smfDescription: String {
        "seqNum:\(sequence)"
    }
    
    public var smfDebugDescription: String {
        "SequenceNumber(\(sequence))"
    }
}
