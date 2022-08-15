//
//  MIDIEvent Errors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    public enum ParseError: Error {
        case rawBytesEmpty
    
        case malformed
    
        case invalidType
    }
}
