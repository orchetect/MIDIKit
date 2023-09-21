//
//  Event NRPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - NRPN

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Channel Voice Message: NRPN (Non-Registered Parameter Number),
    /// also referred to as Assignable Controller in MIDI 2.0.
    public typealias NRPN = MIDIEvent.NRPN
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// Channel Voice Message: NRPN (Non-Registered Parameter Number),
    /// also referred to as Assignable Controller in MIDI 2.0.
    public static func nrpn(
        delta: DeltaTime = .none,
        parameter: MIDIEvent.AssignableController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4 = 0
    ) -> Self {
        .nrpn(
            delta: delta,
            event: .init(parameter, change: change, channel: channel)
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.NRPN: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .nrpn
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        let newEvent = try Self.initFrom(midi1SMFRawBytesStream: rawBytes)
        self = newEvent.newEvent
    }
    
    public func midi1SMFRawBytes<D>() -> D where D: MutableDataProtocol {
        D(midi1RawBytes())
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws -> StreamDecodeResult {
        let result = try MIDIParameterNumberUtils.initFrom(
            midi1SMFRawBytesStream: stream,
            expectedType: .assignable
        )
        
        let newEvent = MIDIEvent.NRPN(
            .raw(
                parameter: result.param,
                dataEntryMSB: result.dataMSB,
                dataEntryLSB: result.dataLSB
            ),
            change: .absolute,
            channel: result.channel
        )
        
        return (newEvent: newEvent, bufferLength: result.byteLength)
    }
    
    public var smfDescription: String {
        "nrpn:\(parameter)\(change == .absolute ? "" : " - relative")"
    }
    
    public var smfDebugDescription: String {
        "NRPN(" + smfDescription + ")"
    }
}
