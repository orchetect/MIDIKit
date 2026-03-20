//
//  Event SysEx.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

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
    ) throws(MIDIEvent.ParseError) -> Self {
        let event: SysEx7 = try .init(
            manufacturer: manufacturer,
            data: data
        )
        return .sysEx7(
            delta: delta,
            event: event
        )
    }
    
    /// System Exclusive: Manufacturer-specific (7-bit)
    @_disfavoredOverload
    public static func sysEx7(
        delta: DeltaTime = .none,
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt7]
    ) -> Self {
        let event: SysEx7 = .init(
            manufacturer: manufacturer,
            data: data
        )
        return .sysEx7(
            delta: delta,
            event: event
        )
    }
}

// MARK: - SysEx7 Encoding

extension MIDIEvent.SysEx7: MIDIFileEvent.Payload {
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        .sysEx7(delta: delta, event: self)
    }
    
    public static let smfEventType: MIDIFileEvent.EventType = .sysEx7
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        let parsedEvent = try MIDIEvent.sysEx7(midi1SMFRawBytes: rawBytes)
        
        switch parsedEvent {
        case let .sysEx7(sysEx):
            self = sysEx
        case .universalSysEx7:
            throw .malformed("Invalid SysEx type. Expected SysEx7 and found Universal SysEx7.")
        default:
            throw .malformed("Invalid data. Expected SysEx7 data and parsed \(parsedEvent) instead.")
        }
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
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
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0]
            + MIDIFile.encodeVariableLengthValue(msg.count + 1, as: D.self)
            + D(msg)
            + [0xF7]
    }
    
    public var smfDescription: String {
        "sysEx7: \((midi1SMFRawBytes() as Data).count) bytes"
    }

    public var smfDebugDescription: String {
        let bytes = midi1SMFRawBytes(as: [UInt8].self)
        
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
    ///
    /// - Throws: `MIDIEvent.ParseError` if any data bytes overflow 7 bits.
    public static func universalSysEx7(
        delta: DeltaTime = .none,
        universalType: MIDIEvent.UniversalSysExType,
        deviceID: UInt7,
        subID1: UInt7,
        subID2: UInt7,
        data: [UInt8]
    ) throws(MIDIEvent.ParseError) -> Self {
        let event: UniversalSysEx7 = try .init(
            universalType: universalType,
            deviceID: deviceID,
            subID1: subID1,
            subID2: subID2,
            data: data
        )
        return .universalSysEx7(
            delta: delta,
            event: event
        )
    }
    
    /// Universal System Exclusive (7-bit)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See
    /// the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of `0x7F` indicates "All Devices".
    @_disfavoredOverload
    public static func universalSysEx7(
        delta: DeltaTime = .none,
        universalType: MIDIEvent.UniversalSysExType,
        deviceID: UInt7,
        subID1: UInt7,
        subID2: UInt7,
        data: [UInt7]
    ) -> Self {
        let event: UniversalSysEx7 = .init(
            universalType: universalType,
            deviceID: deviceID,
            subID1: subID1,
            subID2: subID2,
            data: data
        )
        return .universalSysEx7(
            delta: delta,
            event: event
        )
    }
}

// MARK: - UniversalSysEx7 Encoding

extension MIDIEvent.UniversalSysEx7: MIDIFileEvent.Payload {
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        .universalSysEx7(delta: delta, event: self)
    }
    
    public static let smfEventType: MIDIFileEvent.EventType = .universalSysEx7
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        let parsedEvent = try MIDIEvent.sysEx7(midi1SMFRawBytes: rawBytes)
        
        switch parsedEvent {
        case let .universalSysEx7(universalSysEx):
            self = universalSysEx
        case .sysEx7:
            throw .malformed("Invalid SysEx type. Expected Universal SysEx7 and found SysEx7.")
        default:
            throw .malformed("Invalid data. Expected Universal SysEx7 data and parsed \(parsedEvent) instead.")
        }
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
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
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0] + MIDIFile.encodeVariableLengthValue(msg.count + 1, as: D.self) + msg + [0xF7]
    }
    
    public var smfDescription: String {
        "universalSysEx7: \((midi1SMFRawBytes() as Data).count) bytes"
    }
    
    public var smfDebugDescription: String {
        let bytes = midi1SMFRawBytes(as: [UInt8].self)
        
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
    ) throws(MIDIFile.DecodeError) -> Self {
        guard rawBytes.count >= 3 else {
            throw .malformed("Not enough bytes.")
        }
        
        return try rawBytes.withDataParser { parser throws(MIDIFile.DecodeError) in
            // 1-byte preamble
            guard (try? parser.readByte()) == 0xF0 else {
                throw .malformed(
                    "Event is not a SysEx event."
                )
            }
            
            let length = try parser.decodeVariableLengthValue()
            
            guard parser.remainingByteCount >= length else {
                throw .malformed(
                    "Fewer bytes are available (\(rawBytes.count)) than are expected (\(length))."
                )
            }
            
            let sysExBodySlice = try parser.toMIDIFileDecodeError(
                malformedReason: "SysEx data was empty when attempting to read termination byte.",
                try parser.read(bytes: length)
            )
            
            guard let lastByte = sysExBodySlice.last else {
                throw .malformed(
                    "SysEx data was empty when attempting to read termination byte."
                )
            }
            
            guard lastByte == 0xF7 else {
                throw .malformed(
                    "Expected SysEx termination byte 0xF7 but found \(lastByte.hexString(padTo: 2, prefix: true)) instead."
                )
            }
            
            let sysExFullSlice = [0xF0] + sysExBodySlice
            
            do throws(MIDIEvent.ParseError) {
                return try MIDIEvent.sysEx7(rawBytes: sysExFullSlice)
            } catch {
                throw .malformed(error.localizedDescription)
            }
        }
    }
}
