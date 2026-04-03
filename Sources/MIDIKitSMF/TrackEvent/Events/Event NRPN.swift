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
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
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
        parameter: MIDIEvent.AssignableController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4 = 0
    ) -> Self {
        .nrpn(
            .init(parameter, change: change, channel: channel)
        )
    }
}

extension MIDI1File.TrackChunk.Event {
    /// Channel Voice Message: NRPN (Non-Registered Parameter Number),
    /// also referred to as Assignable Controller in MIDI 2.0.
    public static func nrpn(
        delta: DeltaTime = .none,
        parameter: MIDIEvent.AssignableController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileEvent = .nrpn(
            parameter: parameter,
            change: change,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.NRPN: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .nrpn }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .nrpn(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        // stream parsing is not supported since it involves multiple MIDI file events with delta times
        return .unrecoverableError(error: .notImplemented)
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        let events = parameter.midi1Events(channel: channel, group: group)
            .map { $0.midi1RawBytes() }
        let packed = events.joined(separator: [0x00]) // add delta time for all events after the first event
        return D(packed)
    }
    
    public var midiFileDescription: String {
        "nrpn:\(parameter)\(change == .absolute ? "" : " - relative")"
    }
    
    public var midiFileDebugDescription: String {
        "NRPN(" + midiFileDescription + ")"
    }
}
