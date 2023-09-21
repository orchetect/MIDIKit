//
//  Event SysEx.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - SysEx7

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// System Exclusive: Manufacturer-specific (7-bit)
    public typealias SysEx7 = MIDIEvent.SysEx7
}

// MARK: - SysEx7 Static Constructors

extension MIDIFileEvent {
    /// System Exclusive: Manufacturer-specific (7-bit)
    ///
    /// - Throws: `MIDIEvent.ParseError` if any data bytes overflow 7 bits.
    public static func sysEx7(
        delta: DeltaTime = .none,
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt8]
    ) throws -> Self {
        try .sysEx7(
            delta: delta,
            event: .init(
                manufacturer: manufacturer,
                data: data
            )
        )
    }
    
    /// System Exclusive: Manufacturer-specific (7-bit)
    @_disfavoredOverload
    public static func sysEx7(
        delta: DeltaTime = .none,
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt7]
    ) -> Self {
        .sysEx7(
            delta: delta,
            event: .init(
                manufacturer: manufacturer,
                data: data
            )
        )
    }
}

// MARK: - SysEx7 Encoding

extension MIDIEvent.SysEx7: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .sysEx7
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        let parsedSysEx = try MIDIEvent.sysEx7(midi1SMFRawBytes: rawBytes)
        
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
        "sysEx7: \((midi1SMFRawBytes() as Data).count) bytes"
    }

    public var smfDebugDescription: String {
        let bytes: [UInt8] = midi1SMFRawBytes()
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")

        return "SysEx(\(bytes.count) bytes: [\(byteDump)]"
    }
}

// MARK: - UniversalSysEx7

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Universal System Exclusive (7-bit)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See
    /// the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of `0x7F` indicates "All Devices".
    public typealias UniversalSysEx7 = MIDIEvent.UniversalSysEx7
}

// MARK: - UniversalSysEx7 Static Constructors

extension MIDIFileEvent {
    /// Universal System Exclusive (7-bit)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See
    /// the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of `0x7F` indicates "All Devices".
    public static func universalSysEx7(
        delta: DeltaTime = .none,
        universalType: MIDIEvent.UniversalSysExType,
        deviceID: UInt7,
        subID1: UInt7,
        subID2: UInt7,
        data: [UInt8]
    ) throws -> Self {
        try .universalSysEx7(
            delta: delta,
            event: .init(
                universalType: universalType,
                deviceID: deviceID,
                subID1: subID1,
                subID2: subID2,
                data: data
            )
        )
    }
    
    /// Universal System Exclusive (7-bit)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See
    /// the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of `0x7F` indicates "All Devices".
    ///
    /// - Throws: `MIDIEvent.ParseError` if any data bytes overflow 7 bits.
    @_disfavoredOverload
    public static func universalSysEx7(
        delta: DeltaTime = .none,
        universalType: MIDIEvent.UniversalSysExType,
        deviceID: UInt7,
        subID1: UInt7,
        subID2: UInt7,
        data: [UInt7]
    ) -> Self {
        .universalSysEx7(
            delta: delta,
            event: .init(
                universalType: universalType,
                deviceID: deviceID,
                subID1: subID1,
                subID2: subID2,
                data: data
            )
        )
    }
}

// MARK: - UniversalSysEx7 Encoding

extension MIDIEvent.UniversalSysEx7: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .universalSysEx7
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        let rawBytesArray = [UInt8](rawBytes)
        let parsedSysEx = try MIDIEvent.sysEx7(midi1SMFRawBytes: rawBytesArray)
        
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
        "universalSysEx7: \((midi1SMFRawBytes() as Data).count) bytes"
    }
    
    public var smfDebugDescription: String {
        let bytes: [UInt8] = midi1SMFRawBytes()
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
        
        return "UniversalSysEx7(\(bytes.count) bytes: [\(byteDump)]"
    }
}

// MARK: - SysEx7/UniversalSysEx7 unified parser

extension MIDIEvent {
    static func sysEx7(
        midi1SMFRawBytes rawBytes: some DataProtocol,
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
