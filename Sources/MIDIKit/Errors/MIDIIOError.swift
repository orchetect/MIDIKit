//
//  MIDIIOError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

/// Error type returned by `MIDI.IO` methods.
public enum MIDIIOError: Error, Hashable {
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
    /// Internal:
    /// Convenience to return a case of `osStatus` with its associated `CoreMIDIOSStatus` formed from a raw Core MIDI `OSStatus` (Int32) integer value.
    internal static func osStatus(_ rawValue: CoreMIDIOSStatus) -> Self {
        .osStatus(.init(rawValue: rawValue))
    }
}

extension MIDIIOError: CustomStringConvertible {
    public var localizedDescription: String {
        description
    }
    
    public var description: String {
        switch self {
        case let .internalInconsistency(verboseError):
            return verboseError
    
        case let .malformed(verboseError):
            return verboseError
    
        case let .notSupported(verboseError):
            return verboseError
    
        case let .connectionError(verboseError):
            return verboseError
    
        case let .readError(verboseError):
            return verboseError
    
        case let .osStatus(midiOSStatus):
            return midiOSStatus.description
        }
    }
}

#endif
