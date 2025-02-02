//
//  MIDIFile Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile {
    public enum DecodeError: LocalizedError {
        case fileNotFound
        case malformedURL
        case fileReadError
        case malformed(_ verboseError: String)
        case notImplemented
        
        public var errorDescription: String? {
            switch self {
            case .fileNotFound:
                "File not found."
            case .malformedURL:
                "Malformed URL."
            case .fileReadError:
                "File read error."
            case let .malformed(verboseError):
                "Malformed: \(verboseError)"
            case .notImplemented:
                "Not implemented."
            }
        }
    }

    public enum EncodeError: LocalizedError {
        /// Internal Inconsistency. `verboseError` contains the specific reason.
        case internalInconsistency(_ verboseError: String)
        
        public var errorDescription: String? {
            switch self {
            case let .internalInconsistency(verboseError):
                "Internal inconsistency: \(verboseError)"
            }
        }
    }
}
