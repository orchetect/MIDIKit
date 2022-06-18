//
//  Manager ManagedType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    public enum ManagedType: CaseIterable, Hashable {
        
        case inputConnection
        case outputConnection
        case input
        case output
        case nonPersistentThruConnection
        
    }
    
    public enum TagSelection: Hashable {
        
        case all
        case withTag(String)
        
    }
    
}
