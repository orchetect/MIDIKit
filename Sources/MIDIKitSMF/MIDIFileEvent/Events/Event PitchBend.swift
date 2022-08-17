//
//  Event PitchBend.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
@_implementationOnly import OTCore

// MARK: - PitchBend

extension MIDIFileEvent {
    public typealias PitchBend = MIDIEvent.PitchBend
}

extension MIDIEvent.PitchBend: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .pitchBend
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        
        guard readStatus == 0xE else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }
        
        guard let lsb = rawBytes[1].toUInt7Exactly else {
            throw MIDIFile.DecodeError.malformed(
                "Pitch Bend LSB is out of bounds: \(rawBytes[1].hexString(padTo: 2, prefix: true))"
            )
        }
        
        guard let msb = rawBytes[2].toUInt7Exactly else {
            throw MIDIFile.DecodeError.malformed(
                "Pitch Bend MSB is out of bounds: \(rawBytes[2].hexString(padTo: 2, prefix: true))"
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
        
        self = unwrapped
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // 3 bytes : En lsb msb
        
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
        
        return "bend:\(value) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "PitchBend(" + smfDescription + ")"
    }
}
