//
//  Event Note Off.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - NoteOff

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Note Off
    public typealias NoteOff = MIDIEvent.NoteOff
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Note Off
    public static func noteOff(
        note: MIDINote,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOff(.init(
            note: note,
            velocity: velocity,
            channel: channel
        ))
    }
    
    /// Channel Voice Message: Note Off
    public static func noteOff(
        note: UInt7,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOff(.init(
            note: note,
            velocity: velocity,
            channel: channel
        ))
    }
}

extension MIDIFile.TrackChunk.Event {
    /// Channel Voice Message: Note Off
    public static func noteOff(
        delta: MIDIFile.TrackChunk.DeltaTime = .none,
        note: MIDINote,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileTrackEvent = .noteOff(
            note: note,
            velocity: velocity,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
    
    /// Channel Voice Message: Note Off
    public static func noteOff(
        delta: MIDIFile.TrackChunk.DeltaTime = .none,
        note: UInt7,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileTrackEvent = .noteOff(
            note: note,
            velocity: velocity,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.NoteOff: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .noteOff }
    
    public var wrapped: MIDIFileTrackEvent {
        .noteOff(self)
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
            readStatus, readChannel, readNoteNum, readVelocity
        ) = try rawBytes.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8, UInt8) in
            do {
                let byte0 = try runningStatus ?? parser.readByte()
                let noteNum = try parser.readByte()
                let velocity = try parser.readByte()
                return (
                    readStatus: (byte0 & 0xF0) >> 4,
                    readChannel: byte0 & 0x0F,
                    readNoteNum: noteNum,
                    readVelocity: velocity
                )
            } catch {
                throw .malformed("Not enough bytes.")
            }
        }
        
        guard readStatus == 0x8 else {
            throw .malformed(
                "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
            )
        }
        
        guard (0 ... 127).contains(readNoteNum) else {
            throw .malformed(
                "Note number is out of bounds: \(readNoteNum)"
            )
        }
        
        guard (0 ... 127).contains(readVelocity) else {
            throw .malformed(
                "Note velocity is out of bounds: \(readVelocity)"
            )
        }
        
        guard let channel = readChannel.toUInt4Exactly,
              let noteNum = readNoteNum.toUInt7Exactly,
              let velocity = readVelocity.toUInt7Exactly
        else {
            throw .malformed(
                "Value(s) out of bounds."
            )
        }
        
        let newEvent: MIDIEvent = .noteOff(
            noteNum,
            velocity: .midi1(velocity),
            channel: channel
        )
        guard case let .noteOff(unwrapped) = newEvent else {
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
        // 8n note velocity
        
        D(midi1RawBytes())
    }
    
    static var midi1SMFFixedRawBytesLength: Int { 3 }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "noteOff:#\(note) vel:\(velocity) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "NoteOff(" + smfDescription + ")"
    }
}
