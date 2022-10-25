//
//  Event Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Channel Pressure

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
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
        delta: DeltaTime = .none,
        amount: MIDIEvent.Pressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .pressure(
            delta: delta,
            event: .init(
                amount: amount,
                channel: channel
            )
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.Pressure: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .pressure
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        self = try rawBytes.withDataReader { dataReader in
            let byte0 = try dataReader.readByte()
            let readStatus = (byte0 & 0xF0) >> 4
            let readChannel = byte0 & 0x0F
            
            let readValue = try dataReader.readByte()
            
            guard readStatus == 0xD else {
                throw MIDIFile.DecodeError.malformed(
                    "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
        
            guard (0 ... 127).contains(readValue) else {
                throw MIDIFile.DecodeError.malformed(
                    "Channel Pressure value is out of bounds: \(readValue)"
                )
            }
        
            guard let channel = readChannel.toUInt4Exactly,
                  let pressure = readValue.toUInt7Exactly
            else {
                throw MIDIFile.DecodeError.malformed(
                    "Value(s) out of bounds."
                )
            }
        
            let newEvent = MIDIEvent.pressure(
                amount: .midi1(pressure),
                channel: channel
            )
            
            guard case let .pressure(unwrapped) = newEvent else {
                throw MIDIFile.DecodeError.malformed(
                    "Could not unwrap enum case."
                )
            }
        
            return unwrapped
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // Dn value
        D(midi1RawBytes())
    }
    
    static let midi1SMFFixedRawBytesLength = 2

    public static func initFrom<D: DataProtocol>(
        midi1SMFRawBytesStream stream: D
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

        return "pressure:\(amount) chan:\(chanString)"
    }

    public var smfDebugDescription: String {
        "ChanPressure(" + smfDescription + ")"
    }
}
