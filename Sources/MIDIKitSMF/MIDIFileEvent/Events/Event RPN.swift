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
        param: MIDIEvent.RegisteredController,
        change: MIDI2ParameterNumberChange = .absolute,
        channel: UInt4 = 0
    ) -> Self {
        .rpn(
            delta: delta,
            event: .init(param, change: change, channel: channel)
        )
    }
}

// MARK: - Encoding

extension MIDIEvent.RPN: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .rpn
    
    public init<D>(midi1SMFRawBytes rawBytes: D) throws where D : DataProtocol {
        #warning("> finish this")
        throw MIDIFile.DecodeError.notImplemented
    }
    
    public func midi1SMFRawBytes<D>() -> D where D : MutableDataProtocol {
        #warning("> finish this")
        return D(midi1RawBytes())
    }
    
    public static func initFrom<D>(
        midi1SMFRawBytesStream stream: D
    ) throws -> StreamDecodeResult where D : DataProtocol {
        #warning("> finish this")
        throw MIDIFile.DecodeError.notImplemented
    }
    
    public var smfDescription: String {
        "rpn:\(param)\(change == .absolute ? "" : " - relative")"
    }
    
    public var smfDebugDescription: String {
        "RPN(" + smfDescription + ")"
    }
}
