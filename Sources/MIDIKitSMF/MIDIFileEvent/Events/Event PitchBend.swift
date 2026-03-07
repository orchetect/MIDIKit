//
//  Event PitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - PitchBend

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Channel Voice Message: Pitch Bend
    public typealias PitchBend = MIDIEvent.PitchBend
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Channel Voice Message: Pitch Bend
    public static func pitchBend(
        delta: DeltaTime = .none,
        lsb: UInt8,
        msb: UInt8,
        channel: UInt4 = 0
    ) -> Self {
        let value = MIDIEvent.PitchBend.Value.midi1(.init(bytePair: .init(msb: msb, lsb: lsb)))
        return .pitchBend(
            delta: delta,
            event: .init(value: value, channel: channel)
        )
    }
    
    /// Channel Voice Message: Pitch Bend
    public static func pitchBend(
        delta: DeltaTime = .none,
        value: MIDIEvent.PitchBend.Value,
        channel: UInt4 = 0
    ) -> Self {
        .pitchBend(
            delta: delta,
            event: .init(value: value, channel: channel)
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.PitchBend: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .pitchBend
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) {
        let rawBytesCountWithRunningStatus = rawBytes.count + (runningStatus != nil ? 1 : 0)
        guard rawBytesCountWithRunningStatus == Self.midi1SMFFixedRawBytesLength else {
            throw .malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let (
            readStatus, readChannel, readByte1, readByte2
        ) = try rawBytes.withDataParser { parser throws(MIDIFile.DecodeError) -> (UInt8, UInt8, UInt8, UInt8) in
            do {
                let byte0 = try runningStatus ?? parser.readByte()
                let byte1 = try parser.readByte()
                let byte2 = try parser.readByte()
                
                return (
                    readStatus: (byte0 & 0xF0) >> 4,
                    readChannel: byte0 & 0x0F,
                    readByte1: byte1,
                    readByte2: byte2
                )
            } catch {
                throw .malformed("Not enough bytes.")
            }
        }
        
        guard readStatus == 0xE else {
            throw .malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }
        
        guard let lsb = readByte1.toUInt7Exactly else {
            throw .malformed(
                "Pitch Bend LSB is out of bounds: \(readByte1.hexString(padTo: 2, prefix: true))"
            )
        }
        
        guard let msb = readByte2.toUInt7Exactly else {
            throw .malformed(
                "Pitch Bend MSB is out of bounds: \(readByte2.hexString(padTo: 2, prefix: true))"
            )
        }
        
        let value = UInt7Pair(msb: msb, lsb: lsb).uInt14Value
        
        guard let channel = readChannel.toUInt4Exactly else {
            throw .malformed(
                "Value(s) out of bounds."
            )
        }
        
        let newEvent: MIDIEvent = .pitchBend(
            value: .midi1(value),
            channel: channel
        )
        
        guard case let .pitchBend(unwrapped) = newEvent else {
            throw .malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
        let requiredByteCount = midi1SMFFixedRawBytesLength
        let requiredStreamByteCount = requiredByteCount - (runningStatus != nil ? 1 : 0)
        let rawBytes = stream.prefix(requiredStreamByteCount)
        
        let newInstance = try Self(midi1SMFRawBytes: rawBytes, runningStatus: runningStatus)
        
        return (
            newEvent: newInstance,
            bufferLength: rawBytes.count
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // 3 bytes : En lsb msb
        
        D(midi1RawBytes())
    }
    
    static let midi1SMFFixedRawBytesLength = 3
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "bend:\(value) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "PitchBend(" + smfDescription + ")"
    }
}
