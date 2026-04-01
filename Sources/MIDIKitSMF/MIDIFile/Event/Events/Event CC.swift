//
//  Event CC.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - CC

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileTrackEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Control Change (CC)
    public typealias CC = MIDIEvent.CC
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Control Change (CC)
    public static func cc(
        controller: MIDIEvent.CC.Controller,
        value: MIDIEvent.CC.Value,
        channel: UInt4 = 0
    ) -> Self {
        .cc(.init(
            controller: controller,
            value: value,
            channel: channel
        ))
    }
    
    /// Channel Voice Message: Control Change (CC)
    public static func cc(
        controller: UInt7,
        value: MIDIEvent.CC.Value,
        channel: UInt4 = 0
    ) -> Self {
        .cc(.init(
            controller: controller,
            value: value,
            channel: channel
        ))
    }
}

extension MIDIFile.TrackChunk.Event {
    /// Channel Voice Message: Control Change (CC)
    public static func cc(
        delta: DeltaTime = .none,
        controller: MIDIEvent.CC.Controller,
        value: MIDIEvent.CC.Value,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileTrackEvent = .cc(
            controller: controller,
            value: value,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
    
    /// Channel Voice Message: Control Change (CC)
    public static func cc(
        delta: DeltaTime = .none,
        controller: UInt7,
        value: MIDIEvent.CC.Value,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileTrackEvent = .cc(
            controller: controller,
            value: value,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.CC: MIDIFileTrackEventPayload {
    public static let smfEventType: MIDIFileTrackEventType = .cc
    
    public var asMIDIFileTrackEvent: MIDIFileTrackEvent {
        .cc(self)
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
        let readStatus, readChannel, readCCNum, readValue: UInt8
        do throws(MIDIFileDecodeError) {
            (readStatus, readChannel, readCCNum, readValue) =
            try stream.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8, UInt8) in
                do {
                    let byte0 = try runningStatus ?? parser.readByte()
                    let noteNum = try parser.readByte()
                    let value = try parser.readByte()
                    return (
                        readStatus: (byte0 & 0xF0) >> 4,
                        readChannel: byte0 & 0x0F,
                        readNoteNum: noteNum,
                        readValue: value
                    )
                } catch {
                    throw .malformed("CC does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard readStatus == 0xB else {
                throw .malformed(
                    "CC event has invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
            
            guard (0 ... 127).contains(readCCNum) else {
                throw .malformed(
                    "CC controller number is out of bounds: \(readCCNum)"
                )
            }
            
            guard (0 ... 127).contains(readValue) else {
                throw .malformed(
                    "CC value is out of bounds: \(readValue)"
                )
            }
            
            guard let channel = readChannel.toUInt4Exactly,
                  let ccNum = readCCNum.toUInt7Exactly,
                  let value = readValue.toUInt7Exactly
            else {
                throw .malformed(
                    "CC value(s) out of bounds."
                )
            }
            
            let newEvent = Self(
                controller: ccNum,
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
        // Bn controller value
        
        D(midi1RawBytes())
    }

    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)

        return "cc#\(controller.number) val:\(value) chan:\(chanString)"
    }

    public var smfDebugDescription: String {
        "CC(" + smfDescription + ")"
    }
}
