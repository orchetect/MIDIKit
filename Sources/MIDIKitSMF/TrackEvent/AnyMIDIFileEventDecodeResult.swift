//
//  AnyMIDIFileEventDecodeResult.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

public enum AnyMIDIFileEventDecodeResult {
    /// Event successfully decoded.
    case event(payload: any MIDIFileEventPayload, byteLength: Int)
    
    /// An error was encountered during decoding, but the error is recoverable and track parsing
    /// can continue.
    /// If a suitable substitute for the event is possible, `payload` will be non-`nil`.
    case recoverableError(payload: (any MIDIFileEventPayload)?, byteLength: Int, error: MIDIFileDecodeError)
    
    /// An error was encountered during decoding.
    /// No substitute event is possible and track parsing cannot continue.
    case unrecoverableError(error: MIDIFileDecodeError)
}

extension AnyMIDIFileEventDecodeResult: Sendable { }

// MARK: - Methods {

extension AnyMIDIFileEventDecodeResult {
    /// If the result contains a payload, it is returned.
    public var payload: (any MIDIFileEventPayload)? {
        switch self {
        case let .event(payload: payload, byteLength: _):
            payload
        case let .recoverableError(payload: payload, byteLength: _, error: _):
            payload
        case .unrecoverableError(error: _):
            nil
        }
    }
    
    /// If the result contains an error, it is returned.
    public var error: MIDIFileDecodeError? {
        switch self {
        case .event(payload: _, byteLength: _):
            nil
        case let .recoverableError(payload: _, byteLength: _, error: error):
            error
        case let.unrecoverableError(error: error):
            error
        }
    }
    
    /// Returns `true` if a payload is present and it is lossy (a substitute event
    /// provided after encountering an error during decoding.
    public var isPayloadLossy: Bool {
        switch self {
        case .event(payload: _, byteLength: _):
            false
        case let .recoverableError(payload: payload, byteLength: _, error: _):
            payload != nil
        case .unrecoverableError(error: _):
            false
        }
    }
}
