//
//  HUIDecoderError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
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
        case .malformed(let verboseError):
            return "Malformed: \(verboseError)"
        case .unhandled(let verboseError):
            return "Unhandled: \(verboseError)"
        }
    }
}
