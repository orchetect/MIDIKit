//
//  ObjectType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.IO {
    
    /// Enum defining a `MIDIIOObjectProtocol`'s MIDI object type.
    public enum ObjectType: CaseIterable, Hashable {
        
        case device
        case entity
        case endpoint
        
    }
    
}
