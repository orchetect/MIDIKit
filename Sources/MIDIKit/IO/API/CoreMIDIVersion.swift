//
//  CoreMIDIVersion.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// Enum describing which underlying CoreMIDI API is being used internally.
    public enum CoreMIDIVersion {
        
        /// Old CoreMIDI API
        ///
        /// Internally using `MIDIPacketList` / `MIDIPacket`.
        case legacy
        
        /// New CoreMIDI API introduced in macOS 11, iOS 14, macCatalyst 14, tvOS 14, and watchOS 7.
        /// ///
        /// Internally using `MIDIEventList` / `MIDIEventPacket`.
        case new
        
    }
    
}
