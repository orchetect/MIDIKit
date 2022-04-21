//
//  ConnectionMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.IO {
    
    /// Behavior of a managed MIDI connection.
    public enum ConnectionMode: Equatable, Hashable {
        
        /// Specific endpoint criteria.
        case definedEndpoints
        
        /// Automatically adds all endpoints in the system and adds any new endpoints that appear in the system at any time thereafter.
        /// (Endpoint filters are respected.)
        case allEndpoints
        
    }
    
}
