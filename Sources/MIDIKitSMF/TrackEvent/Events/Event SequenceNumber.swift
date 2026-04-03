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
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
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
        sequence: UInt16
    ) -> Self {
        .sequenceNumber(
            .init(sequence: sequence)
        )
    }
}

extension MIDI1File.TrackChunk.Event {
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
        let event: MIDIFileEvent = .sequenceNumber(
            sequence: sequence
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileEvent.SequenceNumber {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x00, 0x02] }
}

// MARK: - Encoding

extension MIDIFileEvent.SequenceNumber: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .sequenceNumber }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .sequenceNumber(self)
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
        let readSequenceNumber: UInt16
        do {
            readSequenceNumber = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
                // 3-byte preamble
                guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                      headerBytes.elementsEqual(Self.prefixBytes)
                else {
                    throw .malformed("Sequence Number does not start with expected bytes.")
                }
                
                guard let readSequenceNumberBytes = try? parser.read(bytes: 2)
                else {
                    throw .malformed(
                        "Sequence Number does not have enough bytes."
                    )
                }
                
                guard let readSequenceNumber = readSequenceNumberBytes
                    .toUInt16(from: .bigEndian)
                else {
                    throw .malformed(
                        "Sequence Number could not be read."
                    )
                }
                
                return readSequenceNumber
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard (0x0 ... 0x7FFF).contains(readSequenceNumber) else {
                throw .malformed(
                    "Sequence Number is out of bounds: \(readSequenceNumber)"
                )
            }
            
            let newEvent = Self(sequence: readSequenceNumber)
            
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
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 00 02 ssss
        // ssss is UIn16 big-endian sequence number
        
        D(Self.prefixBytes + sequence.toData(.bigEndian))
    }
    
    public var smfDescription: String {
        "seqNum:\(sequence)"
    }
    
    public var smfDebugDescription: String {
        "SequenceNumber(\(sequence))"
    }
}
