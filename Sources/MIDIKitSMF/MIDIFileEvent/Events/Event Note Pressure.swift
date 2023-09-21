//
//  Event Note Pressure.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - PolyphonicPressure

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
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
        delta: DeltaTime = .none,
        note: MIDINote,
        amount: MIDIEvent.NotePressure.Amount,
        channel: UInt4 = 0
    ) -> Self {
        .notePressure(
            delta: delta,
            event: .init(
                note: note,
                amount: amount,
                channel: channel
            )
        )
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
        .notePressure(
            delta: delta,
            event: .init(
                note: note,
                amount: amount,
                channel: channel
            )
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.NotePressure: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .notePressure
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        self = try rawBytes.withDataReader { dataReader in
            let byte0 = try dataReader.readByte()
            
            let readStatus = (byte0 & 0xF0) >> 4
            let readChannel = byte0 & 0x0F
            let readNoteNum = try dataReader.readByte()
            let readPressure = try dataReader.readByte()
            
            guard readStatus == 0xA else {
                throw MIDIFile.DecodeError.malformed(
                    "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
        
            guard (0 ... 127).contains(readNoteNum) else {
                throw MIDIFile.DecodeError.malformed(
                    "Note number is out of bounds: \(readNoteNum)"
                )
            }
        
            guard (0 ... 127).contains(readPressure) else {
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
            
            return unwrapped
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // An note pressure
        
        D(midi1RawBytes())
    }
    
    static let midi1SMFFixedRawBytesLength = 3
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
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
        
        return "note:\(note) pressure:\(amount) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "PolyPressure(" + smfDescription + ")"
    }
}
