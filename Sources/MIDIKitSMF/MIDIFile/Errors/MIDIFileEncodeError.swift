//
//  MIDIFileEncodeError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

public enum MIDIFileEncodeError: LocalizedError {
    /// Internal Inconsistency. `verboseError` contains the specific reason.
    case internalInconsistency(_ verboseError: String)
    
    public var errorDescription: String? {
        switch self {
        case let .internalInconsistency(verboseError):
            "Internal inconsistency: \(verboseError)"
        }
    }
}
