//
//  Event Note On.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - NoteOn

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
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
        note: MIDINote,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOn(.init(
            note: note,
            velocity: velocity,
            channel: channel
        ))
    }
    
    /// Channel Voice Message: Note On
    public static func noteOn(
        note: UInt7,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        .noteOn(.init(
            note: note,
            velocity: velocity,
            channel: channel
        ))
    }
}

extension MIDI1File.TrackChunk.Event {
    /// Channel Voice Message: Note On
    public static func noteOn(
        delta: DeltaTime = .none,
        note: MIDINote,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileEvent = .noteOn(
            note: note,
            velocity: velocity,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
    
    /// Channel Voice Message: Note On
    public static func noteOn(
        delta: DeltaTime = .none,
        note: UInt7,
        velocity: MIDIEvent.NoteVelocity,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileEvent = .noteOn(
            note: note,
            velocity: velocity,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.NoteOn: MIDIFileEventPayload {
    public static var smfEventType: MIDIFileEventType { .noteOn }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .noteOn(self)
    }
    
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        // Step 1: Check required byte count
        let requiredStreamByteCount: Int
        do throws(MIDIFileDecodeError) {
            requiredStreamByteCount = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 2: Parse out required bytes
        let readStatus, readChannel, readNoteNum, readVelocity: UInt8
        do throws(MIDIFileDecodeError) {
            (readStatus, readChannel, readNoteNum, readVelocity) =
            try stream.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8, UInt8) in
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
                    throw .malformed("Note On does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard readStatus == 0x9 else {
                throw .malformed(
                    "Note On has invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
            
            guard (0 ... 127).contains(readNoteNum) else {
                throw .malformed(
                    "Note On note number is out of bounds: \(readNoteNum)"
                )
            }
            
            guard (0 ... 127).contains(readVelocity) else {
                throw .malformed(
                    "Note On velocity is out of bounds: \(readVelocity)"
                )
            }
            
            guard let channel = readChannel.toUInt4Exactly,
                  let noteNum = readNoteNum.toUInt7Exactly,
                  let velocity = readVelocity.toUInt7Exactly
            else {
                throw .malformed(
                    "Note On value(s) are out of bounds."
                )
            }
            
            let newEvent = Self(
                note: noteNum,
                velocity: .midi1(velocity),
                channel: channel
            )
            
            return .event(
                payload: newEvent,
                byteLength: requiredStreamByteCount
            )
        } catch {
            return .recoverableError(
                payload: nil,
                byteLength: requiredStreamByteCount,
                error: error
            )
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // 9n note velocity
        
        D(midi1RawBytes())
    }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "noteOn:#\(note) vel:\(velocity) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "NoteOn(" + smfDescription + ")"
    }
}
