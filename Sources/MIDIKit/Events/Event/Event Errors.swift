//
//  Event Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    public enum ParseError: Error {
        
        case rawBytesEmpty
        
        case malformed
        
        case invalidType
        
    }
    
}
