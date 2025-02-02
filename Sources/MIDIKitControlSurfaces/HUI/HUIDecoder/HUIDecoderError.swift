//
//  HUIDecoderError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error type thrown by HUI decoders.
public enum HUIDecoderError: LocalizedError {
    /// Malformed.
    case malformed(_ verboseError: String)
    
    /// Unhandled.
    case unhandled(_ verboseError: String)
}

extension HUIDecoderError {
    public var errorDescription: String? {
        switch self {
        case let .malformed(verboseError):
            "Malformed: \(verboseError)"
        case let .unhandled(verboseError):
            "Unhandled: \(verboseError)"
        }
    }
}
