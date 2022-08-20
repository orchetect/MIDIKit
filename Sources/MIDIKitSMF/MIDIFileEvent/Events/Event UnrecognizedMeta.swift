//
//  Event UnrecognizedMeta.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

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

extension MIDIFileEvent.UnrecognizedMeta: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .unrecognizedMeta
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Not enough bytes."
            )
        }
        
        try rawBytes.withDataReader { dataReader in
            // meta event byte
            guard (try? dataReader.readByte()) == 0xFF else {
                throw MIDIFile.DecodeError.malformed(
                    "Event does not start with expected bytes."
                )
            }
        
            let readMetaType = try dataReader.readByte()
        
            guard let length = MIDIFile
                .decodeVariableLengthValue(from: try dataReader.nonAdvancingRead())
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
            
            metaType = readMetaType
            data = readData.data.bytes
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // FF <type> <length> <bytes>
        // type == UInt8 meta type (unrecognized)
        
        [0xFF, metaType] +
            // length of data
            MIDIFile.encodeVariableLengthValue(data.count) +
            // data
            data
    }
    
    public static func initFrom<D: DataProtocol>(
        midi1SMFRawBytesStream stream: D
    ) throws -> StreamDecodeResult {
        guard stream.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Byte length too length."
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
        "meta: \(metaType), \(data.count) bytes"
    }
    
    public var smfDebugDescription: String {
        let byteDump = data
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
        
        return "UnrecognizedMeta(type: \(metaType), \(data.count) bytes: [\(byteDump)]"
    }
}
