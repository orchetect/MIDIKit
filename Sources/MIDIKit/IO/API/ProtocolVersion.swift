//
//  ProtocolVersion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    #warning("> this is currently unused")
    
    /// Enum describing which underlying CoreMIDI API is being used internally.
    public enum ProtocolVersion {
        
        /// MIDI 1.0
        case _1_0
        
        /// MIDI 2.0
        case _2_0
        
    }
    
}
