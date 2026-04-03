//
//  Event SequencerSpecific.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - SequencerSpecific

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Sequencer-specific data.
    /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
    public struct SequencerSpecific {
        /// Data bytes.
        /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
        public var data: [UInt8] = []
        
        // MARK: - Init
        
        public init(data: [UInt8]) {
            self.data = data
        }
    }
}

extension MIDIFileEvent.SequencerSpecific: Equatable { }

extension MIDIFileEvent.SequencerSpecific: Hashable { }

extension MIDIFileEvent.SequencerSpecific: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Sequencer-specific data.
    /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
    public static func sequencerSpecific(
        data: [UInt8]
    ) -> Self {
        .sequencerSpecific(
            .init(data: data)
        )
    }
}

extension MIDI1File.TrackChunk.Event {
    /// Sequencer-specific data.
    /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
    public static func sequencerSpecific(
        delta: DeltaTime = .none,
        data: [UInt8]
    ) -> Self {
        let event: MIDIFileEvent = .sequencerSpecific(
            data: data
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileEvent.SequencerSpecific {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x7F] }
}

// MARK: - Encoding

extension MIDIFileEvent.SequencerSpecific: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .sequencerSpecific }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .sequencerSpecific(self)
    }
    
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        // Step 1: Check required byte count
        do throws(MIDIFileDecodeError) {
            _ = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 2: Parse out required bytes
        let data: [UInt8]
        let byteLength: Int
        do throws(MIDIFileDecodeError) {
            (data, byteLength) = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
                // 2-byte preamble
                guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                      headerBytes.elementsEqual(Self.prefixBytes)
                else {
                    throw .malformed("Event does not start with expected bytes.")
                }
                
                let length = try parser.decodeSMF1VariableLengthValue()
                
                guard parser.remainingByteCount >= length else {
                    throw .malformed(
                        "Fewer bytes are available (\(parser.remainingByteCount) than are expected (\(length))."
                    )
                }
                
                let readData = try parser.toMIDIFileDecodeError(
                    malformedReason: "Not enough bytes in data block.",
                    try parser.read(bytes: length)
                )
                
                let byteLength = parser.readOffset
                
                return (
                    data: readData.toUInt8Bytes(),
                    byteLength: byteLength
                )
            }
            
            let newEvent = Self(data: data)
            
            return .event(
                payload: newEvent,
                byteLength: byteLength
            )
        } catch {
            return .unrecoverableError(error: error)
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 7F length data
        
        D(Self.prefixBytes)
            // length of data
            + D(midi1SMFVariableLengthValue: data.count)
            // data
            + D(data)
    }
    
    public var smfDescription: String {
        "sequencerSpecific: \(data.count) bytes"
    }
    
    public var smfDebugDescription: String {
        let byteDump = data
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
        
        return "SequencerSpecific(\(data.count) bytes: [\(byteDump)]"
    }
}
