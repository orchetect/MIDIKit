//
//  MIDIFileEvent Payload.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFileEvent {
    /// Protocol describing a MIDI event payload for use in ``MIDIFileEvent`` cases.
    public protocol Payload where Self: Sendable {
        /// Wraps the concrete struct in its corresponding ``MIDIFileEvent`` enum case wrapper.
        func smfWrappedEvent(delta: MIDIFileEvent.DeltaTime) -> MIDIFileEvent
        
        /// MIDI File event type.
        static var smfEventType: EventType { get }
        
        /// Initialize from raw event bytes.
        /// Throws an error if data is malformed or cannot otherwise be used to construct the event.
        ///
        /// - Parameters:
        ///   - rawBytes: Raw event bytes.
        ///   - runningStatus: Running status, if present while parsing a Standard MIDI file track.
        ///     If `rawBytes` contains all bytes that comprise the message, pass `nil` for running status.
        init<D: DataProtocol>(
            midi1SMFRawBytes rawBytes: D,
            runningStatus: UInt8?
        ) throws(MIDIFile.DecodeError)
        
        /// If it is possible to initialize a new instance of this event from the head of the data
        /// stream, a new instance will be returned along with the byte length traversed from the
        /// stream.
        ///
        /// - Parameters:
        ///   - stream: Raw event byte stream.
        ///   - runningStatus: Running status, if present while parsing a Standard MIDI file track.
        ///     If `rawBytes` contains all bytes that comprise the message, pass `nil` for running status.
        static func initFrom(
            midi1SMFRawBytesStream stream: some DataProtocol,
            runningStatus: UInt8?
        ) throws(MIDIFile.DecodeError) -> StreamDecodeResult
        
        /// Returns the encoded raw data for the event.
        func midi1SMFRawBytes() -> Data
        
        /// Returns the encoded raw data for the event.
        func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D
        
        /// Returns the new event and MIDI file buffer length (number of bytes).
        typealias StreamDecodeResult = (newEvent: Self, bufferLength: Int)
        
        /// Description for the event in a MIDI file context.
        var smfDescription: String { get }
        
        /// Debug description for the event in a MIDI file context.
        var smfDebugDescription: String { get }
    }
}

extension MIDIFileEvent.Payload /* : CustomStringConvertible */ {
    @_disfavoredOverload
    public var description: String { smfDescription }
}

extension MIDIFileEvent.Payload /* : CustomDebugStringConvertible */ {
    @_disfavoredOverload
    public var debugDescription: String { smfDebugDescription }
}

// MARK: - Default Implementation

extension MIDIFileEvent.Payload {
    public func midi1SMFRawBytes() -> Data {
        midi1SMFRawBytes(as: Data.self)
    }
}

// MARK: - Extension Methods

extension MIDIFileEvent.Payload {
    /// Initialize from raw event bytes.
    /// Throws an error if data is malformed or cannot otherwise be used to construct the event.
    public init<D: DataProtocol>(
        midi1SMFRawBytes rawBytes: D
    ) throws(MIDIFile.DecodeError) {
        try self.init(midi1SMFRawBytes: rawBytes, runningStatus: nil)
    }
    
    /// If it is possible to initialize a new instance of this event from the head of the data
    /// stream, a new instance will be returned along with the byte length traversed from the
    /// stream.
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws(MIDIFile.DecodeError) -> StreamDecodeResult {
        try initFrom(midi1SMFRawBytesStream: stream, runningStatus: nil)
    }
}
