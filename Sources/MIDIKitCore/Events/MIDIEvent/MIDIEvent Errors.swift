//
//  MIDIEvent Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIEvent {
    public enum ParseError: LocalizedError {
        case rawBytesEmpty
        case malformed
        case invalidType
    }
}

extension MIDIEvent.ParseError {
    public var errorDescription: String? {
        switch self {
        case .rawBytesEmpty:
            "Raw bytes empty."
        case .malformed:
            "Malformed."
        case .invalidType:
            "Invalid type."
        }
    }
}
