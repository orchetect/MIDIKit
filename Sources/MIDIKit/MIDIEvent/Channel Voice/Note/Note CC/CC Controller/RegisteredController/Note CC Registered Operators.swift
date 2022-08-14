//
//  Note CC Registered Operators.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.Note.CC.Controller.Registered {
    @inline(__always)
    public static func == <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number == rhs
    }
    
    @inline(__always)
    public static func != <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number != rhs
    }
    
    @inline(__always)
    public static func == <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs == rhs.number
    }
    
    @inline(__always)
    public static func != <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs != rhs.number
    }
}
