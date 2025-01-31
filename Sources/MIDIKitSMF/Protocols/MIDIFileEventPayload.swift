//
//  MIDIFileEventPayload.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Protocol describing a MIDI event payload for use in ``MIDIFileEvent`` cases.
public protocol MIDIFileEventPayload where Self: Sendable {
    /// MIDI File event type.
    static var smfEventType: MIDIFileEventType { get }
    
    /// Initialize from raw event bytes.
    /// Returns nil if data is malformed or cannot otherwise be used to construct the event.
    init<D: DataProtocol>(midi1SMFRawBytes rawBytes: D) throws
    
    /// Raw data for the event.
    func midi1SMFRawBytes<D: MutableDataProtocol>() -> D
   
    /// Returns the new event and MIDI file buffer length (number of bytes).
    typealias StreamDecodeResult = (newEvent: Self, bufferLength: Int)
    
    /// If it is possible to initialize a new instance of this event from the head of the data
    /// stream, a new instance will be returned along with the byte length traversed from the
    /// stream.
    static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws -> StreamDecodeResult
    
    /// Description for the event in a MIDI file context.
    var smfDescription: String { get }
    
    /// Debug description for the event in a MIDI file context.
    var smfDebugDescription: String { get }
}

extension MIDIFileEventPayload /* : CustomStringConvertible */ {
    @_disfavoredOverload
    public var description: String { smfDescription }
}

extension MIDIFileEventPayload /* : CustomDebugStringConvertible */ {
    @_disfavoredOverload
    public var debugDescription: String { smfDebugDescription }
}
