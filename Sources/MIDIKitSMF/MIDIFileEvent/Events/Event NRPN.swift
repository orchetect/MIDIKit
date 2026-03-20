//
//  Event NRPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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

extension MIDIEvent.NRPN: MIDIFileEvent.Payload {
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        .nrpn(delta: delta, event: self)
    }
    
    public static let smfEventType: MIDIFileEvent.EventType = .nrpn
    
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
        // stream parsing is not supported since it involves multiple MIDI file events with delta times
        throw .notImplemented
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        let events = parameter.midi1Events(channel: channel, group: group)
            .map { $0.midi1RawBytes() }
        let packed = events.joined(separator: [0x00]) // add delta time for all events after the first event
        return D(packed)
    }
    
    public var smfDescription: String {
        "nrpn:\(parameter)\(change == .absolute ? "" : " - relative")"
    }
    
    public var smfDebugDescription: String {
        "NRPN(" + smfDescription + ")"
    }
}
