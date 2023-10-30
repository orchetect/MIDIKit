//
//  MIDIIOError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Error type returned by MIDIKit I/O operations.
public enum MIDIIOError: LocalizedError, Hashable {
    // General
    case internalInconsistency(_ verboseError: String)
    case malformed(_ verboseError: String)
    case notSupported(_ verboseError: String)
    
    // Connections
    case connectionError(_ verboseError: String)
    case readError(_ verboseError: String)
    
    // Core MIDI.OSStatus
    case osStatus(MIDIOSStatus)
}

extension MIDIIOError {
    /// Convenience to return a case of ``osStatus(_:)-swift.enum.case`` with its associated
    /// ``CoreMIDIOSStatus`` formed from a raw Core MIDI `OSStatus` (Int32) integer value.
    public static func osStatus(_ rawValue: CoreMIDIOSStatus) -> Self {
        .osStatus(.init(rawValue: rawValue))
    }
}

extension MIDIIOError {
    public var errorDescription: String? {
        switch self {
        case let .internalInconsistency(verboseError):
            return "Internal inconsistency: \(verboseError)"
    
        case let .malformed(verboseError):
            return "Malformed: \(verboseError)"
    
        case let .notSupported(verboseError):
            return "Not Supported: \(verboseError)"
    
        case let .connectionError(verboseError):
            return "Connection Error: \(verboseError)"
    
        case let .readError(verboseError):
            return "Read Error: \(verboseError)"
    
        case let .osStatus(midiOSStatus):
            return "\(midiOSStatus)"
        }
    }
}

#endif
