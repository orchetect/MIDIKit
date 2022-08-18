//
//  MTCGenerator State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKit

// MARK: - State

extension MTCGenerator {
    public enum State: Equatable {
        /// Idle:
        /// No activity (outgoing continuous data stream stopped).
        case idle
        
        /// Generating:
        /// Generator is actively generating messages.
        case generating
    }
}

extension MTCGenerator.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .idle:
            return "idle"
        case .generating:
            return "generating"
        }
    }
}
