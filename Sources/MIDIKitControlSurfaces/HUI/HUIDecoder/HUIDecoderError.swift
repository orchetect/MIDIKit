//
//  HUIDecoderError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

/// Error type thrown by HUI decoders.
public enum HUIDecoderError: Error {
    /// Malformed.
    case malformed(_ verboseError: String)
    
    /// Unhandled.
    case unhandled(_ verboseError: String)
}
