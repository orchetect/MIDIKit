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
//   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileTrackEvent type
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
        delta: DeltaTime = .none,
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
        delta: DeltaTime = .none,
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
    
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileTrackEventDecodeResult<Self> {
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
                    throw .malformed("Note Off does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard readStatus == 0x8 else {
                throw .malformed(
                    "Note Off has invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
            
            guard (0 ... 127).contains(readNoteNum) else {
                throw .malformed(
                    "Note Off note number is out of bounds: \(readNoteNum)"
                )
            }
            
            guard (0 ... 127).contains(readVelocity) else {
                throw .malformed(
                    "Note Off velocity is out of bounds: \(readVelocity)"
                )
            }
            
            guard let channel = readChannel.toUInt4Exactly,
                  let noteNum = readNoteNum.toUInt7Exactly,
                  let velocity = readVelocity.toUInt7Exactly
            else {
                throw .malformed(
                    "Note Off value(s) are out of bounds."
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
        // 8n note velocity
        
        D(midi1RawBytes())
    }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "noteOff:#\(note) vel:\(velocity) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "NoteOff(" + smfDescription + ")"
    }
}
