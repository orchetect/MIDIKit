//
//  MIDIFileTrackEventPayload.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Protocol describing a MIDI event payload for use in ``MIDIFileEvent`` cases.
public protocol MIDIFileTrackEventPayload where Self: Sendable {
    /// MIDI File event type.
    static var smfEventType: MIDIFileTrackEventType { get }
    
    /// Returns the MIDI file event payload wrapped in its corresponding ``MIDIFileTrackEvent`` enum case.
    var wrapped: MIDIFileTrackEvent { get }
    
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
    ) throws(MIDIFileDecodeError)
    
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
    ) throws(MIDIFileDecodeError) -> StreamDecodeResult
    
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

extension MIDIFileTrackEventPayload /* : CustomStringConvertible */ {
    @_disfavoredOverload
    public var description: String { smfDescription }
}

extension MIDIFileTrackEventPayload /* : CustomDebugStringConvertible */ {
    @_disfavoredOverload
    public var debugDescription: String { smfDebugDescription }
}

// MARK: - Default Implementation

extension MIDIFileTrackEventPayload {
    public func midi1SMFRawBytes() -> Data {
        midi1SMFRawBytes(as: Data.self)
    }
}

// MARK: - Extension Methods

extension MIDIFileTrackEventPayload {
    /// Initialize from raw event bytes.
    /// Throws an error if data is malformed or cannot otherwise be used to construct the event.
    public init<D: DataProtocol>(
        midi1SMFRawBytes rawBytes: D
    ) throws(MIDIFileDecodeError) {
        try self.init(midi1SMFRawBytes: rawBytes, runningStatus: nil)
    }
    
    /// If it is possible to initialize a new instance of this event from the head of the data
    /// stream, a new instance will be returned along with the byte length traversed from the
    /// stream.
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws(MIDIFileDecodeError) -> StreamDecodeResult {
        try initFrom(midi1SMFRawBytesStream: stream, runningStatus: nil)
    }
}
