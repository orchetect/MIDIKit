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
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public typealias Pressure = MIDIEvent.Pressure
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
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

extension MIDIFile.TrackChunk.Event {
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    public static func pressure(
        delta: MIDIFile.TrackChunk.DeltaTime = .none,
        amount: MIDIEvent.Pressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileTrackEvent = .pressure(
            amount: amount,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.Pressure: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .pressure }
    
    public var wrapped: MIDIFileTrackEvent {
        .pressure(self)
    }
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) {
        let rawBytesCountWithRunningStatus = rawBytes.count + (runningStatus != nil ? 1 : 0)
        guard rawBytesCountWithRunningStatus == Self.midi1SMFFixedRawBytesLength else {
            throw .malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let (
            readStatus, readChannel, readValue
        ) = try rawBytes.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8) in
            do {
                let byte0 = try runningStatus ?? parser.readByte()
                let readValue = try parser.readByte()
                
                return (
                    readStatus: (byte0 & 0xF0) >> 4,
                    readChannel: byte0 & 0x0F,
                    readValue: readValue
                )
            } catch {
                throw .malformed("Not enough bytes.")
            }
        }
        
        guard readStatus == 0xD else {
            throw .malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
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
                "Value(s) out of bounds."
            )
        }
        
        let newEvent: MIDIEvent = .pressure(
            amount: .midi1(pressure),
            channel: channel
        )
        
        guard case let .pressure(unwrapped) = newEvent else {
            throw .malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) -> StreamDecodeResult {
        let requiredByteCount = midi1SMFFixedRawBytesLength
        let requiredStreamByteCount = requiredByteCount - (runningStatus != nil ? 1 : 0)
        let rawBytes = stream.prefix(requiredStreamByteCount)
        
        let newInstance = try Self(midi1SMFRawBytes: rawBytes, runningStatus: runningStatus)
        
        return (
            newEvent: newInstance,
            bufferLength: rawBytes.count
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // Dn value
        D(midi1RawBytes())
    }
    
    static var midi1SMFFixedRawBytesLength: Int { 2 }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)

        return "pressure:\(amount) chan:\(chanString)"
    }

    public var smfDebugDescription: String {
        "ChanPressure(" + smfDescription + ")"
    }
}
