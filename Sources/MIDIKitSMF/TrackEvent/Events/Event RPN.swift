//
//  Event RPN.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - RPN

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
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
        parameter: MIDIEvent.RegisteredController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4 = 0
    ) -> Self {
        .rpn(
            .init(parameter, change: change, channel: channel)
        )
    }
}

extension MIDI1File.TrackChunk.Event {
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    public static func rpn(
        delta: DeltaTime = .none,
        parameter: MIDIEvent.RegisteredController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4 = 0
    ) -> Self {
        let event: MIDIFileEvent = .rpn(
            parameter: parameter,
            change: change,
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Encoding

extension MIDIEvent.RPN: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .rpn }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .rpn(self)
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
        "rpn:\(parameter)\(change == .absolute ? "" : " - relative")"
    }
    
    public var midiFileDebugDescription: String {
        "RPN(" + midiFileDescription + ")"
    }
}
