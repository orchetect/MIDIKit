//
//  MIDIInternalError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum MIDIInternalError: LocalizedError {
    case packetTooLarge(bufferByteCount: Int)
    case packetBuildError
    case umpEmpty
    case umpTooLarge
    
    public var errorDescription: String? {
        switch self {
        case let .packetTooLarge(bufferByteCount):
            return "Legacy MIDI Packet is too large (\(bufferByteCount) byte buffer). Maximum size is 65536 bytes."
        case .packetBuildError:
            return "Error building MIDI Packet."
        case .umpEmpty:
            return "Universal MIDI Packet cannot be empty."
        case .umpTooLarge:
            return "Universal MIDI Packet cannot contain more than 64 UInt32 words."
        }
    }
}
