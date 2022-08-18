//
//  Event Note Off.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - NoteOff

extension MIDIFileEvent {
    public typealias NoteOff = MIDIEvent.NoteOff
}

extension MIDIEvent.NoteOff: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .noteOff
    
    public init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let (
            readStatus, readChannel, readNoteNum, readVelocity
        ) = try rawBytes.withDataReader { dataReader -> (UInt8, UInt8, UInt8, UInt8) in
            let byte0 = try dataReader.readByte()
            
            return (
                readStatus: (byte0 & 0xF0) >> 4,
                readChannel: byte0 & 0x0F,
                readNoteNum: try dataReader.readByte(),
                readPressure: try dataReader.readByte()
            )
        }
        
        guard readStatus == 0x8 else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }
        
        guard (0 ... 127).contains(readNoteNum) else {
            throw MIDIFile.DecodeError.malformed(
                "Note number is out of bounds: \(readNoteNum)"
            )
        }
        
        guard (0 ... 127).contains(readVelocity) else {
            throw MIDIFile.DecodeError.malformed(
                "Note velocity is out of bounds: \(readVelocity)"
            )
        }
        
        guard let channel = readChannel.toUInt4Exactly,
              let noteNum = readNoteNum.toUInt7Exactly,
              let velocity = readVelocity.toUInt7Exactly
        else {
            throw MIDIFile.DecodeError.malformed(
                "Value(s) out of bounds."
            )
        }
        
        let newEvent = MIDIEvent.noteOff(
            noteNum,
            velocity: .midi1(velocity),
            channel: channel
        )
        guard case let .noteOff(unwrapped) = newEvent else {
            throw MIDIFile.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // 8n note velocity
        
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
        
        return "noteOff:#\(note) vel:\(velocity) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "NoteOff(" + smfDescription + ")"
    }
}
