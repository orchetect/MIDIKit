//
//  Event Note Pressure.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore

// MARK: - PolyphonicPressure

extension MIDIFileEvent {
    public typealias NotePressure = MIDIEvent.NotePressure
}

extension MIDIEvent.NotePressure: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .notePressure
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readNoteNum = rawBytes[1]
        let readPressure = rawBytes[2]
        
        guard readStatus == 0xA else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }
        
        guard readNoteNum.isContained(in: 0 ... 127) else {
            throw MIDIFile.DecodeError.malformed(
                "Note number is out of bounds: \(readNoteNum)"
            )
        }
        
        guard readPressure.isContained(in: 0 ... 127) else {
            throw MIDIFile.DecodeError.malformed(
                "Note pressure value is out of bounds: \(readPressure)"
            )
        }
        
        guard let channel = readChannel.toUInt4Exactly,
              let noteNum = readNoteNum.toUInt7Exactly,
              let pressure = readPressure.toUInt7Exactly
        else {
            throw MIDIFile.DecodeError.malformed(
                "Value(s) out of bounds."
            )
        }
        
        let newEvent = MIDIEvent.notePressure(
            note: noteNum,
            amount: .midi1(pressure),
            channel: channel
        )
        guard case let .notePressure(unwrapped) = newEvent else {
            throw MIDIFile.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // An note pressure
        
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
        
        return "note:\(note) pressure:\(amount) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "PolyPressure(" + smfDescription + ")"
    }
}
