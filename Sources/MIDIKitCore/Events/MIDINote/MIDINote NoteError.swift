//
//  MIDINote NoteError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDINote {
    /// Error type returned by `MIDINote` methods.
    public enum NoteError: LocalizedError {
        /// Operation resulted in a MIDI note that is out of bounds (invalid).
        case outOfBounds
    
        /// An unexpected or malformed note name was encountered and could not be parsed.
        case malformedNoteName
    }
}

extension MIDINote.NoteError {
    public var errorDescription: String? {
        switch self {
        case .outOfBounds:
            return "MIDI note is out of bounds (invalid)."
        case .malformedNoteName:
            return "An unexpected or malformed note name was encountered."
        }
    }
}
