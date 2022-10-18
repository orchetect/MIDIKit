//
//  MIDINote Layout.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A closed range representing a span of MIDI note numbers.
public typealias MIDINoteNumberRange = ClosedRange<UInt7>

extension MIDINoteNumberRange {
    /// All 128 notes (`0 ... 127`)
    public static let all: Self = 0 ... 127
    
    /// 88-key piano keyboard note range: (`12 ... 108`)
    public static let eightyEightKeys: Self = 21 ... 108
}

/// A closed range representing a span of MIDI notes.
public typealias MIDINoteRange = ClosedRange<MIDINote>

extension MIDINoteRange {
    /// All 128 notes (`0 ... 127`)
    public static func all(style: MIDINote.Style = .yamaha) -> Self {
        MIDINote(0, style: style) ... MIDINote(127, style: style)
    }
    
    /// 88-key piano keyboard note range: (`12 ... 108`)
    public static func eightyEightKeys(style: MIDINote.Style = .yamaha) -> Self {
        MIDINote(21, style: style) ... MIDINote(108, style: style)
    }
}

extension MIDINote {
    /// Returns `true` if note is sharp (has a ♯ accidental).
    /// On a piano keyboard, this would be a black key.
    public var isSharp: Bool {
        let octaveMod = number % 12
        return [1, 3, 6, 8, 10].contains(octaveMod)
    
        // this also works, but the math above may be slightly more performant,
        // since the `name` property would have to call `Name.convert(noteNumber:)`
        //
        // return name.isSharp
    }
}
