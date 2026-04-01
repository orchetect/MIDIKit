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
//   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileTrackEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Pitch Bend
    public typealias PitchBend = MIDIEvent.PitchBend
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Pitch Bend
    public static func pitchBend(
        lsb: UInt8,
        msb: UInt8,
        channel: UInt4 = 0
    ) -> Self {
        let value: MIDIEvent.PitchBend.Value = .midi1(UInt14(bytePair: .init(msb: msb, lsb: lsb)))
        return .pitchBend(
            .init(value: value, channel: channel)
        )
    }
    
    /// Channel Voice Message: Pitch Bend
    public static func pitchBend(
        value: MIDIEvent.PitchBend.Value,
        channel: UInt4 = 0
    ) -> Self {
        .pitchBend(
            .init(value: value, channel: channel)
        )
    }
}

extension MIDIFile.TrackChunk.Event {
    /// Channel Voice Message: Pitch Bend
    public static func pitchBend(
        delta: DeltaTime = .none,
        lsb: UInt8,
        msb: UInt8,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileTrackEvent = .pitchBend(
            lsb: lsb,
            msb: msb,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
    
    /// Channel Voice Message: Pitch Bend
    public static func pitchBend(
        delta: DeltaTime = .none,
        value: MIDIEvent.PitchBend.Value,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileTrackEvent = .pitchBend(
            value: value,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.PitchBend: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .pitchBend }
    
    public var wrapped: MIDIFileTrackEvent {
        .pitchBend(self)
    }
    
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileTrackEventDecodeResult<Self> {
        // Step 1: Check required byte count
        let requiredStreamByteCount: Int
        do throws(MIDIFileDecodeError) {
            requiredStreamByteCount = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 2: Parse out required bytes
        let readStatus, readChannel, readByte1, readByte2: UInt8
        do throws(MIDIFileDecodeError) {
            (readStatus, readChannel, readByte1, readByte2) =
            try stream.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8, UInt8) in
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
                    throw .malformed("Pitch Bend does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard readStatus == 0xE else {
                throw .malformed(
                    "Pitch Bend has invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
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
                    "Pitch Bend value(s) are out of bounds."
                )
            }
            
            let newEvent = Self(
                value: .midi1(value),
                channel: channel
            )
            
            return .event(
                payload: newEvent,
                byteLength: requiredStreamByteCount
            )
        } catch {
            return .recoverableError(
                payload: nil,
                byteLength: requiredStreamByteCount,
                error: error
            )
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // 3 bytes : En lsb msb
        
        D(midi1RawBytes())
    }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "bend:\(value) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "PitchBend(" + smfDescription + ")"
    }
}
