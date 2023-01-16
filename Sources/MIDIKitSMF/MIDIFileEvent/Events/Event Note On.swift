//
//  Event Note On.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - NoteOn

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Channel Voice Message: Note On
    public typealias NoteOn = MIDIEvent.NoteOn
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Channel Voice Message: Note On
    public static func noteOn(
        delta: DeltaTime = .none,
        note: MIDINote,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOn(
            delta: delta,
            event: .init(
                note: note,
                velocity: velocity,
                channel: channel
            )
        )
    }
    
    /// Channel Voice Message: Note On
    public static func noteOn(
        delta: DeltaTime = .none,
        note: UInt7,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOn(
            delta: delta,
            event: .init(
                note: note,
                velocity: velocity,
                channel: channel
            )
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.NoteOn: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .noteOn
    
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
        
        guard readStatus == 0x9 else {
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
        
        let newEvent = MIDIEvent.noteOn(
            noteNum,
            velocity: .midi1(velocity),
            channel: channel
        )
        guard case let .noteOn(unwrapped) = newEvent else {
            throw MIDIFile.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // 9n note velocity
        
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
        
        return "noteOn:#\(note) vel:\(velocity) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "NoteOn(" + smfDescription + ")"
    }
}
