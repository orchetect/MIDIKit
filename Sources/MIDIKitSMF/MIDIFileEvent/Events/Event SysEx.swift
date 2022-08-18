//
//  Event SysEx.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - SysEx

extension MIDIEvent {
    internal static func sysEx<D: DataProtocol>(
        midi1SMFRawBytes rawBytes: D,
        group: UInt4 = 0
    ) throws -> Self {
        guard rawBytes.count >= 3 else {
            throw MIDIFile.DecodeError.malformed(
                "Not enough bytes."
            )
        }
        
        return try rawBytes.withDataReader { dataReader in
            // 1-byte preamble
            guard (try? dataReader.readByte()) == 0xF0 else {
                throw MIDIFile.DecodeError.malformed(
                    "Event is not a SysEx event."
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
                    "Fewer bytes are available (\(rawBytes.count)) than are expected (\(length.value))."
                )
            }
        
            let sysExBodySlice = try dataReader.read(bytes: length.value)
        
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
        
            let sysExFullSlice = [0xF0] + sysExBodySlice
        
            return try MIDIEvent.sysEx7(rawBytes: sysExFullSlice)
        }
    }
}

// MARK: - SysEx

extension MIDIFileEvent {
    public typealias SysEx = MIDIEvent.SysEx7
}

extension MIDIEvent.SysEx7: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .sysEx
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
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
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0]
            + MIDIFile.encodeVariableLengthValue(msg.count + 1)
            + D(msg)
            + [0xF7]
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
        "sysEx: \((midi1SMFRawBytes() as Data).count) bytes"
    }

    public var smfDebugDescription: String {
        let bytes: [UInt8] = midi1SMFRawBytes()
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")

        return "SysEx(\(bytes.count) bytes: [\(byteDump)]"
    }
}

// MARK: - UniversalSysEx

extension MIDIFileEvent {
    public typealias UniversalSysEx = MIDIEvent.UniversalSysEx7
}

extension MIDIEvent.UniversalSysEx7: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .universalSysEx
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
        let rawBytesArray = [UInt8](rawBytes)
        let parsedSysEx = try MIDIEvent.sysEx(midi1SMFRawBytes: rawBytesArray)
        
        switch parsedSysEx {
        case .sysEx7:
            throw MIDIEvent.ParseError.invalidType
        case let .universalSysEx7(universalSysEx):
            self = universalSysEx
        default:
            throw MIDIEvent.ParseError.invalidType
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0] + MIDIFile.encodeVariableLengthValue(msg.count + 1) + msg + [0xF7]
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
        "universalSysEx: \((midi1SMFRawBytes() as Data).count) bytes"
    }
    
    public var smfDebugDescription: String {
        let bytes: [UInt8] = midi1SMFRawBytes()
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
        
        return "UniversalSysEx(\(bytes.count) bytes: [\(byteDump)]"
    }
}
