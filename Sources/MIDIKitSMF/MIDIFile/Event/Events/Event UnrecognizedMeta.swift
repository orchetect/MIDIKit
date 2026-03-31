//
//  Event UnrecognizedMeta.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - UnrecognizedMeta

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Unrecognized Meta Event
    ///
    /// > Note: This is not designed to be instanced, but is instead a placeholder for unrecognized
    /// > or malformed data while parsing the contents of a MIDI file. In then allows for manual
    /// > parsing or introspection of the unrecognized data.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > All meta-events begin with `0xFF`, then have an event type byte (which is always less than
    /// > 128), and then have the length of the data stored as a variable-length quantity, and then
    /// > the data itself. If there is no data, the length is `0`. As with chunks, future
    /// > meta-events may be designed which may not be known to existing programs, so programs must
    /// > properly ignore meta-events which they do not recognize, and indeed, should expect to see
    /// > them.
    /// >
    /// > Programs must never ignore the length of a meta-event which they do recognize, and they
    /// > shouldn't be surprised if it's bigger than they expected. If so, they must ignore
    /// > everything past what they know about. However, they must not add anything of their own to
    /// > the end of a meta-event.
    /// >
    /// > SysEx events and meta-events cancel any running status which was in effect. Running status
    /// > does not apply to and may not be used for these messages.
    public struct UnrecognizedMeta {
        // 0x00 is a known meta type, but just default to it here any way
        public var metaType: UInt8 = 0x00
        
        /// Data bytes.
        /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
        public var data: [UInt8] = []
        
        // MARK: - Init
        
        public init(
            metaType: UInt8,
            data: [UInt8]
        ) {
            self.metaType = metaType
            self.data = data
        }
    }
}

extension MIDIFileTrackEvent.UnrecognizedMeta: Equatable { }

extension MIDIFileTrackEvent.UnrecognizedMeta: Hashable { }

extension MIDIFileTrackEvent.UnrecognizedMeta: Sendable { }

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// Unrecognized Meta Event
    ///
    /// > Note: This is not designed to be instanced, but is instead a placeholder for unrecognized
    /// or malformed data while parsing the contents of a MIDI file. In then allows for manual
    /// parsing or introspection of the unrecognized data.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > All meta-events begin with `0xFF`, then have an event type byte (which is always less than
    /// > 128), and then have the length of the data stored as a variable-length quantity, and then
    /// > the data itself. If there is no data, the length is `0`. As with chunks, future
    /// > meta-events may be designed which may not be known to existing programs, so programs must
    /// > properly ignore meta-events which they do not recognize, and indeed, should expect to see
    /// > them.
    /// >
    /// > Programs must never ignore the length of a meta-event which they do recognize, and they
    /// > shouldn't be surprised if it's bigger than they expected. If so, they must ignore
    /// > everything past what they know about. However, they must not add anything of their own to
    /// > the end of a meta-event.
    /// >
    /// > SysEx events and meta-events cancel any running status which was in effect. Running status
    /// > does not apply to and may not be used for these messages.
    public static func unrecognizedMeta(
        metaType: UInt8,
        data: [UInt8]
    ) -> Self {
        .unrecognizedMeta(
            .init(
                metaType: metaType,
                data: data
            )
        )
    }
}

extension MIDIFile.TrackChunk.Event {
    /// Unrecognized Meta Event
    ///
    /// > Note: This is not designed to be instanced, but is instead a placeholder for unrecognized
    /// or malformed data while parsing the contents of a MIDI file. In then allows for manual
    /// parsing or introspection of the unrecognized data.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > All meta-events begin with `0xFF`, then have an event type byte (which is always less than
    /// > 128), and then have the length of the data stored as a variable-length quantity, and then
    /// > the data itself. If there is no data, the length is `0`. As with chunks, future
    /// > meta-events may be designed which may not be known to existing programs, so programs must
    /// > properly ignore meta-events which they do not recognize, and indeed, should expect to see
    /// > them.
    /// >
    /// > Programs must never ignore the length of a meta-event which they do recognize, and they
    /// > shouldn't be surprised if it's bigger than they expected. If so, they must ignore
    /// > everything past what they know about. However, they must not add anything of their own to
    /// > the end of a meta-event.
    /// >
    /// > SysEx events and meta-events cancel any running status which was in effect. Running status
    /// > does not apply to and may not be used for these messages.
    public static func unrecognizedMeta(
        delta: DeltaTime = .none,
        metaType: UInt8,
        data: [UInt8]
    ) -> Self {
        let event: MIDIFileTrackEvent = .unrecognizedMeta(
            metaType: metaType,
            data: data
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIFileTrackEvent.UnrecognizedMeta: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .unrecognizedMeta }
    
    public var wrapped: MIDIFileTrackEvent {
        .unrecognizedMeta(self)
    }
    
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileTrackEventDecodeResult<Self> {
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
        let metaType: UInt8
        let data: [UInt8]
        let byteLength: Int
        do throws(MIDIFileDecodeError) {
        (metaType, data, byteLength) = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
            // meta event byte
            guard (try? parser.readByte()) == 0xFF else {
                throw .malformed(
                    "Meta event does not start with expected bytes."
                )
            }
        
            let readMetaType = try parser.toMIDIFileDecodeError(
                malformedReason: "Meta type byte is missing.",
                try parser.readByte()
            )
            
            let length = try parser.decodeVariableLengthValue()
            
            let readData = try parser.toMIDIFileDecodeError(
                malformedReason: "Meta event does not have enough data bytes.",
                try parser.read(bytes: length)
            )
            
            let byteLength = parser.readOffset
            
            return (
                metaType: readMetaType,
                data: readData.toUInt8Bytes(),
                byteLength: byteLength
            )
        }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        let newEvent = Self(metaType: metaType, data: data)
        
        return .event(
            payload: newEvent,
            byteLength: byteLength
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF <type> <length> <bytes>
        // type == UInt8 meta type (unrecognized)
        
        [0xFF, metaType] +
            // length of data
            D.encodeVariableLengthValue(data.count) +
            // data
            data
    }
    
    public var smfDescription: String {
        "meta: \(metaType), \(data.count) bytes"
    }
    
    public var smfDebugDescription: String {
        let byteDump = data
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
        
        return "UnrecognizedMeta(type: \(metaType), \(data.count) bytes: [\(byteDump)]"
    }
}
