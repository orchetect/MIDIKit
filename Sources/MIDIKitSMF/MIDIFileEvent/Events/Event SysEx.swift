//
//  Event SysEx.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore

// MARK: - SysEx

extension MIDIEvent {
    internal static func sysEx(
        midi1SMFRawBytes rawBytes: [Byte],
        group: UInt4 = 0
    ) throws -> Self {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Not enough bytes."
            )
        }
        
        // 1-byte preamble
        guard rawBytes.starts(with: [0xF0]) else {
            throw MIDIFile.DecodeError.malformed(
                "Event is not a SysEx event."
            )
        }
        
        guard let length = MIDIFile.decodeVariableLengthValue(from: Array(rawBytes[1...])) else {
            throw MIDIFile.DecodeError.malformed(
                "Could not extract variable length."
            )
        }
        
        let expectedFullLength = 1 + length.byteLength + length.value
        
        guard rawBytes.count >= expectedFullLength else {
            throw MIDIFile.DecodeError.malformed(
                "Fewer bytes are available (\(rawBytes.count)) than are expected (\(expectedFullLength))."
            )
        }
        
        let sysExBodySlice = Array(rawBytes[(1 + length.byteLength) ..< expectedFullLength])
        
        guard let lastByte = sysExBodySlice.last else {
            throw MIDIFile.DecodeError.malformed(
                "SysEx data was empty when attempting to read termination byte."
            )
        }
        
        guard lastByte == 0xF7 else {
            throw MIDIFile.DecodeError.malformed(
                "Expected SysEx termination byte 0xF7 but found \(lastByte.hexString(padTo: 2, prefix: true)) instead."
            )
        }
        
        let sysExFullSlice = [0xF0] + Array(rawBytes[1 + length.byteLength ..< expectedFullLength])
        
        return try MIDIEvent.sysEx7(rawBytes: sysExFullSlice)
    }
}

// MARK: - SysEx

extension MIDIFileEvent {
    public typealias SysEx = MIDIEvent.SysEx7
}

extension MIDIEvent.SysEx7: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .sysEx
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        let parsedSysEx = try MIDIEvent.sysEx(midi1SMFRawBytes: rawBytes)
        
        switch parsedSysEx {
        case let .sysEx7(sysEx):
            self = sysEx
        case .universalSysEx7:
            throw MIDIEvent.ParseError.invalidType
        default:
            throw MIDIEvent.ParseError.invalidType
        }
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0] + MIDIFile.encodeVariableLengthValue(msg.count + 1) + msg + [0xF7]
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
        "sysEx: \(midi1SMFRawBytes.count) bytes"
    }

    public var smfDebugDescription: String {
        let bytes = midi1SMFRawBytes
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
            .wrapped(with: .brackets)

        return "SysEx(\(bytes.count) bytes: \(byteDump)"
    }
}

// MARK: - UniversalSysEx

extension MIDIFileEvent {
    public typealias UniversalSysEx = MIDIEvent.UniversalSysEx7
}

extension MIDIEvent.UniversalSysEx7: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .universalSysEx
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        let parsedSysEx = try MIDIEvent.sysEx(midi1SMFRawBytes: rawBytes)
        
        switch parsedSysEx {
        case .sysEx7:
            throw MIDIEvent.ParseError.invalidType
        case let .universalSysEx7(universalSysEx):
            self = universalSysEx
        default:
            throw MIDIEvent.ParseError.invalidType
        }
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0] + MIDIFile.encodeVariableLengthValue(msg.count + 1) + msg + [0xF7]
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
        "universalSysEx: \(midi1SMFRawBytes.count) bytes"
    }
    
    public var smfDebugDescription: String {
        let bytes = midi1SMFRawBytes
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
            .wrapped(with: .brackets)
        
        return "UniversalSysEx(\(bytes.count) bytes: \(byteDump)"
    }
}
