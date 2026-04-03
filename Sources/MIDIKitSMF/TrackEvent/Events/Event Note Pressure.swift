//
//  Event Note Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - PolyphonicPressure

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Channel Voice Message: Note Pressure (Polyphonic Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public typealias NotePressure = MIDIEvent.NotePressure
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Channel Voice Message: Note Pressure (Polyphonic Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public static func notePressure(
        note: MIDINote,
        amount: MIDIEvent.NotePressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .notePressure(.init(
            note: note,
            amount: amount,
            channel: channel
        ))
    }
    
    /// Channel Voice Message: Note Pressure (Polyphonic Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public static func notePressure(
        note: UInt7,
        amount: MIDIEvent.NotePressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .notePressure(.init(
            note: note,
            amount: amount,
            channel: channel
        ))
    }
}

extension MIDI1File.TrackChunk.Event {
    /// Channel Voice Message: Note Pressure (Polyphonic Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public static func notePressure(
        delta: DeltaTime = .none,
        note: MIDINote,
        amount: MIDIEvent.NotePressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileEvent = .notePressure(
            note: note,
            amount: amount,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
    
    /// Channel Voice Message: Note Pressure (Polyphonic Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    public static func notePressure(
        delta: DeltaTime = .none,
        note: UInt7,
        amount: MIDIEvent.NotePressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileEvent = .notePressure(
            note: note,
            amount: amount,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.NotePressure: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .notePressure }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .notePressure(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
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
        let readStatus, readChannel, readNoteNum, readPressure: UInt8
        do throws(MIDIFileDecodeError) {
            (readStatus, readChannel, readNoteNum, readPressure) = try stream.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8, UInt8) in
                do {
                    let byte0 = try runningStatus ?? parser.readByte()
                    let noteNum = try parser.readByte()
                    let pressure = try parser.readByte()
                    
                    return (
                        readStatus: (byte0 & 0xF0) >> 4,
                        readChannel: byte0 & 0x0F,
                        readNoteNum: noteNum,
                        readPressure: pressure
                    )
                } catch {
                    throw .malformed("Note Pressure does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard readStatus == 0xA else {
                throw .malformed(
                    "Note Pressure has invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
            
            guard (0 ... 127).contains(readNoteNum) else {
                throw .malformed(
                    "Note Pressure note number is out of bounds: \(readNoteNum)"
                )
            }
            
            guard (0 ... 127).contains(readPressure) else {
                throw .malformed(
                    "Note Pressure value is out of bounds: \(readPressure)"
                )
            }
            
            guard let channel = readChannel.toUInt4Exactly,
                  let noteNum = readNoteNum.toUInt7Exactly,
                  let pressure = readPressure.toUInt7Exactly
            else {
                throw .malformed(
                    "Note Pressure value value(s) are out of bounds."
                )
            }
            
            let newEvent = Self(
                note: noteNum,
                amount: .midi1(pressure),
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
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // An note pressure
        
        D(midi1RawBytes())
    }
    
    static var midi1FileFixedRawBytesLength: Int { 3 }
    
    public var midiFileDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "note:\(note) pressure:\(amount) chan:\(chanString)"
    }
    
    public var midiFileDebugDescription: String {
        "PolyPressure(" + midiFileDescription + ")"
    }
}
