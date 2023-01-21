//
//  Event RPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - RPN

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    public typealias RPN = MIDIEvent.RPN
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    public static func rpn(
        delta: DeltaTime = .none,
        parameter: MIDIEvent.RegisteredController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4 = 0
    ) -> Self {
        .rpn(
            delta: delta,
            event: .init(parameter, change: change, channel: channel)
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.RPN: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .rpn
    
    public init<D>(midi1SMFRawBytes rawBytes: D) throws where D : DataProtocol {
        let newEvent = try Self.initFrom(midi1SMFRawBytesStream: rawBytes)
        self = newEvent.newEvent
    }
    
    public func midi1SMFRawBytes<D>() -> D where D : MutableDataProtocol {
        D(midi1RawBytes())
    }
    
    public static func initFrom<D>(
        midi1SMFRawBytesStream stream: D
    ) throws -> StreamDecodeResult where D : DataProtocol {
        let result = try MIDIParameterNumberUtils.initFrom(
            midi1SMFRawBytesStream: stream,
            expectedType: .registered
        )
        
        let newEvent = MIDIEvent.RPN(
            .init(parameter: result.param, data: (msb: result.dataMSB, lsb: result.dataLSB)),
            change: .absolute,
            channel: result.channel
        )
        
        return (newEvent: newEvent, bufferLength: result.byteLength)
    }
    
    public var smfDescription: String {
        "rpn:\(parameter)\(change == .absolute ? "" : " - relative")"
    }
    
    public var smfDebugDescription: String {
        "RPN(" + smfDescription + ")"
    }
}

extension MIDIParameterNumberUtils {
    // generic parser for RPN and NRPN messages since they are so similar in format
    public static func initFrom<D>(
        midi1SMFRawBytesStream stream: D,
        expectedType: MIDIParameterNumberType
    ) throws -> (
        param: UInt7Pair,
        dataMSB: UInt7,
        dataLSB: UInt7?,
        channel: UInt4,
        byteLength: Int
    )
    where D: DataProtocol {
        try stream.withDataReader { dataReader in
            var runningStatus: UInt8? = nil
            
            func runningStatusChannel() -> UInt4? {
                runningStatus?.nibbles.low
            }
            
            // since this is a sub-parser, we have to account for our own running status until we're
            // done parsing this event
            func needsRunningStatus() -> Bool {
                guard let nextByte = try? dataReader.nonAdvancingReadByte() else { return false }
                return nextByte < 0x80
            }
            
            func readValue(for cc: MIDIEvent.CC.Controller) throws -> MIDIFileEvent.CC.StreamDecodeResult {
                let prefixBytes: [UInt8] = try {
                    if needsRunningStatus() {
                        guard let runningStatus = runningStatus else {
                            throw MIDIFile.DecodeError.malformed(
                                "Missing running status byte."
                            )
                        }
                        return [runningStatus]
                    } else {
                        return []
                    }
                }()
                
                let result: MIDIFileEvent.CC.StreamDecodeResult
                do {
                    result = try MIDIFileEvent.CC.initFrom(
                        midi1SMFRawBytesStream: prefixBytes + dataReader.nonAdvancingRead()
                    )
                } catch {
                    throw MIDIFile.DecodeError.malformed(
                        "Expected CC message with controller number \(cc.number). \(error.localizedDescription)"
                    )
                }
                
                guard result.newEvent.controller == cc
                else {
                    throw MIDIFile.DecodeError.malformed(
                        "Expected CC message with controller number \(cc.number) but found controller number \(result.newEvent.controller.number) instead."
                    )
                }
                
                if let runningStatus = runningStatus {
                    // only allow continuing if running status doesn't change
                    guard runningStatus.nibbles.low == result.newEvent.channel else {
                        throw MIDIFile.DecodeError.malformed(
                            "CC message has different channel number."
                        )
                    }
                } else {
                    // update internal running status for this sub-parser
                    runningStatus = UInt8(high: 0xB, low: result.newEvent.channel)
                    
                }
                
                // remove prefix byte count (if any) from byte count
                let actualByteCountRead = result.bufferLength - prefixBytes.count
                
                dataReader.advanceBy(actualByteCountRead)
                
                let newResult: MIDIFileEvent.CC.StreamDecodeResult = (newEvent: result.newEvent, bufferLength: actualByteCountRead)
                
                return newResult
            }
            
            var totalByteCount = 0
            
            // CC msg #1 - param MSB
            let paramMSBResult = try readValue(for: expectedType.controllers.msb)
            totalByteCount += paramMSBResult.bufferLength
            
            // CC msg #2 - param LSB
            let paramLSBResult = try readValue(for: expectedType.controllers.lsb)
            totalByteCount += paramLSBResult.bufferLength
            
            // CC msg #3 - data MSB
            let dataMSBResult = try readValue(for: .dataEntry)
            totalByteCount += dataMSBResult.bufferLength
            
            let dataLSBResult = try? readValue(for: .lsb(for: .dataEntry))
            if let dataLSBResult = dataLSBResult {
                totalByteCount += dataLSBResult.bufferLength
            }
            
            guard let channel = runningStatusChannel() else {
                // this shouldn't happen, but we need to handle it any way
                throw MIDIFile.DecodeError.malformed(
                    "Channel could not be determined."
                )
            }
            
            return (
                param: .init(
                    msb: paramMSBResult.newEvent.value.midi1Value,
                    lsb: paramLSBResult.newEvent.value.midi1Value
                ),
                dataMSB: dataMSBResult.newEvent.value.midi1Value,
                dataLSB: dataLSBResult?.newEvent.value.midi1Value,
                channel: channel,
                byteLength: totalByteCount
            )
        }
    }
}
