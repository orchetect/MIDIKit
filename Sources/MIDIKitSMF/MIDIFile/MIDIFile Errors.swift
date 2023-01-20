//
//  MIDIFile Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension MIDIFile {
    public enum DecodeError: Error {
        case fileNotFound
        case malformedURL
        case fileReadError
        case malformed(_ verboseError: String)
        case notImplemented
    }

    public enum EncodeError: Error {
        /// Internal Inconsistency. `verboseError` contains the specific reason.
        case internalInconsistency(_ verboseError: String)
    }
}
