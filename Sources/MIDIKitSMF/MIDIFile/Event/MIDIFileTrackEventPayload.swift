//
//  MIDIFileTrackEventPayload.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Protocol describing a MIDI event payload for use in ``MIDIFileTrackEvent`` cases.
public protocol MIDIFileTrackEventPayload: Equatable, Hashable, Sendable {
    /// MIDI File event type.
    static var smfEventType: MIDIFileTrackEventType { get }
    
    /// Returns the MIDI file event payload wrapped in its corresponding ``MIDIFileTrackEvent`` enum case.
    func asMIDIFileTrackEvent() -> MIDIFileTrackEvent
    
    /// Initialize by decoding raw event bytes.
    /// Throws an error if data is malformed or cannot otherwise be used to construct the event.
    /// The event bytes must be a complete standalone MIDI file event. Running status is not supported
    /// in this initializer.
    /// 
    /// - Parameters:
    ///   - rawBytes: Raw event bytes.
    init(
        midi1SMFRawBytes rawBytes: some DataProtocol
    ) throws(MIDIFileDecodeError)
    
    /// Decode raw event bytes.
    ///
    /// - Parameters:
    ///   - stream: Raw event byte stream.
    ///   - runningStatus: Running status, if present while parsing a Standard MIDI file track.
    ///     If `rawBytes` contains all bytes that comprise the message, pass `nil` for running status.
    static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileTrackEventDecodeResult<Self>
    
    /// Returns the encoded raw data for the event.
    func midi1SMFRawBytes() -> Data
    
    /// Returns the encoded raw data for the event.
    func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D
    
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
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol
    ) throws(MIDIFileDecodeError) {
        // test for fixed byte count if event is fixed length, otherwise checks minimum byte count
        _ = try Self.requiredByteLength(availableByteCount: rawBytes.count)
        
        let decoded = Self.decode(midi1SMFRawBytesStream: rawBytes, runningStatus: nil)
        switch decoded {
        case let .event(payload: payload, byteLength: _):
            self = payload
        case let .recoverableError(payload: _, byteLength: _, error: error):
            throw error // don't allow lossy/substitute payload in init()
        case let .unrecoverableError(error: error):
            throw error
        }
    }
    
    public func midi1SMFRawBytes() -> Data {
        midi1SMFRawBytes(as: Data.self)
    }
}

// MARK: - Defaulted Parameter Methods

extension MIDIFileTrackEventPayload {
    /// Decode raw event bytes.
    public static func decode(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) -> MIDIFileTrackEventDecodeResult<Self> {
        decode(midi1SMFRawBytesStream: stream, runningStatus: nil)
    }
}

// MARK: - Methods

extension MIDIFileTrackEventPayload {
    /// Decode raw event bytes.
    ///
    /// - Parameters:
    ///   - stream: Raw event byte stream.
    ///   - runningStatus: Running status, if present while parsing a Standard MIDI file track.
    ///     If `rawBytes` contains all bytes that comprise the message, pass `nil` for running status.
    static func decodeTypeErased(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> AnyMIDIFileTrackEventDecodeResult {
        let result = decode(midi1SMFRawBytesStream: stream, runningStatus: runningStatus)
        return result.asAnyMIDIFileTrackEventDecodeResult()
    }
    
    /// Required input byte length for ``init(midi1SMFRawBytes:)`` method.
    static func requiredByteLength(
        availableByteCount: Int
    ) throws(MIDIFileDecodeError) -> (byteCount: Int, isFixed: Bool) {
        let (minFullByteCount, isFixed) = smfEventType.midi1ByteLength
        
        let errorMessage = isFixed
            ? "Invalid number of bytes. Expected exactly \(minFullByteCount) but got \(availableByteCount)."
            : "Invalid number of bytes. Expected at least \(minFullByteCount) but got \(availableByteCount)."
        
        if isFixed {
            guard availableByteCount == minFullByteCount else {
                throw .malformed(errorMessage)
            }
        } else {
            guard availableByteCount >= minFullByteCount else {
                throw .malformed(errorMessage)
            }
        }
        
        return (byteCount: minFullByteCount, isFixed: isFixed)
    }

    /// Required input byte length for ``decode(midi1SMFRawBytesStream:runningStatus:)`` method.
    ///
    /// - Parameters:
    ///   - availableByteCount: Available number of remaining bytes in input data stream.
    ///   - isRunningStatusPresent: Is running status present?
    ///
    /// - Returns: Minimum byte count required.
    static func requiredStreamByteLength(
        availableByteCount: Int,
        isRunningStatusPresent: Bool
    ) throws(MIDIFileDecodeError) -> Int {
        // TODO: this is clunky; ideally methods are reworked (using generics on Payload protocol?) so that event decoder methods only have running status parameters for events that can utilize running status. then this internal inconsistency check wouldn't be needed.
        if isRunningStatusPresent {
            // this isn't an error, and parsing can continue
            assert(
                smfEventType.isMIDI1RunningStatusSupported,
                "Running status byte was passed to \(type(of: self)) decoder that does not utilize running status."
            )
        }
        
        // because it's a data stream, we don't care if the event itself has a fixed length,
        // we only need to validate whether minimum required byte count is available
        let (minFullByteCount, isFixed) = smfEventType.midi1ByteLength
        
        let minRequiredStreamByteCount = minFullByteCount - (isRunningStatusPresent ? 1 : 0)
        let inputByteCountWithRunningStatus = availableByteCount + (isRunningStatusPresent ? 1 : 0)
        
        guard inputByteCountWithRunningStatus >= minFullByteCount else {
            let errorMessage = "Invalid number of bytes. Expected\(isFixed ? "" : " at least") \(minRequiredStreamByteCount) but got \(availableByteCount)."
            throw .malformed(errorMessage)
        }
        
        return minRequiredStreamByteCount
    }
}
