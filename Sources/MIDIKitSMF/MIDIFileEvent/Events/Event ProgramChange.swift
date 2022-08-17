//
//  Event ProgramChange.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore

// MARK: - ProgramChange

extension MIDIFileEvent {
    public typealias ProgramChange = MIDIEvent.ProgramChange
}

extension MIDIEvent.ProgramChange: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .programChange
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readProgramNumber = rawBytes[1]
        
        guard readStatus == 0xC else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }
        
        guard readProgramNumber.isContained(in: 0 ... 127) else {
            throw MIDIFile.DecodeError.malformed(
                "Program Change program number is out of bounds: \(readProgramNumber)"
            )
        }
        
        guard let channel = readChannel.toUInt4Exactly,
              let programNumber = readProgramNumber.toUInt7Exactly
        else {
            throw MIDIFile.DecodeError.malformed(
                "Value(s) out of bounds."
            )
        }
        
        let newEvent = MIDIEvent.programChange(
            program: programNumber,
            channel: channel
        )
        guard case let .programChange(unwrapped) = newEvent else {
            throw MIDIFile.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // Cn program
        
        midi1RawBytes()
    }
    
    static let midi1SMFFixedRawBytesLength = 2
    
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
        
        return "prgm#\(program) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "ProgChange(" + smfDescription + ")"
    }
}
