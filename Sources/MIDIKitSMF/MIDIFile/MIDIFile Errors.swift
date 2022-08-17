//
//  MIDI File Errors.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitEvents

extension MIDIFile {
    public enum DecodeError: Error {
        case fileNotFound
        case malformedURL
        case fileReadError

        case malformed(_ verboseError: String)
    }

    public enum EncodeError: Error {
        /// Internal Inconsistency. `verboseError` contains the specific reason.
        case internalInconsistency(_ verboseError: String)
    }
}
