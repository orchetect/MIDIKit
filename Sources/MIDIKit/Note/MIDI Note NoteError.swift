//
//  MIDI Note NoteError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Note {
    /// Error type returned by `MIDI.Note` methods.
    public enum NoteError: Error {
        /// Operation resulted in a MIDI note that is out of bounds (invalid).
        case outOfBounds
        
        /// An unexpected or malformed note name was encountered and could not be parsed.
        case malformedNoteName
    }
}

extension MIDI.Note.NoteError: CustomStringConvertible {
    public var localizedDescription: String {
        description
    }
    
    public var description: String {
        switch self {
        case .outOfBounds:
            return "Operation resulted in a MIDI note that is out of bounds (invalid)."
            
        case .malformedNoteName:
            return "An unexpected or malformed note name was encountered and could not be parsed."
        }
    }
}
