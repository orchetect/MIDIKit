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
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
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

extension MIDIFileTrackEvent.SequencerSpecific: Equatable { }

extension MIDIFileTrackEvent.SequencerSpecific: Hashable { }

extension MIDIFileTrackEvent.SequencerSpecific: Sendable { }

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
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

extension MIDIFile.TrackChunk.Event {
    /// Sequencer-specific data.
    /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
    public static func sequencerSpecific(
        delta: MIDIFile.TrackChunk.DeltaTime = .none,
        data: [UInt8]
    ) -> Self {
        let event: MIDIFileTrackEvent = .sequencerSpecific(
            data: data
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileTrackEvent.SequencerSpecific {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x7F] }
}

// MARK: - Encoding

extension MIDIFileTrackEvent.SequencerSpecific: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .sequencerSpecific }
    
    public var wrapped: MIDIFileTrackEvent {
        .sequencerSpecific(self)
    }
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        guard rawBytes.count >= 3 else {
            throw .malformed(
                "Too few bytes."
            )
        }
        
        try rawBytes.withDataParser { parser throws(MIDIFileDecodeError) in
            // 2-byte preamble
            guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                  headerBytes.elementsEqual(Self.prefixBytes)
            else {
                throw .malformed("Event does not start with expected bytes.")
            }
            
            let length = try parser.decodeVariableLengthValue()
            
            guard parser.remainingByteCount >= length else {
                throw .malformed(
                    "Fewer bytes are available (\(parser.remainingByteCount) than are expected (\(length))."
                )
            }
            
            let readData = try parser.toMIDIFileDecodeError(
                malformedReason: "Not enough bytes in data block.",
                try parser.read(bytes: length)
            )
            
            data = readData.toUInt8Bytes()
        }
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) -> StreamDecodeResult {
        guard stream.count >= 3 else {
            throw .malformed("Byte length too short.")
        }
        
        let newInstance = try Self(midi1SMFRawBytes: stream, runningStatus: runningStatus)
        
        // TODO: this is brittle but it may work
        
        let length = (newInstance.midi1SMFRawBytes() as Data).count
        
        return (
            newEvent: newInstance,
            bufferLength: length
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 7F length data
        
        D(Self.prefixBytes)
            // length of data
            + D.encodeVariableLengthValue(data.count)
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
