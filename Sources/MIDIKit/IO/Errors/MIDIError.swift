//
//  MIDIError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

extension MIDI.IO {
    /// Error type returned by `MIDI.IO` methods.
    public enum MIDIError: Error, Hashable {
        // General
        
        case internalInconsistency(_ verboseError: String)
        
        case malformed(_ verboseError: String)
        
        case notSupported(_ verboseError: String)
        
        // Connections
        
        case connectionError(_ verboseError: String)
        
        case readError(_ verboseError: String)
        
        // Core MIDI.OSStatus
        
        case osStatus(MIDI.IO.MIDIOSStatus)
    }
}

extension MIDI.IO.MIDIError {
    /// Internal:
    /// Convenience to return a case of `osStatus` with its associated `MIDI.IO.MIDIOSStatus` formed from a raw Core MIDI `OSStatus` (Int32) integer value.
    internal static func osStatus(_ rawValue: MIDI.IO.CoreMIDIOSStatus) -> Self {
        .osStatus(.init(rawValue: rawValue))
    }
}

extension MIDI.IO.MIDIError: CustomStringConvertible {
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
