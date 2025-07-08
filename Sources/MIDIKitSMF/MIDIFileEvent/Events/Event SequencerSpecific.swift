//
//  Event SequencerSpecific.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - SequencerSpecific

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
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
        delta: DeltaTime = .none,
        data: [UInt8]
    ) -> Self {
        .sequencerSpecific(
            delta: delta,
            event: .init(data: data)
        )
    }
}

// MARK: - Encoding

extension MIDIFileEvent.SequencerSpecific: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .sequencerSpecific
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Too few bytes."
            )
        }
        
        try rawBytes.withDataReader { dataReader in
            // 2-byte preamble
            guard try dataReader.read(bytes: 2).elementsEqual(
                MIDIFile.kEventHeaders[Self.smfEventType]!
            ) else {
                throw MIDIFile.DecodeError.malformed(
                    "Event does not start with expected bytes."
                )
            }
            
            let readAheadCount = dataReader.remainingByteCount.clamped(to: 1 ... 4)
            guard let length = try MIDIFile
                .decodeVariableLengthValue(from: dataReader.nonAdvancingRead(bytes: readAheadCount))
            else {
                throw MIDIFile.DecodeError.malformed(
                    "Could not extract variable length."
                )
            }
            dataReader.advanceBy(length.byteLength)
            
            guard dataReader.remainingByteCount >= length.value else {
                throw MIDIFile.DecodeError.malformed(
                    "Fewer bytes are available (\(dataReader.remainingByteCount) than are expected (\(length.value))."
                )
            }
            
            let readData = try dataReader.read(bytes: length.value)
            
            data = readData.data.toUInt8Bytes
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // FF 7F length data
        
        MIDIFile.kEventHeaders[.sequencerSpecific]! +
            // length of data
            MIDIFile.encodeVariableLengthValue(data.count) +
            // data
            data
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws -> StreamDecodeResult {
        guard stream.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Byte length too short."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: stream)
        
        // TODO: this is brittle but it may work
        
        let length = (newInstance.midi1SMFRawBytes() as Data).count
        
        return (
            newEvent: newInstance,
            bufferLength: length
        )
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
