//
//  Event RPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

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
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) {
        let newEvent = try Self.initFrom(midi1SMFRawBytesStream: rawBytes, runningStatus: runningStatus)
        self = newEvent.newEvent
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
        let result = try MIDIParameterNumberUtils.initFrom(
            midi1SMFRawBytesStream: stream,
            runningStatus: runningStatus,
            expectedType: .registered
        )
        
        let newEvent = MIDIEvent.RPN(
            .init(parameter: result.param, data: (msb: result.dataMSB, lsb: result.dataLSB)),
            change: .absolute,
            channel: result.channel
        )
        
        return (newEvent: newEvent, bufferLength: result.byteLength)
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        D(midi1RawBytes())
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
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?,
        expectedType: MIDIParameterNumberType
    ) throws(MIDIFile.DecodeError) -> (
        param: UInt7Pair,
        dataMSB: UInt7,
        dataLSB: UInt7?,
        channel: UInt4,
        byteLength: Int
    ) {
        var initialRunningStatus = runningStatus
        
        return try stream.withDataParser { parser throws(MIDIFile.DecodeError) in
            var internalRunningStatus: UInt8?
            
            func runningStatusChannel() -> UInt4? {
                internalRunningStatus?.nibbles.low
            }
            
            // since this is a sub-parser, we have to account for our own running status until we're
            // done parsing this event
            func needsRunningStatus() -> Bool {
                guard let nextByte = try? parser.readByte(advance: false) else { return false }
                return nextByte < 0x80
            }
            
            func readValue(for cc: MIDIEvent.CC.Controller) throws(MIDIFile.DecodeError) -> MIDIFileEvent.CC.StreamDecodeResult {
                let effectiveRunningStatus: UInt8? = try { () throws(MIDIFile.DecodeError) in
                    if let rs = initialRunningStatus {
                        initialRunningStatus = nil // consume it so we don't use it again
                        return rs
                    }
                    else if needsRunningStatus() {
                        guard let internalRunningStatus else {
                            throw .malformed("Missing running status byte.")
                        }
                        return internalRunningStatus
                    } else {
                        return nil
                    }
                }()
                let runningStatusByteCount: Int = effectiveRunningStatus != nil ? 1 : 0
                
                let result: MIDIFileEvent.CC.StreamDecodeResult
                do {
                    let residualBytes = try parser.read(
                        bytes: MIDIEvent.CC.midi1SMFFixedRawBytesLength - runningStatusByteCount,
                        advance: false
                    )
                    result = try MIDIFileEvent.CC.initFrom(
                        midi1SMFRawBytesStream: residualBytes,
                        runningStatus: effectiveRunningStatus
                    )
                } catch {
                    throw .malformed(
                        "Expected CC message with controller number \(cc.number). \(error.localizedDescription)"
                    )
                }
                
                guard result.newEvent.controller == cc
                else {
                    throw .malformed(
                        "Expected CC message with controller number \(cc.number) but found controller number \(result.newEvent.controller.number) instead."
                    )
                }
                
                if let internalRunningStatus {
                    // only allow continuing if running status doesn't change
                    guard internalRunningStatus.nibbles.low == result.newEvent.channel else {
                        throw .malformed(
                            "CC message has different channel number."
                        )
                    }
                } else {
                    // update internal running status for this sub-parser
                    internalRunningStatus = UInt8(high: 0xB, low: result.newEvent.channel)
                }
                
                // remove prefix byte count (if any) from byte count
                let actualByteCountRead = result.bufferLength - runningStatusByteCount
                
                try parser.toMIDIFileDecodeError(try parser.seek(by: actualByteCountRead))
                
                let newResult: MIDIFileEvent.CC.StreamDecodeResult = (
                    newEvent: result.newEvent,
                    bufferLength: actualByteCountRead
                )
                
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
            if let dataLSBResult {
                totalByteCount += dataLSBResult.bufferLength
            }
            
            guard let channel = runningStatusChannel() else {
                // this shouldn't happen, but we need to handle it any way
                throw .malformed("Channel could not be determined.")
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
