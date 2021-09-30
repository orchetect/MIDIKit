//
//  MIDIError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    
    /// Error type returned by `MIDI.IO` methods.
    public enum MIDIError: Error, Hashable {
        
        // General
        
        case internalInconsistency(_ verboseError: String)
        
        case malformed(_ verboseError: String)
        
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
        case .internalInconsistency(let verboseError):
            return verboseError
            
        case .malformed(let verboseError):
            return verboseError
            
        case .connectionError(let verboseError):
            return verboseError
            
        case .readError(let verboseError):
            return verboseError
            
        case .osStatus(let midiOSStatus):
            return midiOSStatus.description
            
        }
        
    }
    
}
