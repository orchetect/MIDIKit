//
//  NoteCC Registered Operators.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NoteCC.PerNoteController.Registered {
    public static func == (lhs: Self, rhs: some BinaryInteger) -> Bool {
        lhs.number == rhs
    }
    
    public static func != (lhs: Self, rhs: some BinaryInteger) -> Bool {
        lhs.number != rhs
    }
    
    public static func == (lhs: some BinaryInteger, rhs: Self) -> Bool {
        lhs == rhs.number
    }
    
    public static func != (lhs: some BinaryInteger, rhs: Self) -> Bool {
        lhs != rhs.number
    }
}
