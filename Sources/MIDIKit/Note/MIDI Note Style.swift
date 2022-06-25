//
//  MIDI Note Style.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

public extension MIDI.Note {
    
    /// MIDI note naming style (octave offset).
    enum Style: Equatable, Hashable, CaseIterable {
        
        /// Yamaha (Middle C == C3)
        ///
        /// Yamaha traditionally chose "C3" to represent MIDI note 60 (Middle C).
        case yamaha
        
        /// Roland (Middle C == C4)
        ///
        /// In 1982 Roland documentation writers chose "C4" to represent MIDI note 60 (Middle C).
        case roland
        
        /// Cakewalk (Middle C == C5)
        ///
        /// Cakewalk originally chose "C5" to represent MIDI note 60 (Middle C).
        ///
        /// Cakewalk started life as a character-based DOS sequencer, and if they’d used "C4" or "C3" for note 60, they’d have needed additional characters on-screen for notating the lower octaves, e.g. "C-2". "C5" in effect sets the lowest octave to octave zero (C0).
        case cakewalk
        
    }
    
}

extension MIDI.Note.Style {
    
    /// Returns the offset from zero for the first octave.
    public var firstOctaveOffset: Int {
        
        switch self {
        case .yamaha:
            return -2
            
        case .roland:
            return -1
            
        case .cakewalk:
            return 0
        }
        
    }
    
}

extension MIDI.Note.Style: CustomStringConvertible {
    
    public var localizedDescription: String {
        
        description
        
    }
    
    public var description: String {
        
        switch self {
        case .yamaha:
            return "Yamaha (Middle C == C3)"
            
        case .roland:
            return "Roland (Middle C == C4)"
            
        case .cakewalk:
            return "Cakewalk (Middle C == C5)"
        }
        
    }
    
}
