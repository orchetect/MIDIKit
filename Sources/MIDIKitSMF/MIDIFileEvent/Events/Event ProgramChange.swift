//
//  Event ProgramChange.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - ProgramChange

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Channel Voice Message: Program Change
    ///
    /// > Note: When decoding, bank information is not decoded as part of the Program Change event
    /// > but will be decoded as individual CC messages. This may be addressed in a future release
    /// > of MIDIKit.
    public typealias ProgramChange = MIDIEvent.ProgramChange
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Channel Voice Message: Program Change
    ///
    /// > Note: When decoding, bank information is not decoded as part of the Program Change event
    /// > but will be decoded as individual CC messages. This may be addressed in a future release
    /// > of MIDIKit.
    public static func programChange(
        delta: DeltaTime = .none,
        program: UInt7,
        channel: UInt4 = 0
    ) -> Self {
        .programChange(
            delta: delta,
            event: .init(
                program: program,
                bank: .noBankSelect,
                channel: channel
            )
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.ProgramChange: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .programChange
    
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
            
            let readProgramNumber = try dataReader.readByte()
        
            guard readStatus == 0xC else {
                throw MIDIFile.DecodeError.malformed(
                    "Invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
        
            guard (0 ... 127).contains(readProgramNumber) else {
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
            
            // TODO: Should this attempt to decode bank messages that may follow?
            
            let newEvent: MIDIEvent = .programChange(
                program: programNumber,
                channel: channel
            )
            
            guard case let .programChange(unwrapped) = newEvent else {
                throw MIDIFile.DecodeError.malformed(
                    "Could not unwrap enum case."
                )
            }
        
            return unwrapped
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // Cn program
        
        D(midi1RawBytes())
    }
    
    static let midi1SMFFixedRawBytesLength = 2
    
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
        
        return "prgm#\(program) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "ProgChange(" + smfDescription + ")"
    }
}
