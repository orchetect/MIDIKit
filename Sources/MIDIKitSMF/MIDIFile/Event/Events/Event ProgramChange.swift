//
//  Event ProgramChange.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - ProgramChange

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Program Change
    ///
    /// > Note: When decoding, bank information is not decoded as part of the Program Change event
    /// > but will be decoded as individual CC messages. This may be addressed in a future release
    /// > of MIDIKit.
    public typealias ProgramChange = MIDIEvent.ProgramChange
}

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
    /// Channel Voice Message: Program Change
    ///
    /// > Note: When decoding, bank information is not decoded as part of the Program Change event
    /// > but will be decoded as individual CC messages. This may be addressed in a future release
    /// > of MIDIKit.
    public static func programChange(
        program: UInt7,
        channel: UInt4 = 0
    ) -> Self {
        .programChange(
            .init(
                program: program,
                bank: .noBankSelect,
                channel: channel
            )
        )
    }
}

extension MIDIFile.TrackChunk.Event {
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
        let event: MIDIFileTrackEvent = .programChange(
            program: program,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.ProgramChange: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .programChange }
    
    public var wrapped: MIDIFileTrackEvent {
        .programChange(self)
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
        let readStatus, readChannel, readProgramNumber: UInt8
        do throws(MIDIFileDecodeError) {
            (readStatus, readChannel, readProgramNumber) =
            try stream.withDataParser { parser throws(MIDIFileDecodeError) -> (UInt8, UInt8, UInt8) in
                do {
                    let byte0 = try runningStatus ?? parser.readByte()
                    let readProgramNumber = try parser.readByte()
                    
                    return (
                        readStatus: (byte0 & 0xF0) >> 4,
                        readChannel: byte0 & 0x0F,
                        readProgramNumber: readProgramNumber
                    )
                } catch {
                    throw .malformed("Program Change does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard readStatus == 0xC else {
                throw .malformed(
                    "Program Change has invalid status nibble: \(readStatus.hexString(padTo: 1, prefix: true))."
                )
            }
            
            guard (0 ... 127).contains(readProgramNumber) else {
                throw .malformed(
                    "Program Change program number is out of bounds: \(readProgramNumber)"
                )
            }
            
            guard let channel = readChannel.toUInt4Exactly,
                  let programNumber = readProgramNumber.toUInt7Exactly
            else {
                throw .malformed(
                    "Program Change value(s) are out of bounds."
                )
            }
            
            // TODO: Should this attempt to decode bank messages that may follow?
            
            let newEvent = Self(
                program: programNumber,
                bank: .noBankSelect,
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
        // Cn program
        
        D(midi1RawBytes())
    }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)
        
        return "prgm#\(program) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        "ProgChange(" + smfDescription + ")"
    }
}
