//
//  Event CC.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - CC

extension MIDIFileEvent {
    public typealias CC = MIDIEvent.CC
}

extension MIDIEvent.CC: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .cc
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let (
            readStatus, readChannel, readCCNum, readValue
        ) = try rawBytes.withDataReader { dataReader -> (UInt8, UInt8, UInt8, UInt8) in
            let byte0 = try dataReader.readByte()
            
            return (
                readStatus: (byte0 & 0xF0) >> 4,
                readChannel: byte0 & 0x0F,
                readNoteNum: try dataReader.readByte(),
                readPressure: try dataReader.readByte()
            )
        }
        
        guard readStatus == 0xB else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }

        guard (0 ... 127).contains(readCCNum) else {
            throw MIDIFile.DecodeError.malformed(
                "CC number is out of bounds: \(readCCNum)"
            )
        }

        guard (0 ... 127).contains(readValue) else {
            throw MIDIFile.DecodeError.malformed(
                "CC value is out of bounds: \(readValue)"
            )
        }
        
        guard let channel = readChannel.toUInt4Exactly,
              let ccNum = readCCNum.toUInt7Exactly,
              let value = readValue.toUInt7Exactly
        else {
            throw MIDIFile.DecodeError.malformed(
                "Value(s) out of bounds."
            )
        }
            
        let newEvent = MIDIEvent.cc(
            .init(number: ccNum),
            value: .midi1(value),
            channel: channel
        )
        
        guard case let .cc(unwrapped) = newEvent else {
            throw MIDIFile.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
    }

    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // Bn controller value
        
        D(midi1RawBytes())
    }

    static let midi1SMFFixedRawBytesLength = 3

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

        return "cc#\(controller.number) val:\(value) chan:\(chanString)"
    }

    public var smfDebugDescription: String {
        "CC(" + smfDescription + ")"
    }
}
