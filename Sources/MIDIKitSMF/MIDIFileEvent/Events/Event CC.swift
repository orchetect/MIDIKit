//
//  Event CC.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
@_implementationOnly import OTCore

// MARK: - CC

extension MIDIFileEvent {
    public typealias CC = MIDIEvent.CC
}

extension MIDIEvent.CC: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .cc
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }

        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readCCNum = rawBytes[1]
        let readValue = rawBytes[2]

        guard readStatus == 0xB else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }

        guard readCCNum.isContained(in: 0 ... 127) else {
            throw MIDIFile.DecodeError.malformed(
                "CC number is out of bounds: \(readCCNum)"
            )
        }

        guard readValue.isContained(in: 0 ... 127) else {
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

    public var midi1SMFRawBytes: [Byte] {
        // Bn controller value
        
        midi1RawBytes()
    }

    static let midi1SMFFixedRawBytesLength = 3

    public static func initFrom(
        midi1SMFRawBytesStream rawBuffer: Data
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes

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
