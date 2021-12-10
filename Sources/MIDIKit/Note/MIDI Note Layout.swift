//
//  MIDI Note Layout.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI {
    
    public typealias NoteNumberRange = ClosedRange<MIDI.UInt7>
        
}

extension MIDI.NoteNumberRange {
    
    /// All 128 notes (C-2...G8, or 0...127)
    @inline(__always)
    public static let all: Self = 0...127
    
    /// 88-key piano keyboard note range: (A-1...C7, or 12...108)
    @inline(__always)
    public static let eightyEightKeys: Self = 21...108
    
}

extension MIDI {
    
    public typealias NoteRange = ClosedRange<MIDI.Note>
    
}

extension MIDI.NoteRange {
    
    /// All 128 notes (C-2...G8, or 0...127)
    @inline(__always)
    public static let all: Self = MIDI.Note(0)...MIDI.Note(127)
    
    /// 88-key piano keyboard note range: (A-1...C7, or 12...108)
    @inline(__always)
    public static let eightyEightKeys: Self = MIDI.Note(21)...MIDI.Note(108)
    
}

extension MIDI.Note {
    
    public var pianoKey: MIDI.PianoKeyType {
        
        let octaveMod = number % 12
        return [0,2,4,5,7,9,11].contains(octaveMod) ? .white : .black
        
    }
    
}
