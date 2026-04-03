//
//  Event Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - Channel Pressure

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public typealias Pressure = MIDIEvent.Pressure
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public static func pressure(
        amount: MIDIEvent.Pressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .pressure(
            .init(
                amount: amount,
                channel: channel
            )
        )
    }
}

extension MIDI1File.TrackChunk.Event {
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public static func pressure(
        delta: DeltaTime = .none,
        amount: MIDIEvent.Pressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileEvent = .pressure(
            amount: amount,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.Pressure: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .pressure }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .pressure(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
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
        let readStatus, readChannel, readValue: UInt8
        do {
            (readStatus, readChannel, readValue) =
            try stream.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8) in
                do {
                    let byte0 = try runningStatus ?? parser.readByte()
                    let readValue = try parser.readByte()
                    
                    return (
                        readStatus: (byte0 & 0xF0) >> 4,
                        readChannel: byte0 & 0x0F,
                        readValue: readValue
                    )
                } catch {
                    throw .malformed("Channel Pressure does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard readStatus == 0xD else {
                throw .malformed(
                    "Channel Pressure has invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
            
            guard (0 ... 127).contains(readValue) else {
                throw .malformed(
                    "Channel Pressure value is out of bounds: \(readValue)"
                )
            }
            
            guard let channel = readChannel.toUInt4Exactly,
                  let pressure = readValue.toUInt7Exactly
            else {
                throw .malformed(
                    "Channel Pressure value(s) are out of bounds."
                )
            }
            
            let newEvent = Self(
                amount: .midi1(pressure),
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
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // Dn value
        D(midi1RawBytes())
    }
    
    public var midiFileDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)

        return "pressure:\(amount) chan:\(chanString)"
    }

    public var midiFileDebugDescription: String {
        "ChanPressure(" + midiFileDescription + ")"
    }
}
