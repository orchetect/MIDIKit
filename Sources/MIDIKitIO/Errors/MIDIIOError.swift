//
//  MIDIIOError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import MIDIKitCore

/// Error type returned by MIDIKit I/O operations.
public enum MIDIIOError: LocalizedError {
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

extension MIDIIOError: Hashable { }

extension MIDIIOError {
    /// Convenience to return a case of ``osStatus(_:)-swift.enum.case`` with its associated
    /// <doc://MIDIKitIO/MIDIKitCore/CoreMIDIOSStatus> formed from a raw Core MIDI `OSStatus` (Int32) integer value.
    public static func osStatus(_ rawValue: CoreMIDIOSStatus) -> Self {
        .osStatus(.init(rawValue: rawValue))
    }
}

extension MIDIIOError {
    public var errorDescription: String? {
        switch self {
        case let .internalInconsistency(verboseError):
            "Internal inconsistency: \(verboseError)"
    
        case let .malformed(verboseError):
            "Malformed: \(verboseError)"
    
        case let .notSupported(verboseError):
            "Not Supported: \(verboseError)"
    
        case let .connectionError(verboseError):
            "Connection Error: \(verboseError)"
    
        case let .readError(verboseError):
            "Read Error: \(verboseError)"
    
        case let .osStatus(midiOSStatus):
            midiOSStatus.errorDescription
        }
    }
}

#endif
