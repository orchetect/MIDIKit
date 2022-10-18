//
//  NoteCC Registered Operators.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NoteCC.PerNoteController.Registered {
    public static func == <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number == rhs
    }
    
    public static func != <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number != rhs
    }
    
    public static func == <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs == rhs.number
    }
    
    public static func != <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs != rhs.number
    }
}
