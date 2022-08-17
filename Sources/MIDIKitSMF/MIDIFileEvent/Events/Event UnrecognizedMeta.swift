//
//  Event UnrecognizedMeta.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore

// MARK: - UnrecognizedMeta

extension MIDIFileEvent {
    /// Unrecognized Meta Event
    ///
    /// - remark: Standard MIDI File Spec 1.0:
    ///
    /// "All meta-events begin with FF, then have an event type byte (which is always less than 128), and then have the length of the data stored as a variable-length quantity, and then the data itself. If there is no data, the length is 0. As with chunks, future meta-events may be designed which may not be known to existing programs, so programs must properly ignore meta-events which they do not recognize, and indeed, should expect to see them. Programs must never ignore the length of a meta-event which they do recognize, and they shouldn't be surprised if it's bigger than they expected. If so, they must ignore everything past what they know about. However, they must not add anything of their own to the end of a meta-event.
    ///
    /// SysEx events and meta-events cancel any running status which was in effect. Running status does not apply to and may not be used for these messages."
    public struct UnrecognizedMeta: Equatable, Hashable {
        public var metaType: UInt8 =
            0x00 // 0x00 is a known meta type, but just default to it here any way
        
        /// Data bytes.
        /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
        public var data: [Byte] = []
        
        // MARK: - Init
        
        public init(
            metaType: UInt8,
            data: [Byte]
        ) {
            self.metaType = metaType
            self.data = data
        }
    }
}

extension MIDIFileEvent.UnrecognizedMeta: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .unrecognizedMeta
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Not enough bytes."
            )
        }
        
        // meta event byte
        guard rawBytes.starts(with: [0xFF]) else {
            throw MIDIFile.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readMetaType = rawBytes[1]
        
        guard let length = MIDIFile.decodeVariableLengthValue(from: Array(rawBytes[2...])) else {
            throw MIDIFile.DecodeError.malformed(
                "Could not extract variable length."
            )
        }
        
        let expectedFullLength = 2 + length.byteLength + length.value
        
        guard rawBytes.count >= expectedFullLength else {
            throw MIDIFile.DecodeError.malformed(
                "Fewer bytes are available (\(rawBytes.count)) than are expected (\(expectedFullLength))."
            )
        }
        
        let beginIndex = rawBytes.startIndex.advanced(by: 2 + length.byteLength)
        let stopIndex = beginIndex.advanced(by: length.value)
        let readData = Array(rawBytes[beginIndex ..< stopIndex])
        
        metaType = readMetaType
        data = readData
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // FF <type> <length> <bytes>
        // type == UInt8 meta type (unrecognized)
        
        [0xFF, metaType] +
            // length of data
            MIDIFile.encodeVariableLengthValue(data.count) +
            // data
            data
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream rawBuffer: Data
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        guard rawBuffer.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Byte length too length."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: rawBuffer.bytes)
        
        // TODO: this is brittle but it may work
        
        let length = newInstance.midi1SMFRawBytes.count
        
        return (
            newEvent: newInstance,
            bufferLength: length
        )
    }
    
    public var smfDescription: String {
        "meta: \(metaType), \(data.count) bytes"
    }
    
    public var smfDebugDescription: String {
        let byteDump = data
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
            .wrapped(with: .brackets)
        
        return "UnrecognizedMeta(type: \(metaType), \(data.count) bytes: \(byteDump)"
    }
}
