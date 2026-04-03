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
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
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
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt8]
    ) throws(MIDIEvent.ParseError) -> Self {
        let event: SysEx7 = try .init(
            manufacturer: manufacturer,
            data: data
        )
        return .sysEx7(event)
    }
    
    /// System Exclusive: Manufacturer-specific (7-bit)
    @_disfavoredOverload
    public static func sysEx7(
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt7]
    ) -> Self {
        let event: SysEx7 = .init(
            manufacturer: manufacturer,
            data: data
        )
        return .sysEx7(event)
    }
}

extension MIDI1File.TrackChunk.Event {
    /// System Exclusive: Manufacturer-specific (7-bit)
    ///
    /// - Throws: `MIDIEvent.ParseError` if any data bytes overflow 7 bits.
    public static func sysEx7(
        delta: DeltaTime = .none,
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt8]
    ) throws(MIDIEvent.ParseError) -> Self {
        let event: MIDIFileEvent = try .sysEx7(
            manufacturer: manufacturer,
            data: data
        )
        return Self(delta: delta, event: event)
    }
    
    /// System Exclusive: Manufacturer-specific (7-bit)
    @_disfavoredOverload
    public static func sysEx7(
        delta: DeltaTime = .none,
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt7]
    ) -> Self {
        let event: MIDIFileEvent = .sysEx7(
            manufacturer: manufacturer,
            data: data
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - SysEx7 Encoding

extension MIDIEvent.SysEx7: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .sysEx7 }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .sysEx7(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        do throws(MIDIFileDecodeError) {
            _ = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        do throws(MIDIFileDecodeError) {
            let (parsedEvent, byteLength) = try MIDIEvent.sysEx7(midi1FileRawBytes: stream)
            
            switch parsedEvent {
            case let .sysEx7(sysEx):
                return .event(payload: sysEx, byteLength: byteLength)
            case .universalSysEx7:
                throw .malformed("Invalid SysEx type. Expected SysEx7 and found Universal SysEx7.")
            default:
                throw .malformed("Invalid data. Expected SysEx7 data and parsed \(parsedEvent) instead.")
            }
        } catch {
            return .unrecoverableError(error: error)
        }
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0]
            + D(midi1FileVariableLengthValue: msg.count + 1)
            + D(msg)
            + [0xF7]
    }
    
    public var midiFileDescription: String {
        "sysEx7: \((midi1FileRawBytes() as Data).count) bytes"
    }

    public var midiFileDebugDescription: String {
        let bytes = midi1FileRawBytes(as: [UInt8].self)
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")

        return "SysEx(\(bytes.count) bytes: [\(byteDump)]"
    }
}

// MARK: - UniversalSysEx7

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
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
        return .universalSysEx7(event)
    }
    
    /// Universal System Exclusive (7-bit)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See
    /// the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of `0x7F` indicates "All Devices".
    @_disfavoredOverload
    public static func universalSysEx7(
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
        return .universalSysEx7(event)
    }
}

extension MIDI1File.TrackChunk.Event {
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
        let event: MIDIFileEvent = try .universalSysEx7(
            universalType: universalType,
            deviceID: deviceID,
            subID1: subID1,
            subID2: subID2,
            data: data
        )
        return Self(delta: delta, event: event)
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
        let event: MIDIFileEvent = .universalSysEx7(
            universalType: universalType,
            deviceID: deviceID,
            subID1: subID1,
            subID2: subID2,
            data: data
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - UniversalSysEx7 Encoding

extension MIDIEvent.UniversalSysEx7: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .universalSysEx7 }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .universalSysEx7(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        do throws(MIDIFileDecodeError) {
            _ = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        do throws(MIDIFileDecodeError) {
            let (parsedEvent, byteLength) = try MIDIEvent.sysEx7(midi1FileRawBytes: stream)
            
            switch parsedEvent {
            case let .universalSysEx7(universalSysEx):
                return .event(payload: universalSysEx, byteLength: byteLength)
            case .sysEx7:
                throw .malformed("Invalid SysEx type. Expected Universal SysEx7 and found SysEx7.")
            default:
                throw .malformed("Invalid data. Expected Universal SysEx7 data and parsed \(parsedEvent) instead.")
            }
        } catch {
            return .unrecoverableError(error: error)
        }
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message:
        //   F0 7E 00 09 01 F7
        // would be encoded as:
        //   F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0]
            + D(midi1FileVariableLengthValue: msg.count + 1)
            + msg
            + [0xF7]
    }
    
    public var midiFileDescription: String {
        "universalSysEx7: \((midi1FileRawBytes() as Data).count) bytes"
    }
    
    public var midiFileDebugDescription: String {
        let bytes = midi1FileRawBytes(as: [UInt8].self)
        
        let byteDump = bytes
            .hexString(padEachTo: 2, prefixes: true, separator: ", ")
        
        return "UniversalSysEx7(\(bytes.count) bytes: [\(byteDump)]"
    }
}

// MARK: - SysEx7/UniversalSysEx7 unified parser

extension MIDIEvent {
    static func sysEx7(
        midi1FileRawBytes rawBytes: some DataProtocol,
        group: UInt4 = 0
    ) throws(MIDIFileDecodeError) -> (payload: Self, byteLength: Int) {
        guard rawBytes.count >= 3 else {
            throw .malformed("SysEx does not have enough bytes.")
        }
        
        return try rawBytes.withDataParser { parser throws(MIDIFileDecodeError) in
            // 1-byte preamble
            guard (try? parser.readByte()) == 0xF0 else {
                throw .malformed(
                    "Event is not a SysEx event."
                )
            }
            
            let length = try parser.midi1FileVariableLengthValue()
            
            let sysExBodySlice = try parser.toMIDIFileDecodeError(
                malformedReason: "SysEx data does not have enough bytes.",
                try parser.read(bytes: length)
            )
            
            guard let lastByte = sysExBodySlice.last else {
                throw .malformed(
                    "SysEx data did not have enough bytes when attempting to read termination byte."
                )
            }
            
            guard lastByte == 0xF7 else {
                throw .malformed(
                    "Expected SysEx termination byte 0xF7 but found \(lastByte.hexString(padTo: 2, prefix: true)) instead."
                )
            }
            
            let sysExFullSlice = [0xF0] + sysExBodySlice
            
            let byteLength = parser.readOffset
            
            do throws(MIDIEvent.ParseError) {
                let payload = try MIDIEvent.sysEx7(rawBytes: sysExFullSlice)
                return (payload: payload, byteLength: byteLength)
            } catch {
                throw .malformed(error.localizedDescription)
            }
        }
    }
}
