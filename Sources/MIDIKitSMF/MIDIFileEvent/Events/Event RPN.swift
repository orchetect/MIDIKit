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

extension MIDIEvent.RPN: MIDIFileEvent.Payload {
    public func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent {
        .rpn(delta: delta, event: self)
    }
    
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
        "rpn:\(parameter)\(change == .absolute ? "" : " - relative")"
    }
    
    public var smfDebugDescription: String {
        "RPN(" + smfDescription + ")"
    }
}
