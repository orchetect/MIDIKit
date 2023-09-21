//
//  Event PitchBend.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

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
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        self = try rawBytes.withDataReader { dataReader in
            let byte0 = try dataReader.readByte()
            let readStatus = (byte0 & 0xF0) >> 4
            let readChannel = byte0 & 0x0F
        
            guard readStatus == 0xE else {
                throw MIDIFile.DecodeError.malformed(
                    "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
            
            let byte1 = try dataReader.readByte()
            guard let lsb = byte1.toUInt7Exactly else {
                throw MIDIFile.DecodeError.malformed(
                    "Pitch Bend LSB is out of bounds: \(byte1.hexString(padTo: 2, prefix: true))"
                )
            }
            
            let byte2 = try dataReader.readByte()
            guard let msb = byte2.toUInt7Exactly else {
                throw MIDIFile.DecodeError.malformed(
                    "Pitch Bend MSB is out of bounds: \(byte2.hexString(padTo: 2, prefix: true))"
                )
            }
        
            let value = UInt7Pair(msb: msb, lsb: lsb).uInt14Value
        
            guard let channel = readChannel.toUInt4Exactly else {
                throw MIDIFile.DecodeError.malformed(
                    "Value(s) out of bounds."
                )
            }
        
            let newEvent = MIDIEvent.pitchBend(
                value: .midi1(value),
                channel: channel
            )
            
            guard case let .pitchBend(unwrapped) = newEvent else {
                throw MIDIFile.DecodeError.malformed(
                    "Could not unwrap enum case."
                )
            }
        
            return unwrapped
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // 3 bytes : En lsb msb
        
        D(midi1RawBytes())
    }
    
    static let midi1SMFFixedRawBytesLength = 3
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws -> StreamDecodeResult {
        let requiredData = stream.prefix(midi1SMFFixedRawBytesLength)
        
        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Unexpected byte length."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: requiredData)
        
        return (
            newEvent: newInstance,
            bufferLength: midi1SMFFixedRawBytesLength
        )
    }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "bend:\(value) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "PitchBend(" + smfDescription + ")"
    }
}
