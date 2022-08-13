//
//  MIDIEvent Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDIEvent {
    public enum ParseError: Error {
        case rawBytesEmpty
        
        case malformed
        
        case invalidType
    }
}
