//
//  Event SequencerSpecific.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore

// MARK: - SequencerSpecific

extension MIDIFileEvent {
    public struct SequencerSpecific: Equatable, Hashable {
        /// Data bytes.
        /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
        public var data: [Byte] = []
        
        // MARK: - Init
        
        public init(data: [Byte]) {
            self.data = data
        }
    }
}

extension MIDIFileEvent.SequencerSpecific: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .sequencerSpecific
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Too few bytes."
            )
        }
        
        // 2-byte preamble
        guard rawBytes.starts(with: MIDIFile.kEventHeaders[.sequencerSpecific]!) else {
            throw MIDIFile.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
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
        
        data = readData
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // FF 7F length data
        
        MIDIFile.kEventHeaders[.sequencerSpecific]! +
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
                "Byte length too short."
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
        "sequencerSpecific: \(data.count) bytes"
    }
    
    public var smfDebugDescription: String {
        let byteDump = data
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
            .wrapped(with: .brackets)
        
        return "SequencerSpecific(\(data.count) bytes: \(byteDump)"
    }
}
