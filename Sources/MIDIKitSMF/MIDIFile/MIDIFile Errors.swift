//
//  MIDIFile Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
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
                return "File not found."
            case .malformedURL:
                return "Malformed URL."
            case .fileReadError:
                return "File read error."
            case .malformed(let verboseError):
                return "Malformed: \(verboseError)"
            case .notImplemented:
                return "Not implemented."
            }
        }
    }

    public enum EncodeError: LocalizedError {
        /// Internal Inconsistency. `verboseError` contains the specific reason.
        case internalInconsistency(_ verboseError: String)
        
        public var errorDescription: String? {
            switch self {
            case .internalInconsistency(let verboseError):
                return "Internal inconsistency: \(verboseError)"
            }
        }
    }
}
