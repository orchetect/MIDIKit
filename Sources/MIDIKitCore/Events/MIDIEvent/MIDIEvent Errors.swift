//
//  MIDIEvent Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
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
            return "Raw bytes empty."
        case .malformed:
            return "Malformed."
        case .invalidType:
            return "Invalid type."
        }
    }
}
