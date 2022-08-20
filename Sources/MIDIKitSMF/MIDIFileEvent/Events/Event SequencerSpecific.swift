//
//  Event SequencerSpecific.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - SequencerSpecific

extension MIDIFileEvent {
    public struct SequencerSpecific: Equatable, Hashable {
        /// Data bytes.
        /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
        public var data: [UInt8] = []
        
        // MARK: - Init
        
        public init(data: [UInt8]) {
            self.data = data
        }
    }
}

extension MIDIFileEvent.SequencerSpecific: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .sequencerSpecific
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
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
            
            data = readData.data.bytes
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
    
    public static func initFrom<D: DataProtocol>(
        midi1SMFRawBytesStream stream: D
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
